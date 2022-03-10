Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250C74D4B55
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbiCJOeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344053AbiCJObj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E637FEC5EA;
        Thu, 10 Mar 2022 06:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28BDE61C0A;
        Thu, 10 Mar 2022 14:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDD7C340E8;
        Thu, 10 Mar 2022 14:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922576;
        bh=EPZxsixiCZjs6ziUXvhGG6X9Ka3rBtJn1D845WN6Y/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWWhKvds4FQV0bs4Bvz6qA8pbgd8vdo6+knlGoWXXITM+0TfXxVeEKveZfmjHeLSi
         jb/8IgBw3pmJI6I1OII3zwCkoQmgXgm+LJaThe+g7HF9eSaVm0FDvwNhD0W8M94zmh
         iGLtv8j/TIxbH/V4tu6rTEvRNgHV8Bw0sInymTLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 23/58] arm64: spectre: Rename spectre_v4_patch_fw_mitigation_conduit
Date:   Thu, 10 Mar 2022 15:19:12 +0100
Message-Id: <20220310140813.650924197@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
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
@@ -118,7 +118,7 @@ alternative_cb_end
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
@@ -554,9 +554,9 @@ void __init spectre_v4_patch_fw_mitigati
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
 


