Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671B557436E
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiGNEen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237350AbiGNEdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:33:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3D33A4BD;
        Wed, 13 Jul 2022 21:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 698CF61E51;
        Thu, 14 Jul 2022 04:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FAFC341C8;
        Thu, 14 Jul 2022 04:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772759;
        bh=2qjO8+odQ7oxEl1fALycalDewY6Q0DjTfZWWlCdvWKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lmu1nvSjQKXfZ15bpbI3wt6d+K2AGGWzjyMD6z+2XNvBR+UX2kvaW4ZkaB8+qJ+kZ
         M9hBc/Qbvt4xNdZp2yJ86j8RhDmRJ4+CwmWJFoPWgBCYw5U0J6fE496a26DLkjaRI5
         AeYoig3TTK5U7/WeTqj7uPzEmgwe+45EPgiMhXjnweLtJKcSU8xyXUc34q8BYc8S4z
         cX9CVw6UotbovzEt1bvm/84C9Uxqvaw01Np3FGmYNvDjTgaEBM/zVTC2pDmBCLXkx0
         dZRDO78zF3Yq0vpx3g4ApTLGqADdnH8+RwZR8BYMiPqIPFanD7/GTO+QALOpaLfj/D
         k6CyuqaQZYSLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stafford Horne <shorne@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jonas@southpole.se,
        stefan.kristiansson@saunalahti.fi, tglx@linutronix.de,
        openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 5.10 09/15] irqchip: or1k-pic: Undefine mask_ack for level triggered hardware
Date:   Thu, 14 Jul 2022 00:25:34 -0400
Message-Id: <20220714042541.282175-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042541.282175-1-sashal@kernel.org>
References: <20220714042541.282175-1-sashal@kernel.org>
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

