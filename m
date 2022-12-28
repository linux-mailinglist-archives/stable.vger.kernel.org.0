Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB77B658271
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiL1QgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbiL1Qep (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:34:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3191CFDD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:32:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D486A61562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62ADC433EF;
        Wed, 28 Dec 2022 16:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245130;
        bh=2hKfTpwMET//hXAeJ998tRqo39vr+r2RF5Xdeg9ZQQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtdIFyVMJQpCP7cICsZYFz/2Oj/H/Ia9upCSvxwG6HIYyOGx/FNxDolQQhu4jlPUb
         ZODkBxF1rCEZXyrUW0RA+eWk6rQQl1AHCzViLcet3lfbVBV2YxfWXFAWqLM5QSU3Gz
         Zu1A2bfWn8K+Bs+esXNCv5ngUWUF/czYyHSbN1Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Raed Salem <raeds@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0838/1073] net: macsec: fix net device access prior to holding a lock
Date:   Wed, 28 Dec 2022 15:40:26 +0100
Message-Id: <20221228144350.782167327@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 8dafc814282c..022b2daabd74 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2621,7 +2621,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	const struct macsec_ops *ops;
 	struct macsec_context ctx;
 	struct macsec_dev *macsec;
-	int ret;
+	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -2634,28 +2634,36 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
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
@@ -2690,7 +2698,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 
 rollback:
 	macsec->offload = prev_offload;
-
+out:
 	rtnl_unlock();
 	return ret;
 }
-- 
2.35.1



