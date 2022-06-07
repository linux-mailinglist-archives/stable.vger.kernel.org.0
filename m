Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F05C541C00
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382453AbiFGVzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384289AbiFGVyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A6C24A1C8;
        Tue,  7 Jun 2022 12:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 283696187F;
        Tue,  7 Jun 2022 19:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326B4C385A5;
        Tue,  7 Jun 2022 19:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629166;
        bh=RwPRQSyV833cnrScno/aj01YrPInxnibRG2Rvh6F6Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9pfNnbaFh6tCxsJwsE1Ea1sBsXSLViGMJlc2gg4YdE1CrT2G7SBwJzjP3itpGxWK
         cS59g07JJDfd7vO9R/YLDdxRgegfDNXQBiA7IPCRY/3cpkkPlESDAbmtn8adyroBbT
         kfDbs/i91/0I2/fLhQ+Oi9iUrkNw/eDFaPVaubzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 543/879] PCI: rockchip: Fix find_first_zero_bit() limit
Date:   Tue,  7 Jun 2022 19:01:01 +0200
Message-Id: <20220607165018.631420265@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 096950e230b8d83645c7cf408b9f399f58c08b96 ]

The ep->ob_region_map bitmap is a long and it has BITS_PER_LONG bits.

Link: https://lore.kernel.org/r/20220315065944.GB13572@kili
Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 5fb9ce6e536e..d1a200b93b2b 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -264,8 +264,7 @@ static int rockchip_pcie_ep_map_addr(struct pci_epc *epc, u8 fn, u8 vfn,
 	struct rockchip_pcie *pcie = &ep->rockchip;
 	u32 r;
 
-	r = find_first_zero_bit(&ep->ob_region_map,
-				sizeof(ep->ob_region_map) * BITS_PER_LONG);
+	r = find_first_zero_bit(&ep->ob_region_map, BITS_PER_LONG);
 	/*
 	 * Region 0 is reserved for configuration space and shouldn't
 	 * be used elsewhere per TRM, so leave it out.
-- 
2.35.1



