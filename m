Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7576431DC
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiLETVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiLETUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:20:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAEA2648C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:17:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FAE56131B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE68C433C1;
        Mon,  5 Dec 2022 19:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267826;
        bh=20gz2zbssPx3qCRshRvUNl8OWi6q0UMNmaa8g2SpoR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYtIPgJv7unCyeFTBFb3ar6+5bXSJ6GjF4JrF6u+8Y1tGS46ldiiuPxBmqIoeGj/P
         sh1q5Ptkt+m+qiTTNmVr6pme1dW0giG8R/muF9ajCBxakqx0bcX8wPrBaCuoh1Pr6P
         Ylb08b1GJyCDgfxvZ4Lyb893J72TmseQpUqcsQmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 65/77] arm64: errata: Fix KVM Spectre-v2 mitigation selection for Cortex-A57/A72
Date:   Mon,  5 Dec 2022 20:09:56 +0100
Message-Id: <20221205190803.154641906@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

Both the Spectre-v2 and Spectre-BHB mitigations involve running a sequence
immediately after exiting a guest, before any branches. In the stable
kernels these sequences are built by copying templates into an empty vector
slot.

For Spectre-BHB, Cortex-A57 and A72 require the branchy loop with k=8.
If Spectre-v2 needs mitigating at the same time, a firmware call to EL3 is
needed. The work EL3 does at this point is also enough to mitigate
Spectre-BHB.

When enabling the Spectre-BHB mitigation, spectre_bhb_enable_mitigation()
should check if a slot has already been allocated for Spectre-v2, meaning
no work is needed for Spectre-BHB.

This check was missed in the earlier backport, add it.

Fixes: 3e3904125fcc ("arm64: Mitigate spectre style branch history side channels")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -1104,7 +1104,13 @@ void spectre_bhb_enable_mitigation(const
 	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
 		switch (spectre_bhb_loop_affected(SCOPE_SYSTEM)) {
 		case 8:
-			kvm_setup_bhb_slot(__spectre_bhb_loop_k8_start);
+			/*
+			 * A57/A72-r0 will already have selected the
+			 * spectre-indirect vector, which is sufficient
+			 * for BHB too.
+			 */
+			if (!__this_cpu_read(bp_hardening_data.fn))
+				kvm_setup_bhb_slot(__spectre_bhb_loop_k8_start);
 			break;
 		case 24:
 			kvm_setup_bhb_slot(__spectre_bhb_loop_k24_start);


