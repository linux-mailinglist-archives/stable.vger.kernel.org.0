Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8971A2899C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390184AbfEWTVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389795AbfEWTVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:21:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE72D217D7;
        Thu, 23 May 2019 19:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639266;
        bh=Eck07YnScN80rAFi0HLkukX6wfzOilhLgDStDYeWIPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVyHu65rf1bRsJt/Ca4CXtGUfgtIpNiV90VwO47bOiytmGdFWbNCNoAhCGr6cUBUi
         w0RrMLA7RJAcJ7jG/4/saMzrcX4mwBPcQm9DB9EulIy80FfV3UXtyfQrY8D7aIv+9E
         7pErYmM8gA/D3wToXyBX6zHOPjVaMLqVJPIEWXAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.0 023/139] parisc: Add memory clobber to TLB purges
Date:   Thu, 23 May 2019 21:05:11 +0200
Message-Id: <20190523181723.760609084@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit 44224bdb99150ad17cf394973b25736cb92c246a upstream.

The pdtlb and pitlb instructions are strongly ordered. The asms invoking
these instructions should be compiler memory barriers to ensure the
compiler doesn't reorder memory operations around these instructions.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
CC: stable@vger.kernel.org # v4.20+
Fixes: 3847dab77421 ("parisc: Add alternative coding infrastructure")
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/cache.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -44,14 +44,14 @@ void parisc_setup_cache_timing(void);
 
 #define pdtlb(addr)	asm volatile("pdtlb 0(%%sr1,%0)" \
 			ALTERNATIVE(ALT_COND_NO_SMP, INSN_PxTLB) \
-			: : "r" (addr))
+			: : "r" (addr) : "memory")
 #define pitlb(addr)	asm volatile("pitlb 0(%%sr1,%0)" \
 			ALTERNATIVE(ALT_COND_NO_SMP, INSN_PxTLB) \
 			ALTERNATIVE(ALT_COND_NO_SPLIT_TLB, INSN_NOP) \
-			: : "r" (addr))
+			: : "r" (addr) : "memory")
 #define pdtlb_kernel(addr)  asm volatile("pdtlb 0(%0)"   \
 			ALTERNATIVE(ALT_COND_NO_SMP, INSN_PxTLB) \
-			: : "r" (addr))
+			: : "r" (addr) : "memory")
 
 #define asm_io_fdc(addr) asm volatile("fdc %%r0(%0)" \
 			ALTERNATIVE(ALT_COND_NO_DCACHE, INSN_NOP) \


