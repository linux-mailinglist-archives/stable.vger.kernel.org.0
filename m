Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67EB521B20
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245085AbiEJOId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344321AbiEJOHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29458222C23;
        Tue, 10 May 2022 06:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3259CB81DB8;
        Tue, 10 May 2022 13:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C73C385C2;
        Tue, 10 May 2022 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190130;
        bh=Q/wa8OJ9CnaeLBtZJO6vLL7L4NQFzE5kL/fTM1DBzHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcaepb28aSwmzfeGxR7hnrmZ57Mj3eB0F3WSZ/xZIpCJd/+RlHqH9yIATTt95pT7o
         tMsBlNKgbnLsquQVYEmemcCIi8qMeLmFU/H5jSw7kkDZi1kDo2GgwTXvK6IW8Sg5kB
         VHLuwZBaV5BVT8vSQEJuFCcUbYJ8aBjI5dYpfOh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.17 138/140] PCI: aardvark: Dont mask irq when mapping
Date:   Tue, 10 May 2022 15:08:48 +0200
Message-Id: <20220510130745.533042843@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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

commit befa71000160b39c1bf6cdfca6837bb5e9d372d7 upstream.

By default, all Legacy INTx interrupts are masked, so there is no need to
mask this interrupt during irq_map() callback.

Link: https://lore.kernel.org/r/20220110015018.26359-21-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1330,7 +1330,6 @@ static int advk_pcie_irq_map(struct irq_
 {
 	struct advk_pcie *pcie = h->host_data;
 
-	advk_pcie_irq_mask(irq_get_irq_data(virq));
 	irq_set_status_flags(virq, IRQ_LEVEL);
 	irq_set_chip_and_handler(virq, &pcie->irq_chip,
 				 handle_level_irq);


