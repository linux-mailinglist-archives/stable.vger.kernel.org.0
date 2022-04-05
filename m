Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D28C4F4400
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382694AbiDEMQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244381AbiDEKil (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:38:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B61426D4;
        Tue,  5 Apr 2022 03:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A915CE0B18;
        Tue,  5 Apr 2022 10:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37478C385A3;
        Tue,  5 Apr 2022 10:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154214;
        bh=M1gU7GJAdKfEoxBo0mmxgvDmkAOM71wt/lDiYoCEucE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddVbKsMED+7c4CNoVNL13U7tp1WTIEI1fCE/x2k/I29fH1wz8BUvetyAd5rclusIH
         nO31xiTd1vSKI/pTfDdYwF/wXkEFe1JrDji9BMdOCFQ1JLsvPfoMqAWj519dCKZRxs
         Fx4VbpEE2dMEnoWMFbytvBEP1vzK8mV0uRRc6Rhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Daniel=20Gonz=C3=A1lez=20Cabanelas?= <dgcbueu@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 500/599] media: cx88-mpeg: clear interrupt status register before streaming video
Date:   Tue,  5 Apr 2022 09:33:14 +0200
Message-Id: <20220405070313.707864533@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index a57c991b165b..10d2971ef062 100644
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



