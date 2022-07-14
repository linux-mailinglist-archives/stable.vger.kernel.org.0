Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5714E5742BB
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbiGNE0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbiGNEZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:25:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160852A96C;
        Wed, 13 Jul 2022 21:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E245C61E90;
        Thu, 14 Jul 2022 04:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766F0C34114;
        Thu, 14 Jul 2022 04:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772605;
        bh=TqZD68mi36gm9aiOSQeCq3F2D3ZSF1PXzG4Ef1OaD6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGxykcsNy3p1QIUnS4/EZEoVBLncppL1tsl9PadOT1hhnhZZL88P7z4zlg6beQy3d
         GPoMU7oxHPvX7MyhNVHFdlCI3lzL2zDP754TeoJ1m/jvUa/sxQzmStljMMk0+OL9fH
         gtWWUZZ9U2RY2xCRlpX+DTzMjkfjZIIdjgLH2bXsRm8PqyfTeIQq1/U0b6GbiZEyAC
         rDvkglNaN+0d5XKT8Q6HiCB4BTzFa550sSirzDHTUzyfySK/VZikwRTMoMsGpYxAtr
         YDKhu+nHUNDm3T1TTt0AzrkHXRISFuQ7PATF8qrQHlvFGQ7OcJSuXMDBWAu0Oj676e
         DTQY7uhGupTVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stafford Horne <shorne@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jonas@southpole.se,
        stefan.kristiansson@saunalahti.fi, tglx@linutronix.de,
        openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 5.18 26/41] irqchip: or1k-pic: Undefine mask_ack for level triggered hardware
Date:   Thu, 14 Jul 2022 00:22:06 -0400
Message-Id: <20220714042221.281187-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 8520501346ed8d1c4a6dfa751cb57328a9c843f1 ]

The mask_ack operation clears the interrupt by writing to the PICSR
register.  This we don't want for level triggered interrupt because
it does not actually clear the interrupt on the source hardware.

This was causing issues in qemu with multi core setups where
interrupts would continue to fire even though they had been cleared in
PICSR.

Just remove the mask_ack operation.

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-or1k-pic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/irqchip/irq-or1k-pic.c b/drivers/irqchip/irq-or1k-pic.c
index 49b47e787644..f289ccd95291 100644
--- a/drivers/irqchip/irq-or1k-pic.c
+++ b/drivers/irqchip/irq-or1k-pic.c
@@ -66,7 +66,6 @@ static struct or1k_pic_dev or1k_pic_level = {
 		.name = "or1k-PIC-level",
 		.irq_unmask = or1k_pic_unmask,
 		.irq_mask = or1k_pic_mask,
-		.irq_mask_ack = or1k_pic_mask_ack,
 	},
 	.handle = handle_level_irq,
 	.flags = IRQ_LEVEL | IRQ_NOPROBE,
-- 
2.35.1

