Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517A251AA46
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356525AbiEDRWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356737AbiEDROF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1641553B77
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D126179D
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0632C385B3;
        Wed,  4 May 2022 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683494;
        bh=Pqm5eITw/y3Bb8/eENOq5EtcKZAsIAOIpyQTM5omGpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgVDy60rB9W/4ksGCQsehAv8FillnpS455CSPrEf9YmROPbE7BjSGa+8fmbYpzNvt
         rIBdtK/88VFq++n9ZUQ00dkBwXoYeo/hBhqhcMscNvV5/2aaEpjlqFrXaIWzwlIJfz
         8MlULbPqH0AORbJhZzJ26x2ThGbtqCUPe2svwBdGfKRe5YG/gjGv3kqU1Qnpni8BtB
         BRZP8GRlXOf0HpJnLpgLsBnJGQMC/FmDRpbD01nkuMk7ofe+51NxXCZYCKp/zK2tJZ
         Gkp14zPuJrAjjewe12q1FH1f+KtaEa3J+7L+EwQqx+0UKD7Jl7ES41ljE1N01ctOWk
         007oI7nHW3O+A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 09/30] PCI: aardvark: Assert PERST# when unbinding driver
Date:   Wed,  4 May 2022 18:57:34 +0200
Message-Id: <20220504165755.30002-10-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pali Rohár <pali@kernel.org>

commit 1f54391be8ce0c981d312cb93acdc5608def576a upstream.

Put the PCIe card into reset by asserting PERST# signal when unbinding
driver. It doesn't make sense to leave the card working if it can't
communicate with the host. This should also save some power.

Link: https://lore.kernel.org/r/20211130172913.9727-10-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 02eefc13ac60..78bc57d57926 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1721,6 +1721,10 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	/* Free config space for emulated root bridge */
 	pci_bridge_emul_cleanup(&pcie->bridge);
 
+	/* Assert PERST# signal which prepares PCIe card for power down */
+	if (pcie->reset_gpio)
+		gpiod_set_value_cansleep(pcie->reset_gpio, 1);
+
 	/* Disable outbound address windows mapping */
 	for (i = 0; i < OB_WIN_COUNT; i++)
 		advk_pcie_disable_ob_win(pcie, i);
-- 
2.35.1

