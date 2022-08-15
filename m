Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6235938B3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiHOTCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245213AbiHOTBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:01:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C20533346;
        Mon, 15 Aug 2022 11:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09A1F60EEB;
        Mon, 15 Aug 2022 18:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0102EC433C1;
        Mon, 15 Aug 2022 18:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588377;
        bh=fgbD63ZK38KAvlC/0IPEiqXYZOkpZEoUNR19gQ29OQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWtP1P/hVxBSlvrJYhE2UCSleRGnop20lLKb0P6Q0m8GFpWRc2pw7FDyzrvM2+mEn
         RmWcanFGKPA4IUBB4K7Efy6Yavut5RwB6kr905/rsNwOoDGCV9k0YY70STG8dJHZsg
         1eJsqTMAPn6A4T2khXSCASuR09xLj1Nl6Wyr7kAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 383/779] net: ionic: fix error check for vlan flags in ionic_set_nic_features()
Date:   Mon, 15 Aug 2022 20:00:27 +0200
Message-Id: <20220815180353.657188214@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit a86e86db5e6d72c82724a63ca1c5293409a21518 ]

The prototype of input features of ionic_set_nic_features() is
netdev_features_t, but the vlan_flags is using the private
definition of ionic drivers. It should use the variable
ctx.cmd.lif_setattr.features, rather than features to check
the vlan flags. So fixes it.

Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Acked-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 6ac507ddf09a..781313dbd04f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1565,7 +1565,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 	if ((old_hw_features ^ lif->hw_features) & IONIC_ETH_HW_RX_HASH)
 		ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);
 
-	if ((vlan_flags & features) &&
+	if ((vlan_flags & le64_to_cpu(ctx.cmd.lif_setattr.features)) &&
 	    !(vlan_flags & le64_to_cpu(ctx.comp.lif_setattr.features)))
 		dev_info_once(lif->ionic->dev, "NIC is not supporting vlan offload, likely in SmartNIC mode\n");
 
-- 
2.35.1



