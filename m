Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83A7171DC6
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388546AbgB0OO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:14:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388878AbgB0OO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:14:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95CC3246A0;
        Thu, 27 Feb 2020 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812899;
        bh=FmL2HZUJWqF4uuxfA+wfKGW4NprK4iM8qkjpgkC6w2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvFM63qVgvWPvnJ1B/XGiJyz36tKDoKmhBgK/Yi7rbPT06UiGE+ReOxEhPZv9ZIiJ
         AKhlGIJ0jnXHWLnpCEtm4HnnbBbLsYTFbxpgkELVDi9q/KLBV3kQVxdrBIyWS0iv8m
         mimAcHBypXfEiXJGaA4B7oxKTwFleH8WLG9J5NYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.5 057/150] arm64: memory: Add missing brackets to untagged_addr() macro
Date:   Thu, 27 Feb 2020 14:36:34 +0100
Message-Id: <20200227132241.501980869@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit d0022c0ef29b78bcbe8a5c5894bd2307143afce1 upstream.

Add brackets around the evaluation of the 'addr' parameter to the
untagged_addr() macro so that the cast to 'u64' applies to the result
of the expression.

Cc: <stable@vger.kernel.org>
Fixes: 597399d0cb91 ("arm64: tags: Preserve tags for addresses translated via TTBR1")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -213,7 +213,7 @@ static inline unsigned long kaslr_offset
 	((__force __typeof__(addr))sign_extend64((__force u64)(addr), 55))
 
 #define untagged_addr(addr)	({					\
-	u64 __addr = (__force u64)addr;					\
+	u64 __addr = (__force u64)(addr);					\
 	__addr &= __untagged_addr(__addr);				\
 	(__force __typeof__(addr))__addr;				\
 })


