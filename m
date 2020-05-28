Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D601E6059
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388662AbgE1L4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388651AbgE1L4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C7D1212CC;
        Thu, 28 May 2020 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666974;
        bh=muJTA8gw92hC3PZu1PneM6mFIFDrGyL77weaKHDumjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nl0BrdEOUikQw7yeqYjmMwOV3FrrpSyfAu4q5lUcuqSVXF3hxl7AoiTFvqBbEEcri
         IzFDf7GWAuXusAuKQr0Lb7fDGUqR+FoZsHq/icXcfgKG1iJf4oy9lVzP/PXSj5GLLj
         r03dXhyjhcZ/q1jN2QHdWhEnVRNYCqK+akyK0k4E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 12/47] io_uring: fix FORCE_ASYNC req preparation
Date:   Thu, 28 May 2020 07:55:25 -0400
Message-Id: <20200528115600.1405808-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

