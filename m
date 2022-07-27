Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3ED582B31
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbiG0Q3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236890AbiG0Q2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:28:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7996D501AA;
        Wed, 27 Jul 2022 09:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D2F5B821B8;
        Wed, 27 Jul 2022 16:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EDAC433D6;
        Wed, 27 Jul 2022 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939068;
        bh=uiUGTwAC6da7fWJZz7M1UEyF2xig5WJwOlwZQXodwVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wppf6cO5ygukDe0Vl0pMKIvnl5xO8mYLveEOzyKOAdpNNw+utwEK8jiITAXSWTKjK
         UkW9eGznP1lyeIesOhrXWneHO5BFXNDEmIMgk3Ykmk3SjUBOsxD66fnD77R1rArDrD
         z+B6FTwHloXDUAl3aBkx5uQxf7hgcMo9BlW8E4tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hristo Venev <hristo@venev.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/37] be2net: Fix buffer overflow in be_get_module_eeprom
Date:   Wed, 27 Jul 2022 18:10:40 +0200
Message-Id: <20220727161001.437452503@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hristo Venev <hristo@venev.name>

[ Upstream commit d7241f679a59cfe27f92cb5c6272cb429fb1f7ec ]

be_cmd_read_port_transceiver_data assumes that it is given a buffer that
is at least PAGE_DATA_LEN long, or twice that if the module supports SFF
8472. However, this is not always the case.

Fix this by passing the desired offset and length to
be_cmd_read_port_transceiver_data so that we only copy the bytes once.

Fixes: e36edd9d26cf ("be2net: add ethtool "-m" option support")
Signed-off-by: Hristo Venev <hristo@venev.name>
Link: https://lore.kernel.org/r/20220716085134.6095-1-hristo@venev.name
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c   | 10 +++---
 drivers/net/ethernet/emulex/benet/be_cmds.h   |  2 +-
 .../net/ethernet/emulex/benet/be_ethtool.c    | 31 ++++++++++++-------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 1589a568bfe0..7ea2e5dbacd5 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -2291,7 +2291,7 @@ int be_cmd_get_beacon_state(struct be_adapter *adapter, u8 port_num, u32 *state)
 
 /* Uses sync mcc */
 int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
-				      u8 page_num, u8 *data)
+				      u8 page_num, u32 off, u32 len, u8 *data)
 {
 	struct be_dma_mem cmd;
 	struct be_mcc_wrb *wrb;
@@ -2325,10 +2325,10 @@ int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
 	req->port = cpu_to_le32(adapter->hba_port_num);
 	req->page_num = cpu_to_le32(page_num);
 	status = be_mcc_notify_wait(adapter);
-	if (!status) {
+	if (!status && len > 0) {
 		struct be_cmd_resp_port_type *resp = cmd.va;
 
-		memcpy(data, resp->page_data, PAGE_DATA_LEN);
+		memcpy(data, resp->page_data + off, len);
 	}
 err:
 	mutex_unlock(&adapter->mcc_lock);
@@ -2419,7 +2419,7 @@ int be_cmd_query_cable_type(struct be_adapter *adapter)
 	int status;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		switch (adapter->phy.interface_type) {
 		case PHY_TYPE_QSFP:
@@ -2444,7 +2444,7 @@ int be_cmd_query_sfp_info(struct be_adapter *adapter)
 	int status;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		strlcpy(adapter->phy.vendor_name, page_data +
 			SFP_VENDOR_NAME_OFFSET, SFP_VENDOR_NAME_LEN - 1);
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.h b/drivers/net/ethernet/emulex/benet/be_cmds.h
index 09da2d82c2f0..8af11a5e49fe 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.h
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.h
@@ -2431,7 +2431,7 @@ int be_cmd_set_beacon_state(struct be_adapter *adapter, u8 port_num, u8 beacon,
 int be_cmd_get_beacon_state(struct be_adapter *adapter, u8 port_num,
 			    u32 *state);
 int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
-				      u8 page_num, u8 *data);
+				      u8 page_num, u32 off, u32 len, u8 *data);
 int be_cmd_query_cable_type(struct be_adapter *adapter);
 int be_cmd_query_sfp_info(struct be_adapter *adapter);
 int lancer_cmd_read_object(struct be_adapter *adapter, struct be_dma_mem *cmd,
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index f66b246acaea..d0d96fa71084 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1340,7 +1340,7 @@ static int be_get_module_info(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		if (!page_data[SFP_PLUS_SFF_8472_COMP]) {
 			modinfo->type = ETH_MODULE_SFF_8079;
@@ -1358,25 +1358,32 @@ static int be_get_module_eeprom(struct net_device *netdev,
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 	int status;
+	u32 begin, end;
 
 	if (!check_privilege(adapter, MAX_PRIVILEGES))
 		return -EOPNOTSUPP;
 
-	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   data);
-	if (status)
-		goto err;
+	begin = eeprom->offset;
+	end = eeprom->offset + eeprom->len;
+
+	if (begin < PAGE_DATA_LEN) {
+		status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0, begin,
+							   min_t(u32, end, PAGE_DATA_LEN) - begin,
+							   data);
+		if (status)
+			goto err;
+
+		data += PAGE_DATA_LEN - begin;
+		begin = PAGE_DATA_LEN;
+	}
 
-	if (eeprom->offset + eeprom->len > PAGE_DATA_LEN) {
-		status = be_cmd_read_port_transceiver_data(adapter,
-							   TR_PAGE_A2,
-							   data +
-							   PAGE_DATA_LEN);
+	if (end > PAGE_DATA_LEN) {
+		status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A2,
+							   begin - PAGE_DATA_LEN,
+							   end - begin, data);
 		if (status)
 			goto err;
 	}
-	if (eeprom->offset)
-		memcpy(data, data + eeprom->offset, eeprom->len);
 err:
 	return be_cmd_status(status);
 }
-- 
2.35.1



