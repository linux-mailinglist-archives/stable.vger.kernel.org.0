Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B634F2B26
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbiDEI2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239568AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F230637C;
        Tue,  5 Apr 2022 01:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E040060AFB;
        Tue,  5 Apr 2022 08:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC09FC385A0;
        Tue,  5 Apr 2022 08:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146594;
        bh=3vrI8pCC5hsfYQTqMh0KYOwxXZBB+PboDIZ3er8Rfk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYXTDSIhEP4p0DXG3B2VhoOqhDPfCbaDXFFC40bgOlNdrpca9pBliMUCdSK8WTNvA
         f3iF8wGwNBfth+LXNNP1FkSmfcjG8EdPf1zjqgVWf2ge09uptnyhmXKGxMJLKZDjGL
         djgzqdtH4g2/Ztcyj4C6wME2O56Wh+eRo/SKI6GU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0820/1126] net: hns3: fix phy can not link up when autoneg off and reset
Date:   Tue,  5 Apr 2022 09:26:07 +0200
Message-Id: <20220405070431.631781398@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit ad0ecaef6a2c07e67ef9fe163c007f7b3dad8643 ]

Currently, function hclge_mdio_read() will return 0 if during reset(the
cmd state will be set to disable).

If use general phy driver, the phy_state_machine() will update phy speed
every second in function genphy_read_status_fixed() when PHY is set to
autoneg off, no matter of link down or link up.

If phy driver happens to read BMCR register during reset, phy speed will
be updated to 10Mpbs as BMCR register value is 0. So it may call phy can
not link up if previous speed is not 10Mpbs.

To fix this problem, function hclge_mdio_read() should return -EBUSY if
the cmd state is disable. So does function hclge_mdio_write().

Fixes: 1c1249380992 ("net: hns3: bugfix for hclge_mdio_write and hclge_mdio_read")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 63d2be4349e3..03d63b6a9b2b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -48,7 +48,7 @@ static int hclge_mdio_write(struct mii_bus *bus, int phyid, int regnum,
 	int ret;
 
 	if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state))
-		return 0;
+		return -EBUSY;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MDIO_CONFIG, false);
 
@@ -86,7 +86,7 @@ static int hclge_mdio_read(struct mii_bus *bus, int phyid, int regnum)
 	int ret;
 
 	if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state))
-		return 0;
+		return -EBUSY;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MDIO_CONFIG, true);
 
-- 
2.34.1



