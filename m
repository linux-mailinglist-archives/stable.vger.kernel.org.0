Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F37562803E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiKNNEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237751AbiKNNET (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D409629C99
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 716876117E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8FFC433D6;
        Mon, 14 Nov 2022 13:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431057;
        bh=fcGfQ+PyeeDToST38MNpzkrxU1QtB17T0GyYABx2lF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Px43v4kad4cXAAbpBa7vb9o2G14/Tn5VJojCshMNzZojFqz5KG+O8d8jVvXd/88g5
         rncMAEmrp8y2V5vEkLicsyB7UpvrDGrHSPnMKlrmrEOBuao2Cp0ikodwGUFroB1zXO
         iU/WCdZJTxiSuD4TtZVo+Pzq9T4HSMOngZZQIvGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 085/190] net: wwan: iosm: fix invalid mux header type
Date:   Mon, 14 Nov 2022 13:45:09 +0100
Message-Id: <20221114124502.392426644@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 02d2d2ea4a3bc2391f6ac31f6854da83e8a63829 ]

Data stall seen during peak DL throughput test & packets are
dropped by mux layer due to invalid header type in datagram.

During initlization Mux aggregration protocol is set to default
UL/DL size and TD count of Mux lite protocol. This configuration
mismatch between device and driver is resulting in data stall/packet
drops.

Override the UL/DL size and TD count for Mux aggregation protocol.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 8 ++++++++
 drivers/net/wwan/iosm/iosm_ipc_mux.h      | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 57304a5adf68..6e32eb91bba9 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -91,6 +91,14 @@ void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
 	}
 
 	ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->nr_of_channels);
+
+	if (ipc_imem->mmio->mux_protocol == MUX_AGGREGATION &&
+	    ipc_imem->nr_of_channels == IPC_MEM_IP_CHL_ID_0) {
+		chnl_cfg.ul_nr_of_entries = IPC_MEM_MAX_TDS_MUX_AGGR_UL;
+		chnl_cfg.dl_nr_of_entries = IPC_MEM_MAX_TDS_MUX_AGGR_DL;
+		chnl_cfg.dl_buf_size = IPC_MEM_MAX_ADB_BUF_SIZE;
+	}
+
 	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_WWAN, chnl_cfg,
 			      IRQ_MOD_OFF);
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux.h b/drivers/net/wwan/iosm/iosm_ipc_mux.h
index cd9d74cc097f..9968bb885c1f 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux.h
@@ -10,6 +10,7 @@
 
 #define IPC_MEM_MAX_UL_DG_ENTRIES	100
 #define IPC_MEM_MAX_TDS_MUX_AGGR_UL	60
+#define IPC_MEM_MAX_TDS_MUX_AGGR_DL	60
 
 #define IPC_MEM_MAX_ADB_BUF_SIZE (16 * 1024)
 #define IPC_MEM_MAX_UL_ADB_BUF_SIZE IPC_MEM_MAX_ADB_BUF_SIZE
-- 
2.35.1



