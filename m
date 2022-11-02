Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C856615867
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiKBCv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiKBCv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:51:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB5D21E1D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A12F0B82075
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812E1C433C1;
        Wed,  2 Nov 2022 02:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357484;
        bh=rLfYED5AZ5jf+AUKF9eta3uIgPVw9S9AyD/G4WnU2AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxJWiVtzYJ8jgtbYhqHeleZeu3q99Z2n3yTcQvm8xpu4v6WwVJ6dA5U5CrhmNg1qM
         k4dtMDUJyOPP8ovlv8QaBDzcErTCz8UU5AnmhomtNAziWDXHSuQexcaSKCC1GlYZqf
         3vO5dBqqrY5aiLQKGc/tYetvMhksKygdaX8GRZKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Raju Rangoju <Raju.Rangoju@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 177/240] amd-xgbe: Yellow carp devices do not need rrc
Date:   Wed,  2 Nov 2022 03:32:32 +0100
Message-Id: <20221102022115.390442286@linuxfoundation.org>
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

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit f97fc7ef414603189d5ba6f529407c5341c03c2a ]

Link stability issues are noticed on Yellow carp platforms when Receiver
Reset Cycle is issued. Since the CDR workaround is disabled on these
platforms, the Receiver Reset Cycle is not needed.

So, avoid issuing rrc on Yellow carp platforms.

Fixes: dbb6c58b5a61 ("net: amd-xgbe: Add Support for Yellow Carp Ethernet device")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 5 +++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 2af3da4b2d05..f409d7bd1f1e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -285,6 +285,9 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		/* Yellow Carp devices do not need cdr workaround */
 		pdata->vdata->an_cdr_workaround = 0;
+
+		/* Yellow Carp devices do not need rrc */
+		pdata->vdata->enable_rrc = 0;
 	} else {
 		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
@@ -483,6 +486,7 @@ static struct xgbe_version_data xgbe_v2a = {
 	.tx_desc_prefetch		= 5,
 	.rx_desc_prefetch		= 5,
 	.an_cdr_workaround		= 1,
+	.enable_rrc			= 1,
 };
 
 static struct xgbe_version_data xgbe_v2b = {
@@ -498,6 +502,7 @@ static struct xgbe_version_data xgbe_v2b = {
 	.tx_desc_prefetch		= 5,
 	.rx_desc_prefetch		= 5,
 	.an_cdr_workaround		= 1,
+	.enable_rrc			= 1,
 };
 
 static const struct pci_device_id xgbe_pci_table[] = {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 2156600641b6..19b943eba560 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2640,7 +2640,7 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	}
 
 	/* No link, attempt a receiver reset cycle */
-	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
+	if (pdata->vdata->enable_rrc && phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
 		phy_data->rrc_count = 0;
 		xgbe_phy_rrc(pdata);
 	}
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index b875c430222e..49d23abce73d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1013,6 +1013,7 @@ struct xgbe_version_data {
 	unsigned int tx_desc_prefetch;
 	unsigned int rx_desc_prefetch;
 	unsigned int an_cdr_workaround;
+	unsigned int enable_rrc;
 };
 
 struct xgbe_prv_data {
-- 
2.35.1



