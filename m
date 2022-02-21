Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A544BDBCA
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351129AbiBUJvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:51:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351618AbiBUJtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:49:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6ED34B83;
        Mon, 21 Feb 2022 01:22:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 37C62CE0EA3;
        Mon, 21 Feb 2022 09:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD64C340EB;
        Mon, 21 Feb 2022 09:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435354;
        bh=Tmzs7DreLGoEQ0nImRKQ4cV5zyQ0u3xWsJnDnMuHTv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU4F6uCYPo8VUFXT3DaJTpQug4jV2Udlw6HI2wZC05XytGgdD0eaS9gdK0RVN6HrS
         DCosNNaFP+GL84Su/ps2QZdhgn8Ha5PyV64htWaQiC5nU//9KMfLKfh5gJE79oE3R3
         GCxOaDup9gYWiPqZhA8thP3RkjPaAKbdGq1LW7fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.16 134/227] arm64: Correct wrong label in macro __init_el2_gicv3
Date:   Mon, 21 Feb 2022 09:49:13 +0100
Message-Id: <20220221084939.310749667@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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


