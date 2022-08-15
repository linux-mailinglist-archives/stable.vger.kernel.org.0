Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E757594FA5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiHPEbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiHPEbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:31:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAFC16442C;
        Mon, 15 Aug 2022 13:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E69261072;
        Mon, 15 Aug 2022 20:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FDDC433C1;
        Mon, 15 Aug 2022 20:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594818;
        bh=E7a/8oKrx2+k0GllHy1FIIfAK9lmfDORKu43LLWGCG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3iPF6dNPUPUBU1qqghJkaVUXLyib07+Ns6zU11aQEU/IaqB6VQQHHfkMo099Fd+S
         28h8tpV7nFaNsUKwiyTqzd2nLmWpYsbh8t6qymmJRhdrXvmk/Iklr4Ew+x0kRC9i/4
         eS0nUD51YS7/rrftCIoIeDJne2YYl5rAjKC4nBwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0568/1157] net: ionic: fix error check for vlan flags in ionic_set_nic_features()
Date:   Mon, 15 Aug 2022 19:58:44 +0200
Message-Id: <20220815180502.343672487@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index f3568901eb91..1443f788ee37 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1437,7 +1437,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 	if ((old_hw_features ^ lif->hw_features) & IONIC_ETH_HW_RX_HASH)
 		ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);
 
-	if ((vlan_flags & features) &&
+	if ((vlan_flags & le64_to_cpu(ctx.cmd.lif_setattr.features)) &&
 	    !(vlan_flags & le64_to_cpu(ctx.comp.lif_setattr.features)))
 		dev_info_once(lif->ionic->dev, "NIC is not supporting vlan offload, likely in SmartNIC mode\n");
 
-- 
2.35.1



