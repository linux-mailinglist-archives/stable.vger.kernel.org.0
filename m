Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C15219B4
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242098AbiEJNut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245103AbiEJNrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1804426C4C5;
        Tue, 10 May 2022 06:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C919DB81DAB;
        Tue, 10 May 2022 13:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A8FC385A6;
        Tue, 10 May 2022 13:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189717;
        bh=kkZmoeC7JrJZmmnyEgxezs0OIrz683JgA9u3foknbuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4zkjC4JDpJJJ1TMC8Wt/dDUSnvItIWcK80EwlP+kvg3L1PSOjSAD92pDsA2cJYbJ
         dQnyBuSRKNISYjGt73NoGYwOSr0iZlWbX9fF0Y0Ks0bvZruLQGNKSE5WCI/GJcJdRa
         3IqYt2Lr7QlQgza5aL6Z+C42DdGys6tr3xha9l20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 132/135] PCI: aardvark: Remove irq_mask_ack() callback for INTx interrupts
Date:   Tue, 10 May 2022 15:08:34 +0200
Message-Id: <20220510130744.182733353@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit b08e5b53d17be58eb2311d6790a84fe2c200ee47 upstream.

Callback for irq_mask_ack() is the same as for irq_mask(). As there is no
special handling for irq_ack(), there is no need to define irq_mask_ack()
too.

Link: https://lore.kernel.org/r/20220110015018.26359-20-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1415,7 +1415,6 @@ static int advk_pcie_init_irq_domain(str
 	}
 
 	irq_chip->irq_mask = advk_pcie_irq_mask;
-	irq_chip->irq_mask_ack = advk_pcie_irq_mask;
 	irq_chip->irq_unmask = advk_pcie_irq_unmask;
 
 	pcie->irq_domain =


