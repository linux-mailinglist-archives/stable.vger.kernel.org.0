Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7EE5414D5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358705AbiFGUWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358584AbiFGUVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:21:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1008217B859;
        Tue,  7 Jun 2022 11:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA8ECB81FF8;
        Tue,  7 Jun 2022 18:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F391C385A5;
        Tue,  7 Jun 2022 18:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626671;
        bh=e7z7YYVlH1TL5GP3G+nujeATCGzehNUWZSCRno86fts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EdVuxJlotlgtDCUwGo4T2oPfbe2A6zvCdXAjLW8aJ3cvLXfPKXDpVccL2evSA0dS
         4jj3uR+xxHAqsCt3VmiKUppOdu4MoeATWj+Oysu0xSf9h+CdsmqrNU9Kh6Vr17Pmli
         gAJJ++d0FTZcr5nq0X0E/VAQ+OFILEtIknBX+g0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 461/772] PCI: mediatek: Fix refcount leak in mtk_pcie_subsys_powerup()
Date:   Tue,  7 Jun 2022 19:00:53 +0200
Message-Id: <20220607165002.585603714@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 214e0d8fe4a813ae6ffd62bc2dfe7544c20914f4 ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, We should use of_node_put() on it when done
Add the missing of_node_put() to release the refcount.

Link: https://lore.kernel.org/r/20220309091953.5630-1-linmq006@gmail.com
Fixes: 87e8657ba99c ("PCI: mediatek: Add new method to get shared pcie-cfg base address")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index ddfbd4aebdec..be8bd919cb88 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1008,6 +1008,7 @@ static int mtk_pcie_subsys_powerup(struct mtk_pcie *pcie)
 					   "mediatek,generic-pciecfg");
 	if (cfg_node) {
 		pcie->cfg = syscon_node_to_regmap(cfg_node);
+		of_node_put(cfg_node);
 		if (IS_ERR(pcie->cfg))
 			return PTR_ERR(pcie->cfg);
 	}
-- 
2.35.1



