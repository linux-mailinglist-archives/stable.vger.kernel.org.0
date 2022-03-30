Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EE34EC247
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344414AbiC3L7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345348AbiC3LyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12793278552;
        Wed, 30 Mar 2022 04:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D583D6137A;
        Wed, 30 Mar 2022 11:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A553FC340EE;
        Wed, 30 Mar 2022 11:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641058;
        bh=BS9+xBaILP2NTve/YGTy5aoxWamiPKm3xneZ2z7LGuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRgNF35cGOVYGYbzkEVXMz7hZiM4Sbk5s8JWVEl9tAxokX+nBPWukvA12Y9rIOv7H
         ex1YAWh7xdbO5JYfTjNu8v73GfL/rEp0JI6xNYMynOGsYtBhr+w7O61oJ8NyiO9Bl4
         1Q/eXLfo6jwGcUKx8wgs+NhU4mG6d1sSen61NhOVkX0ncEhA5HIx5Ht3igXgPDUS8f
         EydjQYJVtvF3D0PBGLRxQDJFH4aRF3LiHUkraNpc7jysVbXWwmRR0tS2VguiGd1/Sl
         qHij7vaGJAK+yyT2Qq2hB+dphf3SISLbGsvOhqierVcW+dBUZRvQjhZf3/ZQhLQB3F
         v+jD6WFPtGprg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20Gonz=C3=A1lez=20Cabanelas?= <dgcbueu@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 35/50] media: cx88-mpeg: clear interrupt status register before streaming video
Date:   Wed, 30 Mar 2022 07:49:49 -0400
Message-Id: <20220330115005.1671090-35-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Daniel González Cabanelas <dgcbueu@gmail.com>

[ Upstream commit 56cb61f70e547e1b0cdfe6ff5a1f1ce6242e6d96 ]

Some cx88 video cards may have transport stream status interrupts set
to 1 from cold start, causing errors like this:

  cx88xx: cx88_print_irqbits: core:irq mpeg  [0x100000] ts_err?*
  cx8802: cx8802_mpeg_irq: mpeg:general errors: 0x00100000

According to CX2388x datasheet, the interrupt status register should be
cleared before enabling IRQs to stream video.

Fix it by clearing the Transport Stream Interrupt Status register.

Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx88/cx88-mpeg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 680e1e3fe89b..2c1d5137ac47 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -162,6 +162,9 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 	cx_write(MO_TS_GPCNTRL, GP_COUNT_CONTROL_RESET);
 	q->count = 0;
 
+	/* clear interrupt status register */
+	cx_write(MO_TS_INTSTAT,  0x1f1111);
+
 	/* enable irqs */
 	dprintk(1, "setting the interrupt mask\n");
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask | PCI_INT_TSINT);
-- 
2.34.1

