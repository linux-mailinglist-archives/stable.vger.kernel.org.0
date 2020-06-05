Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30721EFA4E
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgFEOQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728234AbgFEOQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 347DE2086A;
        Fri,  5 Jun 2020 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366589;
        bh=muJTA8gw92hC3PZu1PneM6mFIFDrGyL77weaKHDumjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JH+KM/Smhzp0bxO8BYuzWt/fCiAnyNvV/nOBw53XJ5t0xDR1Qfoyp4IG7EfkxSGOY
         eHfZHi3EVDL+k4qhM09nHkhzMKqni4HbItMb6TGFNHQAlys+qdDBxf77uChRpR4WVw
         uKEGmQ7hMcV+fcXMu2ia4U7VsR5meSYTj23KU5pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 14/43] io_uring: fix FORCE_ASYNC req preparation
Date:   Fri,  5 Jun 2020 16:14:44 +0200
Message-Id: <20200605140153.269887611@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit bd2ab18a1d6267446eae1b47dd839050452bdf7f ]

As for other not inlined requests, alloc req->io for FORCE_ASYNC reqs,
so they can be prepared properly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aa800f70c55e..504484dc33e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4823,9 +4823,15 @@ fail_req:
 			io_double_put_req(req);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
-		ret = io_req_defer_prep(req, sqe);
-		if (unlikely(ret < 0))
-			goto fail_req;
+		if (!req->io) {
+			ret = -EAGAIN;
+			if (io_alloc_async_ctx(req))
+				goto fail_req;
+			ret = io_req_defer_prep(req, sqe);
+			if (unlikely(ret < 0))
+				goto fail_req;
+		}
+
 		/*
 		 * Never try inline submit of IOSQE_ASYNC is set, go straight
 		 * to async execution.
-- 
2.25.1



