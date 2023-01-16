Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753F566C0F7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjAPOGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjAPOFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:05:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D8D227B1;
        Mon, 16 Jan 2023 06:03:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1506FB80F96;
        Mon, 16 Jan 2023 14:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C3BC43392;
        Mon, 16 Jan 2023 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877795;
        bh=hMG8bCwROR3ELbgEiVG9GZVu4p4mu/n4COxPtdzCges=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gykqkx5Ebdoq7a7lEH+qcIKiaYdo+z9HrBgVZElg8jxJcKo0B+zuBjP84Ds9jMxKU
         vQIr5rboybjWm+u4aHdwAo08xrXzwX9mTeOs8yLBkGtyG4+6RSlvTPrOVvbK/TU/4t
         YJHCcdxbAxKN49s5ZitRLYcfoH4MjRPnCt9ybYgKUDZPgouE4JdwHD59b5kh07VyXY
         RSzEPB9kAvfrchoQkcaUEk08NrIorydX5xMIuwd+L2OmJMdDjPKTYKonZSooRvepec
         DOYugAostAr/KqhVsgTUbJRLrhv5rohYOCMbXLXTKbuPTHseVgHjCC6OIG1wmgfJ/z
         Bdg9B6EylEYiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 30/53] tools/nolibc: prevent gcc from making memset() loop over itself
Date:   Mon, 16 Jan 2023 09:01:30 -0500
Message-Id: <20230116140154.114951-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 1bfbe1f3e96720daf185f03d101f072d69753f88 ]

When building on ARM in thumb mode with gcc-11.3 at -O2 or -O3,
nolibc-test segfaults during the select() tests. It turns out that at
this level, gcc recognizes an opportunity for using memset() to zero
the fd_set, but it miscompiles it because it also recognizes a memset
pattern as well, and decides to call memset() from the memset() code:

  000122bc <memset>:
     122bc:       b510            push    {r4, lr}
     122be:       0004            movs    r4, r0
     122c0:       2a00            cmp     r2, #0
     122c2:       d003            beq.n   122cc <memset+0x10>
     122c4:       23ff            movs    r3, #255        ; 0xff
     122c6:       4019            ands    r1, r3
     122c8:       f7ff fff8       bl      122bc <memset>
     122cc:       0020            movs    r0, r4
     122ce:       bd10            pop     {r4, pc}

Simply placing an empty asm() statement inside the loop suffices to
avoid this.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/string.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/string.h b/tools/include/nolibc/string.h
index 0932db3817d2..fffdaf6ff467 100644
--- a/tools/include/nolibc/string.h
+++ b/tools/include/nolibc/string.h
@@ -88,8 +88,11 @@ void *memset(void *dst, int b, size_t len)
 {
 	char *p = dst;
 
-	while (len--)
+	while (len--) {
+		/* prevent gcc from recognizing memset() here */
+		asm volatile("");
 		*(p++) = b;
+	}
 	return dst;
 }
 
-- 
2.35.1

