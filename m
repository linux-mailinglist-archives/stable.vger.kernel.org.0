Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FB4247166
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390858AbgHQS0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388182AbgHQQCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:02:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88F8320748;
        Mon, 17 Aug 2020 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680134;
        bh=8i3CtQAPuU1twb1leZ/bbgci4RstGW3qJZBvatEKWmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8r1C2e1J/LurayPt3ZR/zG6xC9uDHYQ/JNzHMRRFJqhixYoUNfKYcQTBAkv6g5jB
         ZYTfeZMWIiuftfbX4Qz5Mjx5kQOOuI/TKU2KBboEP0ssv5VZDNnRUAva/nqVXzE713
         DX7oDcCG7a92F0m1jXSgbnfVEIcbOngjMf79UgLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Hristo Venev <hristo@venev.name>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/270] io_uring: fix sq array offset calculation
Date:   Mon, 17 Aug 2020 17:13:56 +0200
Message-Id: <20200817143757.543949030@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index c1aaee061dae5..0460420250255 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3391,6 +3391,9 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 		return SIZE_MAX;
 #endif
 
+	if (sq_offset)
+		*sq_offset = off;
+
 	sq_array_size = array_size(sizeof(u32), sq_entries);
 	if (sq_array_size == SIZE_MAX)
 		return SIZE_MAX;
@@ -3398,9 +3401,6 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 	if (check_add_overflow(off, sq_array_size, &off))
 		return SIZE_MAX;
 
-	if (sq_offset)
-		*sq_offset = off;
-
 	return off;
 }
 
-- 
2.25.1



