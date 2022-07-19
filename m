Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502B55799E4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbiGSMIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbiGSMHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986FE4F19A;
        Tue, 19 Jul 2022 05:01:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C00ED616F6;
        Tue, 19 Jul 2022 12:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44F2C341C6;
        Tue, 19 Jul 2022 12:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232084;
        bh=5IEYN5foefB4K0Dyg0jaz4/QY7YbSg5VpEmxben9s0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mZt2ErMiOtwjETFdDPr0Q1knhwHIAcEfsGw+9S9kSG5nxfWSD21qWyyxwextKbty
         Gebl0CsNyJj7w7qBwTUJdtjAQ3DUEGt3ytvdNyJfe46BVIZ66pX5qrIOx9rNwCA90X
         Ov74MkmhVeQPuSqdTvMSYybaDtDN3udX8WB+Gb38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/48] irqchip: or1k-pic: Undefine mask_ack for level triggered hardware
Date:   Tue, 19 Jul 2022 13:54:14 +0200
Message-Id: <20220719114523.143796898@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



