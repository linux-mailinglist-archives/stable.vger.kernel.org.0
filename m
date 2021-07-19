Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74F3CE0D9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346954AbhGSPSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346596AbhGSPOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367EA610FB;
        Mon, 19 Jul 2021 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710124;
        bh=10RNsTQrpkHSe4TnEWFup4u2UnNAxuJ9x0CMgCgE4Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2M/TSot0RUVcDg8SeWYQbS5dGS+KKNCSb/+F+WqOE01bAPUaRsQ7JEFnCOjDP3TO
         agavjOwtKJmqExGO1OKhSKHxtD51snUuPuqHydi4pH7zyVC3vdYLa/aIhjHAbrmxMa
         TfcIlBSSZq4a3gRkVGP7vV0phfLVBfsLIHt6Iu7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/243] s390/processor: always inline stap() and __load_psw_mask()
Date:   Mon, 19 Jul 2021 16:51:56 +0200
Message-Id: <20210719144943.703374080@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9c9a915afd90f7534c16a71d1cd44b58596fddf3 ]

s390 is the only architecture which makes use of the __no_kasan_or_inline
attribute for two functions. Given that both stap() and __load_psw_mask()
are very small functions they can and should be always inlined anyway.

Therefore get rid of __no_kasan_or_inline and always inline these
functions.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 962da04234af..0987c3fc45f5 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -211,7 +211,7 @@ static __always_inline unsigned long current_stack_pointer(void)
 	return sp;
 }
 
-static __no_kasan_or_inline unsigned short stap(void)
+static __always_inline unsigned short stap(void)
 {
 	unsigned short cpu_address;
 
@@ -250,7 +250,7 @@ static inline void __load_psw(psw_t psw)
  * Set PSW mask to specified value, while leaving the
  * PSW addr pointing to the next instruction.
  */
-static __no_kasan_or_inline void __load_psw_mask(unsigned long mask)
+static __always_inline void __load_psw_mask(unsigned long mask)
 {
 	unsigned long addr;
 	psw_t psw;
-- 
2.30.2



