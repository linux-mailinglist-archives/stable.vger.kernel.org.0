Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE15E5219FF
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240757AbiEJNw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245041AbiEJNrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519577658;
        Tue, 10 May 2022 06:34:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2F3DCE1E67;
        Tue, 10 May 2022 13:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DBDC385A6;
        Tue, 10 May 2022 13:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189642;
        bh=IOMGjic0Y5MCySd6f210PJpYaIrCb0vu1Km2VJOHEZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mS4WstrVFv3qxxZHYNkcK9nbdpaH/yZyLnecDXaNB6zlsj282AmQjK+ngg9/HEhUK
         AEakTtIYKHSpcEs78nhS0Tl8woG+ALJvoblBzeev3tpRUA2qmX1QKniyYkc97+t5nP
         WnXb6A8a8KWgqBqt/W72Kdbo1Osf9AkSrWTXrz7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 115/135] PCI: aardvark: Disable link training when unbinding driver
Date:   Tue, 10 May 2022 15:08:17 +0200
Message-Id: <20220510130743.700907942@linuxfoundation.org>
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

commit 759dec2e3dfdbd261c41d2279f04f2351c971a49 upstream.

Disable link training circuit in driver unbind sequence. We want to
leave link training in the same state as it was before the driver was
probed.

Link: https://lore.kernel.org/r/20211130172913.9727-11-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1725,6 +1725,11 @@ static int advk_pcie_remove(struct platf
 	if (pcie->reset_gpio)
 		gpiod_set_value_cansleep(pcie->reset_gpio, 1);
 
+	/* Disable link training */
+	val = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
+	val &= ~LINK_TRAINING_EN;
+	advk_writel(pcie, val, PCIE_CORE_CTRL0_REG);
+
 	/* Disable outbound address windows mapping */
 	for (i = 0; i < OB_WIN_COUNT; i++)
 		advk_pcie_disable_ob_win(pcie, i);


