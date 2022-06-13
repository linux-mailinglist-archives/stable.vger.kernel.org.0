Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A613D548A36
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356606AbiFML5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356163AbiFMLzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:55:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45422FFEB;
        Mon, 13 Jun 2022 03:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DBDBB80E59;
        Mon, 13 Jun 2022 10:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C976CC3411C;
        Mon, 13 Jun 2022 10:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117766;
        bh=+LkKsYq5Rh7vvyyFH6jG3nFgPpABXyDtRauFwE1mXhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6alSWbEwue4LiLGmq1ojDggZpzni2FyRZMNzB0AdYez9RYXM9MNrhgBMrEgU0Grk
         vq1EQ9KMP23uyCehKRa/kI8dFIM9rKsSG8oZnULCcP91zPKa30nF+PN2W4OvO0dUxV
         EjnFkZ+eGUDDm/DmPezdAxWU73naIYKG8rDvOew4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/287] PCI: rockchip: Fix find_first_zero_bit() limit
Date:   Mon, 13 Jun 2022 12:08:56 +0200
Message-Id: <20220613094927.273947643@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index caf34661d38d..06dd2ab73b6e 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -263,8 +263,7 @@ static int rockchip_pcie_ep_map_addr(struct pci_epc *epc, u8 fn,
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



