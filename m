Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316BF57438D
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiGNEgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237516AbiGNEfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:35:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC0B3C8EB;
        Wed, 13 Jul 2022 21:26:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2283161EC5;
        Thu, 14 Jul 2022 04:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A322C341C6;
        Thu, 14 Jul 2022 04:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772786;
        bh=2qjO8+odQ7oxEl1fALycalDewY6Q0DjTfZWWlCdvWKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STHeHZNpG2mlyLgQ9phKf/k5Fdjdvdq6qBJLvnOVSbHPDd0uoz29542z2iG7Bg7UD
         AKiDzPEhVH87ey6+7WjsphBFl/kjVWyGahjV0JAKMPjd1fCdTkjAl7ZD5N+hyS8yKy
         yeaJqKpPDmBQ9LLu1q/9GIWLvzbqoX0qoO4t7cpvuF+HSwVvZ6NPRghbn+xacRTfJ0
         9mXOS/+61FqXdLKWoJvKd/CrwCX5zs66Ve+nsiiq7ejRa/Su6RMhTXY+864zKCKaQO
         vkc/dreXJffTbVGssqF+j+RkbOFGWYJlP8ujaROHt+X3qi6GWAvnNnE1j3HcECBYUi
         iW6Iq2Gxuu2pQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stafford Horne <shorne@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jonas@southpole.se,
        stefan.kristiansson@saunalahti.fi, tglx@linutronix.de,
        openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 5.4 06/10] irqchip: or1k-pic: Undefine mask_ack for level triggered hardware
Date:   Thu, 14 Jul 2022 00:26:08 -0400
Message-Id: <20220714042612.282378-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042612.282378-1-sashal@kernel.org>
References: <20220714042612.282378-1-sashal@kernel.org>
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
index 03d2366118dd..d5f1fabc45d7 100644
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

