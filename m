Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4924695D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgHQPU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgHQPUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:20:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE9920729;
        Mon, 17 Aug 2020 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677651;
        bh=ZQqVU7TG/KpLcPr0o/0mZ3eI0AAOkC63u17RKU6K1lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ9lE/uw/pVaEbSP5J41Zs2Q/K/3vwu5ea7Sm3dAL7bFsr3R//8QcYTE+6a3L/Fku
         IcRczP5BezhIjvHinMHcq2F+Pk2eqzTiSuVcDBkaIOLLh7nkRBvEAEyGuRuUyuTM3L
         dw+t4I4PTOywe/cs7atFcBRvu/V+kWsTHGyxjMkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Hristo Venev <hristo@venev.name>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 052/464] io_uring: fix sq array offset calculation
Date:   Mon, 17 Aug 2020 17:10:05 +0200
Message-Id: <20200817143836.252163777@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit b36200f543ff07a1cb346aa582349141df2c8068 ]

rings_size() sets sq_offset to the total size of the rings (the returned
value which is used for memory allocation). This is wrong: sq array should
be located within the rings, not after them. Set sq_offset to where it
should be.

Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Hristo Venev <hristo@venev.name>
Cc: io-uring@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95bacab047ddb..8503aec7ea295 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7093,6 +7093,9 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 		return SIZE_MAX;
 #endif
 
+	if (sq_offset)
+		*sq_offset = off;
+
 	sq_array_size = array_size(sizeof(u32), sq_entries);
 	if (sq_array_size == SIZE_MAX)
 		return SIZE_MAX;
@@ -7100,9 +7103,6 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 	if (check_add_overflow(off, sq_array_size, &off))
 		return SIZE_MAX;
 
-	if (sq_offset)
-		*sq_offset = off;
-
 	return off;
 }
 
-- 
2.25.1



