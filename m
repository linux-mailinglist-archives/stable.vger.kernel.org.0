Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DCB4EC125
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344478AbiC3L4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344721AbiC3Lx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEB2269340;
        Wed, 30 Mar 2022 04:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 023D961616;
        Wed, 30 Mar 2022 11:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89D9C34112;
        Wed, 30 Mar 2022 11:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640970;
        bh=BS9+xBaILP2NTve/YGTy5aoxWamiPKm3xneZ2z7LGuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQ7/KuS6ZCdqqQ4VvTCHzgae82E2sC+n4gZKIjBmMdP5rPkpYiSGON3xS8LBRRWCO
         VqMdod2UqQ6NDEAs9I4+z+25+kMKQEU3cmj9i3DJ0PC1ZuLVvXqg7g/cCkyvWIcuqx
         lSIJCHBnszG6dReOG2/Ef4H/miMUA7IlzwOlZmO+vRkCuDC7hbCXr3RDJRay3D+fY0
         TUfjQRydMFVQ4KDcYsA/HrG+zlrOc/n9/um3hvZFN3jp6mLm7E0PsZv1Gaaa6sc+ID
         t3zE+7fYmXuGljazcncYh5gMS2Yem8d8345oogXhUtqQi3+DkLrRy5UJk+b+zSugzx
         n6CbcqJg2qawQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20Gonz=C3=A1lez=20Cabanelas?= <dgcbueu@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 38/59] media: cx88-mpeg: clear interrupt status register before streaming video
Date:   Wed, 30 Mar 2022 07:48:10 -0400
Message-Id: <20220330114831.1670235-38-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
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

