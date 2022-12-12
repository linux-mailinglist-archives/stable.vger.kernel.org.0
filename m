Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C2764A1DB
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiLLNqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiLLNqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:46:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63F5140AC
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:45:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6995DB80D2C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FF1C433D2;
        Mon, 12 Dec 2022 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852747;
        bh=c8vW/LaiFzuQy1zTI6gQj9YCHIVWvo7b+WOwtQ5EtRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1ByCENdVkLqjTOsYnIvnCLVxQ1Jq90rCMj0wx9/jncLZ9oJnZO4hdKfS2/de7Dek
         qLeOJOVQXS0GCQ2oguEChk7RFDpBlavcwqT2fRaeqSoSCibveni5fCyRU8b8gKamkj
         n++31dultNfE6+q/N0QNof6b/3TSGa21oLvVNmOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 144/157] net: dsa: sja1105: fix memory leak in sja1105_setup_devlink_regions()
Date:   Mon, 12 Dec 2022 14:18:12 +0100
Message-Id: <20221212130940.938311770@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 78a9ea43fc1a7c06a420b132d2d47cbf4344a5df ]

When dsa_devlink_region_create failed in sja1105_setup_devlink_regions(),
priv->regions is not released.

Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221205012132.2110979-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 10c6fea1227f..bdbbff2a7909 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -95,6 +95,8 @@ static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
 		if (IS_ERR(region)) {
 			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
+
+			kfree(priv->regions);
 			return PTR_ERR(region);
 		}
 
-- 
2.35.1



