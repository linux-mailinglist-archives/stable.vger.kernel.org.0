Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F616158A7
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiKBCz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiKBCzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:55:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F812229E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:55:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9C85617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63257C433D6;
        Wed,  2 Nov 2022 02:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357754;
        bh=HMwAvM7I4Fb0CIeNvdoGO8UI4NaeE1HbmZKDUVu8ksk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uac6CTNCBxacK5kBifmz+UQjeFWLulDnWKZDFB0MoucJdDnWfErb3t4YPqcnqAEUP
         NvsB8BxECQ9blJzgtx9TCj7ZFPH/YK9UyBKlRENFbB6ayp52cpGyhcvQWOZnfMakRP
         aJzxTDiGfyqh07qYD1UMVpJ8D8sQ1ur4qoJqHq1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 224/240] net/mlx5: Wait for firmware to enable CRS before pci_restore_state
Date:   Wed,  2 Nov 2022 03:33:19 +0100
Message-Id: <20221102022116.466949140@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 212b4d7251c169f87fa734e79bdec8dd413be5cf ]

After firmware reset driver should verify firmware already enabled CRS
and became responsive to pci config cycles before restoring pci state.
Fix that by waiting till device_id is readable through PCI again.

Fixes: eabe8e5e88f5 ("net/mlx5: Handle sync reset now event")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221026135153.154807-3-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/fw_reset.c  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index e8896f368362..07c583996c29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -358,6 +358,23 @@ static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev)
 		err = -ETIMEDOUT;
 	}
 
+	do {
+		err = pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &reg16);
+		if (err)
+			return err;
+		if (reg16 == dev_id)
+			break;
+		msleep(20);
+	} while (!time_after(jiffies, timeout));
+
+	if (reg16 == dev_id) {
+		mlx5_core_info(dev, "Firmware responds to PCI config cycles again\n");
+	} else {
+		mlx5_core_err(dev, "Firmware is not responsive (0x%04x) after %llu ms\n",
+			      reg16, mlx5_tout_ms(dev, PCI_TOGGLE));
+		err = -ETIMEDOUT;
+	}
+
 restore:
 	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
 		pci_cfg_access_unlock(sdev);
-- 
2.35.1



