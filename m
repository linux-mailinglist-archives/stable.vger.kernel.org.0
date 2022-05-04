Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B4851A96F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359028AbiEDRQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354937AbiEDRLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E874B842;
        Wed,  4 May 2022 09:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0A24B82737;
        Wed,  4 May 2022 16:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93389C385AA;
        Wed,  4 May 2022 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683451;
        bh=d8aBkKFvDCEcM+/vDNEOn7RvlX+nP+BcdMllvbGZQzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItclEZ3G2akTNEeql2+/J1yyrwjasR+5GSNMUI73zQFFWF+x4SVkUaFHArMIP4uLf
         p64AsMBul0pgnDheHAw2bCNnmSwCbRx3QpdHoDrkUNeWUOz21Vb8bMHs4sQ5xjwAPX
         Gbppdh8SApwHwHqFg3xNZE2+U/K+yepsQWC4EorE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 114/225] net: hns3: clear inited state and stop client after failed to register netdev
Date:   Wed,  4 May 2022 18:45:52 +0200
Message-Id: <20220504153120.744668252@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit e98365afc1e94ea1609268866a44112b3572c58b ]

If failed to register netdev, it needs to clear INITED state and stop
client in case of cause problem when concurrency with uninitialized
process of driver.

Fixes: a289a7e5c1d4 ("net: hns3: put off calling register_netdev() until client initialize complete")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index f6082be7481c..f33b4c351a70 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5132,6 +5132,13 @@ static void hns3_state_init(struct hnae3_handle *handle)
 		set_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state);
 }
 
+static void hns3_state_uninit(struct hnae3_handle *handle)
+{
+	struct hns3_nic_priv *priv  = handle->priv;
+
+	clear_bit(HNS3_NIC_STATE_INITED, &priv->state);
+}
+
 static int hns3_client_init(struct hnae3_handle *handle)
 {
 	struct pci_dev *pdev = handle->pdev;
@@ -5249,7 +5256,9 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	return ret;
 
 out_reg_netdev_fail:
+	hns3_state_uninit(handle);
 	hns3_dbg_uninit(handle);
+	hns3_client_stop(handle);
 out_client_start:
 	hns3_free_rx_cpu_rmap(netdev);
 	hns3_nic_uninit_irq(priv);
-- 
2.35.1



