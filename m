Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7D66C16DD
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbjCTPJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjCTPJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:09:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFD62D7B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF1B4B80EBB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63724C433D2;
        Mon, 20 Mar 2023 14:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324375;
        bh=lbu4tc/pp2fSU638vch4/fR7b3utGOS81ltcB6TxaTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooM0iich0nKYRveVlaynDGuSzOjacAvharGeLOYIeEIX8OdN104XS08nHpBzHW6qw
         rQSlcsJTFLik/UjHQn0qZKcsLH+it+ToZKwd0Gsgp8Dwg7O+tXrmSykqkeF4xBVGNQ
         BvGKh5QCFMJOAC2yCzdeaBwRUo3i7nrfrOlFgBUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/36] net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails
Date:   Mon, 20 Mar 2023 15:54:34 +0100
Message-Id: <20230320145424.551865044@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit c22c3bbf351e4ce905f082649cffa1ff893ea8c1 ]

If genphy_read_status fails then further access to the PHY may result
in unpredictable behavior. To prevent this bail out immediately if
genphy_read_status fails.

Fixes: 4223dbffed9f ("net: phy: smsc: Re-enable EDPD mode for LAN87xx")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/026aa4f2-36f5-1c10-ab9f-cdb17dda6ac4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index c328208388da7..fd7c9f5ff99eb 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -112,8 +112,11 @@ static int lan911x_config_init(struct phy_device *phydev)
 static int lan87xx_read_status(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
+	int err;
 
-	int err = genphy_read_status(phydev);
+	err = genphy_read_status(phydev);
+	if (err)
+		return err;
 
 	if (!phydev->link && priv->energy_enable) {
 		int i;
-- 
2.39.2



