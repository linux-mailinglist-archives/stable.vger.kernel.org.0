Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0E14D4BDE
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbiCJOcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244709AbiCJO3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:29:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3F0DB86B;
        Thu, 10 Mar 2022 06:24:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADF3761D38;
        Thu, 10 Mar 2022 14:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DE7C340E8;
        Thu, 10 Mar 2022 14:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922268;
        bh=eNC2LoRSShxShPBQOu9Ekx31Np/dRyimoxlehhvsvm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbmaiZH6UITUMjQOaYaOnblJpZD9Ur+w86WTviJMSGcflIMm9TS3St24DCm5MuCbs
         itBMdHN4cCWtHmB72A5QcJfXAfeINgbruuk93VQ0Lc4y5WsoM0UJfzbMJGP85IzClD
         SaC5Ji+r0TEc/S1SuuilI8OMSojqU/7+jGo+hx8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 24/58] arm64: spectre: Rename spectre_v4_patch_fw_mitigation_conduit
Date:   Thu, 10 Mar 2022 15:18:44 +0100
Message-Id: <20220310140813.565133100@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 1b33d4860deaecf1d8eec3061b7e7ed7ab0bae8d upstream.

The spectre-v4 sequence includes an SMC from the assembly entry code.
spectre_v4_patch_fw_mitigation_conduit is the patching callback that
generates an HVC or SMC depending on the SMCCC conduit type.

As this isn't specific to spectre-v4, rename it
smccc_patch_fw_mitigation_conduit so it can be re-used.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S       |    2 +-
 arch/arm64/kernel/proton-pack.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -143,7 +143,7 @@ alternative_cb_end
 	tbnz	\tmp2, #TIF_SSBD, .L__asm_ssbd_skip\@
 	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
 	mov	w1, #\state
-alternative_cb	spectre_v4_patch_fw_mitigation_conduit
+alternative_cb	smccc_patch_fw_mitigation_conduit
 	nop					// Patched to SMC/HVC #0
 alternative_cb_end
 .L__asm_ssbd_skip\@:
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -571,9 +571,9 @@ void __init spectre_v4_patch_fw_mitigati
  * Patch a NOP in the Spectre-v4 mitigation code with an SMC/HVC instruction
  * to call into firmware to adjust the mitigation state.
  */
-void __init spectre_v4_patch_fw_mitigation_conduit(struct alt_instr *alt,
-						   __le32 *origptr,
-						   __le32 *updptr, int nr_inst)
+void __init smccc_patch_fw_mitigation_conduit(struct alt_instr *alt,
+					       __le32 *origptr,
+					       __le32 *updptr, int nr_inst)
 {
 	u32 insn;
 


