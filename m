Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBAF7F2B3
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404999AbfHBJuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391942AbfHBJpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86C2C206A2;
        Fri,  2 Aug 2019 09:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739137;
        bh=mIUD1UpAOTEIUTEwksaaIW6EKVZYhNbc1zhEQXcWRns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5r1jH9frJgid6CO7xmzTH568bkJB4s8QrRfYLYI6gRyDJ+mKvCAS+W52hurI/veL
         XeoCq8lqsHUgtUy22qM/IbQV/AiSPHykBUsWeyEEheHfwnfxqLvP4YeSL/DN0ngTYb
         jqeb5oUy4WzYI1TMlkSTmfspZp1n/zhx36m11I/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 127/223] lib/strscpy: Shut up KASAN false-positives in strscpy()
Date:   Fri,  2 Aug 2019 11:35:52 +0200
Message-Id: <20190802092247.281302082@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1a3241ff10d038ecd096d03380327f2a0b5840a6 ]

strscpy() performs the word-at-a-time optimistic reads.  So it may may
access the memory past the end of the object, which is perfectly fine
since strscpy() doesn't use that (past-the-end) data and makes sure the
optimistic read won't cross a page boundary.

Use new read_word_at_a_time() to shut up the KASAN.

Note that this potentially could hide some bugs.  In example bellow,
stscpy() will copy more than we should (1-3 extra uninitialized bytes):

        char dst[8];
        char *src;

        src = kmalloc(5, GFP_KERNEL);
        memset(src, 0xff, 5);
        strscpy(dst, src, 8);

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index 1cd9757291b1..8f1a2a04e22f 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -202,7 +202,7 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
 	while (max >= sizeof(unsigned long)) {
 		unsigned long c, data;
 
-		c = *(unsigned long *)(src+res);
+		c = read_word_at_a_time(src+res);
 		if (has_zero(c, &data, &constants)) {
 			data = prep_zero_mask(c, data, &constants);
 			data = create_zero_mask(data);
-- 
2.20.1



