Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD64BE337
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbiBUJ22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:28:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349099AbiBUJ1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DA8DF5E;
        Mon, 21 Feb 2022 01:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33ED7608C4;
        Mon, 21 Feb 2022 09:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19014C340E9;
        Mon, 21 Feb 2022 09:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434732;
        bh=Tmzs7DreLGoEQ0nImRKQ4cV5zyQ0u3xWsJnDnMuHTv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dkjx292MdkQb2n/hz75MYJ7DTYJ5gPQQkKm0DoeiV+AaaYgrJEH+tsMB545IafjB+
         DbLLHhfXP8bBIK13yxxYvfaL4aADBgjgHGmd+s+9oACR4/iwGvPVOH7uQB9HE4R30e
         Jd504XybcvH9lZ3apRSW6ah3AG88A8HuZpfvF15g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 110/196] arm64: Correct wrong label in macro __init_el2_gicv3
Date:   Mon, 21 Feb 2022 09:49:02 +0100
Message-Id: <20220221084934.619435963@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Joakim Tjernlund <joakim.tjernlund@infinera.com>

commit 4f6de676d94ee8ddfc2e7e7cd935fc7cb2feff3a upstream.

In commit:

  114945d84a30a5fe ("arm64: Fix labels in el2_setup macros")

We renamed a label from '1' to '.Lskip_gicv3_\@', but failed to update
a branch to it, which now targets a later label also called '1'.

The branch is taken rarely, when GICv3 is present but SRE is disabled
at EL3, causing a boot-time crash.

Update the caller to the new label name.

Fixes: 114945d84a30 ("arm64: Fix labels in el2_setup macros")
Cc: <stable@vger.kernel.org> # 5.12.x
Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Link: https://lore.kernel.org/r/20220214175643.21931-1-joakim.tjernlund@infinera.com
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/el2_setup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -106,7 +106,7 @@
 	msr_s	SYS_ICC_SRE_EL2, x0
 	isb					// Make sure SRE is now set
 	mrs_s	x0, SYS_ICC_SRE_EL2		// Read SRE back,
-	tbz	x0, #0, 1f			// and check that it sticks
+	tbz	x0, #0, .Lskip_gicv3_\@		// and check that it sticks
 	msr_s	SYS_ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
 .Lskip_gicv3_\@:
 .endm


