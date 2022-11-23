Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC7E6356DD
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbiKWJgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237862AbiKWJfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:35:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74FF7C697
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:33:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FB05B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAACC433D7;
        Wed, 23 Nov 2022 09:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195992;
        bh=XfMfgMe8lbKu34voISkyYmbekNIIsZxoeYhUhW5IZ+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXd9yahAXTrmzHHQE6VtbgIflLAqV0GgtLscJKXzUsZHGOILmGbFmlHXQFsyZwBCI
         tOFFgfh3oZ1GcIsq6oiLOCO2nr9PAMnPOXvOSzIViscLEqDJ8siXGpZf+2Cr5wecik
         n5F9JTq0koG+ZspjLV7gLJXDDD/DSmMJiVAW7CMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/181] net: mhi: Fix memory leak in mhi_net_dellink()
Date:   Wed, 23 Nov 2022 09:50:52 +0100
Message-Id: <20221123084606.176445831@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit f7c125bd79f50ec6094761090be81d02726ec6f4 ]

MHI driver registers network device without setting the
needs_free_netdev flag, and does NOT call free_netdev() when
unregisters network device, which causes a memory leak.

This patch calls free_netdev() to fix it since netdev_priv
is used after unregister.

Fixes: 13adac032982 ("net: mhi_net: Register wwan_ops for link creation")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mhi_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index aaa628f859fd..f84554aa02af 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -343,6 +343,8 @@ static void mhi_net_dellink(struct mhi_device *mhi_dev, struct net_device *ndev)
 
 	kfree_skb(mhi_netdev->skbagg_head);
 
+	free_netdev(ndev);
+
 	dev_set_drvdata(&mhi_dev->dev, NULL);
 }
 
-- 
2.35.1



