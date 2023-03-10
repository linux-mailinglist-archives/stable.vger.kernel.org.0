Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A46B44F7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjCJOaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjCJO3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0098624BC1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:28:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CA136187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C373C433EF;
        Fri, 10 Mar 2023 14:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458489;
        bh=fm77gIIHmj3eqTwS+dL6Szx4Kfp2bsvPLn/zkJFEPX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lw9KW6gakn+csWz8zQp3B6FzwLs77o5BnHtb8oPNGua9wazFexxiZzXcx7zxS4sVT
         y+/1zx1Si+HAD9ZXx59qfE7I/7+Gtzd8MDh8uyruY9KbVr+U2uYdUHq5B42JDwFF39
         SfRe5expFA3453dXulcNCYXoLAE/c5/ghQEGf0Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/357] wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()
Date:   Fri, 10 Mar 2023 14:35:32 +0100
Message-Id: <20230310133735.890963667@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit deb962ec9e1c9a81babd3d37542ad4bd6ac3396e ]

The wilc_mac_xmit() returns NETDEV_TX_OK without freeing skb, add
dev_kfree_skb() to fix it. Compile tested only.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1668684964-48622-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/wilc_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_netdev.c b/drivers/staging/wilc1000/wilc_netdev.c
index c8cf88258d06d..f34b1f0d3a803 100644
--- a/drivers/staging/wilc1000/wilc_netdev.c
+++ b/drivers/staging/wilc1000/wilc_netdev.c
@@ -717,6 +717,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	if (skb->dev != ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.39.2



