Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B1D4F69D4
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiDFT3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiDFT1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:27:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CE329AD11;
        Wed,  6 Apr 2022 11:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22EC3B8253C;
        Wed,  6 Apr 2022 18:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5A3C385A1;
        Wed,  6 Apr 2022 18:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269728;
        bh=0q7wD0vcPl/Ff02yht4/GoSLWsNAhcDXnV/2urXfmmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUxdlVpA/AXolIuwTGrDp1rHijLB+1FEd3iDwGzJUjnw3SqeTilWNkByU9HpT+9qO
         Wj+Zd9Ioa/QGw299oWMI7FIC3aKlZXP62G2uE32BpZvnMTJzbic2W2bw8vFh30Fnci
         yu2dn2gck8Zoev2htPNMrt8ANqRc0BTgKLG+Eg0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 35/43] arm64: Move arm64_update_smccc_conduit() out of SSBD ifdef
Date:   Wed,  6 Apr 2022 20:26:44 +0200
Message-Id: <20220406182437.700348181@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
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

From: James Morse <james.morse@arm.com>

arm64_update_smccc_conduit() is an alternative callback that patches
HVC/SMC. Currently the only user is SSBD. To use this for Spectre-BHB,
it needs to be moved out of the SSBD #ifdef region.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |   44 ++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -204,6 +204,28 @@ enable_smccc_arch_workaround_1(const str
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
+void __init arm64_update_smccc_conduit(struct alt_instr *alt,
+				       __le32 *origptr, __le32 *updptr,
+				       int nr_inst)
+{
+	u32 insn;
+
+	BUG_ON(nr_inst != 1);
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		insn = aarch64_insn_get_hvc_value();
+		break;
+	case PSCI_CONDUIT_SMC:
+		insn = aarch64_insn_get_smc_value();
+		break;
+	default:
+		return;
+	}
+
+	*updptr = cpu_to_le32(insn);
+}
+
 #ifdef CONFIG_ARM64_SSBD
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
@@ -239,28 +261,6 @@ static int __init ssbd_cfg(char *buf)
 }
 early_param("ssbd", ssbd_cfg);
 
-void __init arm64_update_smccc_conduit(struct alt_instr *alt,
-				       __le32 *origptr, __le32 *updptr,
-				       int nr_inst)
-{
-	u32 insn;
-
-	BUG_ON(nr_inst != 1);
-
-	switch (psci_ops.conduit) {
-	case PSCI_CONDUIT_HVC:
-		insn = aarch64_insn_get_hvc_value();
-		break;
-	case PSCI_CONDUIT_SMC:
-		insn = aarch64_insn_get_smc_value();
-		break;
-	default:
-		return;
-	}
-
-	*updptr = cpu_to_le32(insn);
-}
-
 void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 				      __le32 *origptr, __le32 *updptr,
 				      int nr_inst)


