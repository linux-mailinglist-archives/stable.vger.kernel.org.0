Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5D0206337
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389494AbgFWUTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389502AbgFWUTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F8102064B;
        Tue, 23 Jun 2020 20:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943564;
        bh=I6luucVQ/RvWKJMjcf6wsO+IqM0rK3XV7Z18eyF1nDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrBKps+Q8H5nQdgOu4UuPSnosqEDN9b/wKhGHTmIWbqaYohhgOiOa8dx6s6U6PtKl
         CMtAttyZpzVIoxe+Buu5XUP0UjLd7gPUz32x3M+aK6hwpmSG/BI9tQ8hHvh5NgnRyf
         6Yhl1z2gGq0GHCwjBkonD0JHUYi0WnRZSxu+txaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 434/477] io_uring: reap poll completions while waiting for refs to drop on exit
Date:   Tue, 23 Jun 2020 21:57:11 +0200
Message-Id: <20200623195428.044800115@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 56952e91acc93ed624fe9da840900defb75f1323 ]

If we're doing polled IO and end up having requests being submitted
async, then completions can come in while we're waiting for refs to
drop. We need to reap these manually, as nobody else will be looking
for them.

Break the wait into 1/20th of a second time waits, and check for done
poll completions if we time out. Otherwise we can have done poll
completions sitting in ctx->poll_list, which needs us to reap them but
we're just waiting for them.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7404,7 +7404,17 @@ static void io_ring_exit_work(struct wor
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
 
-	wait_for_completion(&ctx->completions[0]);
+	/*
+	 * If we're doing polled IO and end up having requests being
+	 * submitted async (out-of-line), then completions can come in while
+	 * we're waiting for refs to drop. We need to reap these manually,
+	 * as nobody else will be looking for them.
+	 */
+	while (!wait_for_completion_timeout(&ctx->completions[0], HZ/20)) {
+		io_iopoll_reap_events(ctx);
+		if (ctx->rings)
+			io_cqring_overflow_flush(ctx, true);
+	}
 	io_ring_ctx_free(ctx);
 }
 


