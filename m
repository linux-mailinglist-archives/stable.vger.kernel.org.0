Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609F11ACAF0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896093AbgDPNhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897389AbgDPNg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:36:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F075E221EB;
        Thu, 16 Apr 2020 13:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044217;
        bh=12ZmjrZ7vXDZ1I0Fi1c7lbqZUkrXG04AQoXKts4YLE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcx5Acq2+NVDxYqrKkmJtUi9EG/VnahfL6cYcMCnrnvQMD2eQ4XRITPphf8TIltZe
         VFj6XonX04weX70jXrLTrHFI0gBcCk3omSShm16/lP34IBCc/+xgV5zG8S9/1Oqltu
         clv1v66Bq2/1QiOVtUtyiuvwqwK3nrgxF45B2WoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 129/257] io_uring: remove bogus RLIMIT_NOFILE check in file registration
Date:   Thu, 16 Apr 2020 15:23:00 +0200
Message-Id: <20200416131342.528363405@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c336e992cb1cb1db9ee608dfb30342ae781057ab upstream.

We already checked this limit when the file was opened, and we keep it
open in the file table. Hence when we added unit_inflight to the count
we want to register, we're doubly accounting these files. This results
in -EMFILE for file registration, if we're at half the limit.

Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4162,13 +4162,6 @@ static int __io_sqe_files_scm(struct io_
 	struct sk_buff *skb;
 	int i, nr_files;
 
-	if (!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
-		unsigned long inflight = ctx->user->unix_inflight + nr;
-
-		if (inflight > task_rlimit(current, RLIMIT_NOFILE))
-			return -EMFILE;
-	}
-
 	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
 	if (!fpl)
 		return -ENOMEM;


