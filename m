Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850DB5743A7
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbiGNEhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiGNEgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:36:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E0E3D5A8;
        Wed, 13 Jul 2022 21:26:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3D0BB8236E;
        Thu, 14 Jul 2022 04:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A16BC36AE2;
        Thu, 14 Jul 2022 04:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772804;
        bh=5IEYN5foefB4K0Dyg0jaz4/QY7YbSg5VpEmxben9s0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r52H2BeKhEe9ihsH+cIjm3WWV6WdxQrcKwVIAk2W/NUdqfAc2HBn4z3V55TFYWeDT
         j+vMiEPnB/MQbrBysAH7Ku+/TPveUtrw1uJb9ZZTcHBJhFszf4X4v36MHfiQ0ujd/v
         m3jfTNE0Ohde8ztQQIE4AuXZT4MeSym7epZvwZl41KHxamfqHwg9SppdKaAkIeGwIb
         +M6QAZF8IrCxC5w5q7WKUqZE5aadMqcHabiUkRH/TWx3Yr50ehDEIwprOXRwjWffuh
         /jBaf9KYcFZoA66UCoJhcdoaT0jYHAwp9Dfdwh872gHakdCwMK0mbpzAVB9mwfly6T
         tUGTd/7WOUB8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stafford Horne <shorne@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jonas@southpole.se,
        stefan.kristiansson@saunalahti.fi, tglx@linutronix.de,
        openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 4.19 3/6] irqchip: or1k-pic: Undefine mask_ack for level triggered hardware
Date:   Thu, 14 Jul 2022 00:26:33 -0400
Message-Id: <20220714042637.282511-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042637.282511-1-sashal@kernel.org>
References: <20220714042637.282511-1-sashal@kernel.org>
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
index dd9d5d12fea2..05931fdedbb9 100644
--- a/drivers/irqchip/irq-or1k-pic.c
+++ b/drivers/irqchip/irq-or1k-pic.c
@@ -70,7 +70,6 @@ static struct or1k_pic_dev or1k_pic_level = {
 		.name = "or1k-PIC-level",
 		.irq_unmask = or1k_pic_unmask,
 		.irq_mask = or1k_pic_mask,
-		.irq_mask_ack = or1k_pic_mask_ack,
 	},
 	.handle = handle_level_irq,
 	.flags = IRQ_LEVEL | IRQ_NOPROBE,
-- 
2.35.1

