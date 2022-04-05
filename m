Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8384F30FD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350170AbiDEJzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243108AbiDEJIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30C492D25;
        Tue,  5 Apr 2022 01:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F58061511;
        Tue,  5 Apr 2022 08:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FCCC385A1;
        Tue,  5 Apr 2022 08:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149059;
        bh=SNPnTU2FhR3/j1aygeZyiR4/bDRnquHv0PF8lxvepnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtwjLdJLuPdtR3DSi6jPUbpjvP3b6Z7tHkinVCKeUJEnw7NgxlbH1CmCtTuI0CL3N
         8gogzBiBPyXoRE0FCOcwR6/+7WpLqi9+8LeX9miKhbmxClj4rb3Ak70DwJTjwIjyp6
         H2MjtJeHqBGbw+I18GLgvNXXU25Y1asU5BLIf5X4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0578/1017] MIPS: Sanitise Cavium switch cases in TLB handler synthesizers
Date:   Tue,  5 Apr 2022 09:24:51 +0200
Message-Id: <20220405070411.436808823@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 6ddcba9d480b6bcced4223a729794dfa6becb7eb ]

It makes no sense to fall through to `break'.  Therefore reorder the
switch statements so as to have the Cavium cases first, followed by the
default case, which improves readability and pacifies code analysis
tools.  No change in semantics, assembly produced is exactly the same.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: bc431d2153cc ("MIPS: Fix fall-through warnings for Clang")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlbex.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index b131e6a77383..5cda07688f67 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -2160,16 +2160,14 @@ static void build_r4000_tlb_load_handler(void)
 		uasm_i_tlbr(&p);
 
 		switch (current_cpu_type()) {
-		default:
-			if (cpu_has_mips_r2_exec_hazard) {
-				uasm_i_ehb(&p);
-			fallthrough;
-
 		case CPU_CAVIUM_OCTEON:
 		case CPU_CAVIUM_OCTEON_PLUS:
 		case CPU_CAVIUM_OCTEON2:
-				break;
-			}
+			break;
+		default:
+			if (cpu_has_mips_r2_exec_hazard)
+				uasm_i_ehb(&p);
+			break;
 		}
 
 		/* Examine  entrylo 0 or 1 based on ptr. */
@@ -2236,15 +2234,14 @@ static void build_r4000_tlb_load_handler(void)
 		uasm_i_tlbr(&p);
 
 		switch (current_cpu_type()) {
-		default:
-			if (cpu_has_mips_r2_exec_hazard) {
-				uasm_i_ehb(&p);
-
 		case CPU_CAVIUM_OCTEON:
 		case CPU_CAVIUM_OCTEON_PLUS:
 		case CPU_CAVIUM_OCTEON2:
-				break;
-			}
+			break;
+		default:
+			if (cpu_has_mips_r2_exec_hazard)
+				uasm_i_ehb(&p);
+			break;
 		}
 
 		/* Examine  entrylo 0 or 1 based on ptr. */
-- 
2.34.1



