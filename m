Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE132911E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243248AbhCAUTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:19:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238630AbhCAUMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:12:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7200A6505C;
        Mon,  1 Mar 2021 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621674;
        bh=0z3WB6fxxIRpXJVqt7kYMNPzomhDGaiSxTU+Sip1pak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFjXK6tzDyUd4Pl4KuTHpdgXfM6WyGEm7Y58pK9Y9wLSFrv//sELPUVlaWT2B9Gc6
         7LONq77RrfIUmUs0SyZ97f974c4el2/MPm1HqJWwV19PvhtB6HmxmpJla3B1JJYkr/
         yHZ9y9xpwOwwOegZUQDbYKk8sVTpF/HMgVYDacug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.11 603/775] MIPS: Ingenic: Disable HPTLB for D0 XBurst CPUs too
Date:   Mon,  1 Mar 2021 17:12:51 +0100
Message-Id: <20210301161231.207959296@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit a5360958a3cd1d876aae1f504ae014658513e1af upstream.

The JZ4760 has the HPTLB as well, but has a XBurst CPU with a D0 CPUID.

Disable the HPTLB for all XBurst CPUs with a D0 CPUID. In the case where
there is no HPTLB (e.g. for older SoCs), this won't have any side
effect.

Fixes: b02efeb05699 ("MIPS: Ingenic: Disable abandoned HPTLB function.")
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/cpu-probe.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1830,16 +1830,17 @@ static inline void cpu_probe_ingenic(str
 		 */
 		case PRID_COMP_INGENIC_D0:
 			c->isa_level &= ~MIPS_CPU_ISA_M32R2;
-			break;
+			fallthrough;
 
 		/*
 		 * The config0 register in the XBurst CPUs with a processor ID of
-		 * PRID_COMP_INGENIC_D1 has an abandoned huge page tlb mode, this
-		 * mode is not compatible with the MIPS standard, it will cause
-		 * tlbmiss and into an infinite loop (line 21 in the tlb-funcs.S)
-		 * when starting the init process. After chip reset, the default
-		 * is HPTLB mode, Write 0xa9000000 to cp0 register 5 sel 4 to
-		 * switch back to VTLB mode to prevent getting stuck.
+		 * PRID_COMP_INGENIC_D0 or PRID_COMP_INGENIC_D1 has an abandoned
+		 * huge page tlb mode, this mode is not compatible with the MIPS
+		 * standard, it will cause tlbmiss and into an infinite loop
+		 * (line 21 in the tlb-funcs.S) when starting the init process.
+		 * After chip reset, the default is HPTLB mode, Write 0xa9000000
+		 * to cp0 register 5 sel 4 to switch back to VTLB mode to prevent
+		 * getting stuck.
 		 */
 		case PRID_COMP_INGENIC_D1:
 			write_c0_page_ctrl(XBURST_PAGECTRL_HPTLB_DIS);


