Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6110E40E228
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhIPQfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243445AbhIPQba (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:31:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28095613CF;
        Thu, 16 Sep 2021 16:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809170;
        bh=d0fHBIfx08XKWD8DTM9jPJ7oQy9BeJaZM42sdC6BiCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvAT4VMXb02HDnTu6K9ZnGCix3Arhmg+gJOhSz7CmV6SDWZB9KTzhYXM3c+zNWmoJ
         B4eMFgZDJ14PMT8HLBevkrJ7DLPIW0EjflKqsRPRflLcSFZKnJlGgv1YBdhC7lprdt
         iqJQEzPPAdiMFQ195vSY3S56YMysu8BQ2ozvaENs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 056/380] io_uring: fail links of cancelled timeouts
Date:   Thu, 16 Sep 2021 17:56:53 +0200
Message-Id: <20210916155805.890592498@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 2ae2eb9dde18979b40629dd413b9adbd6c894cdf upstream.

When we cancel a timeout we should mark it with REQ_F_FAIL, so
linked requests are cancelled as well, but not queued for further
execution.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/fff625b44eeced3a5cae79f60e6acf3fbdf8f990.1631192135.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1307,6 +1307,8 @@ static void io_kill_timeout(struct io_ki
 	struct io_timeout_data *io = req->async_data;
 
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
+		if (status)
+			req_set_fail_links(req);
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);


