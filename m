Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32F7658332
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiL1Qo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiL1Qoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C551CB07
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D31B817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD28C433EF;
        Wed, 28 Dec 2022 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245603;
        bh=oDORo2k92wxdXaMm6FSFsNgHkqkEuO+GDd9FWTrYO/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icodC0YA0NS5+5J2Wlb8KnaXDYxD+z0QXTBgQ0G2M50aadFWQbivKi9H+tv3bUxK+
         mu07SsrU9+Km6gzdmfGFYJOkJHZRKrz8IimN5aJLsa3ReTaXwt531q5UwsVomx/JQk
         UhluUy/9agVVLygnAxdDdg6J6nOnj+QZmASXneiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Raed Salem <raeds@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0888/1146] net: macsec: fix net device access prior to holding a lock
Date:   Wed, 28 Dec 2022 15:40:27 +0100
Message-Id: <20221228144354.299037535@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

[ Upstream commit f3b4a00f0f62da252c598310698dfc82ef2f2e2e ]

Currently macsec offload selection update routine accesses
the net device prior to holding the relevant lock.
Fix by holding the lock prior to the device access.

Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Link: https://lore.kernel.org/r/20221211075532.28099-1-ehakim@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 2fbac51b9b19..038a78794392 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2593,7 +2593,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	const struct macsec_ops *ops;
 	struct macsec_context ctx;
 	struct macsec_dev *macsec;
-	int ret;
+	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -2606,28 +2606,36 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 					macsec_genl_offload_policy, NULL))
 		return -EINVAL;
 
+	rtnl_lock();
+
 	dev = get_dev_from_nl(genl_info_net(info), attrs);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto out;
+	}
 	macsec = macsec_priv(dev);
 
-	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
-		return -EINVAL;
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload == offload)
-		return 0;
+		goto out;
 
 	/* Check if the offloading mode is supported by the underlying layers */
 	if (offload != MACSEC_OFFLOAD_OFF &&
-	    !macsec_check_offload(offload, macsec))
-		return -EOPNOTSUPP;
+	    !macsec_check_offload(offload, macsec)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	/* Check if the net device is busy. */
-	if (netif_running(dev))
-		return -EBUSY;
-
-	rtnl_lock();
+	if (netif_running(dev)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	prev_offload = macsec->offload;
 	macsec->offload = offload;
@@ -2662,7 +2670,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 
 rollback:
 	macsec->offload = prev_offload;
-
+out:
 	rtnl_unlock();
 	return ret;
 }
-- 
2.35.1



