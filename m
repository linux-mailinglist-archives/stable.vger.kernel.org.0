Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2320F5EA537
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbiIZL7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbiIZL5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:57:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DF358DC7;
        Mon, 26 Sep 2022 03:51:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3413AB80915;
        Mon, 26 Sep 2022 10:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823BEC433D6;
        Mon, 26 Sep 2022 10:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188694;
        bh=rc8xS3XGBAq54U9F+3K3kpNLWXF82CMelCAi9R0WAZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3j6un3+L8yYNCnklmdbp13fOielbQRpPapaIksJxVOLTz07zfBq+9L/jKoemKEpQ
         HblCW0IlJDctTzC/3WDlAplDLbSfNt+zHc9x9euTN3bDmU7tqe8E12GRtgke6aIxgC
         euYmokOi/I8fW2d9GC8SrRuHo5CIP3SQ/Rssfpmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asmaa Mnebhi <asmaa@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/148] mlxbf_gige: clear MDIO gateway lock after read
Date:   Mon, 26 Sep 2022 12:11:58 +0200
Message-Id: <20220926100759.196718103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit 182447b12144b7be9b63a273d27c5a11bd54960a ]

The MDIO gateway (GW) lock in BlueField-2 GIGE logic is
set after read.  This patch adds logic to make sure the
lock is always cleared at the end of each MDIO transaction.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20220902164247.19862-1-davthompson@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index f979ba7e5eff..caa4380ada13 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -178,6 +178,9 @@ static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
 	/* Only return ad bits of the gw register */
 	ret &= MLXBF_GIGE_MDIO_GW_AD_MASK;
 
+	/* The MDIO lock is set on read. To release it, clear gw register */
+	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+
 	return ret;
 }
 
@@ -201,6 +204,9 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 	ret = readl_poll_timeout_atomic(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET,
 					temp, !(temp & MLXBF_GIGE_MDIO_GW_BUSY_MASK), 100, 1000000);
 
+	/* The MDIO lock is set on read. To release it, clear gw register */
+	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+
 	return ret;
 }
 
-- 
2.35.1



