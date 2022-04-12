Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E386A4FCF76
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiDLG1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbiDLG1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:27:23 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EB23585C
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 23:25:06 -0700 (PDT)
Received: from kwepemi100010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kcwg23dCmzdZhr;
        Tue, 12 Apr 2022 14:24:30 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100010.china.huawei.com (7.221.188.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 14:25:04 +0800
Received: from localhost.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 14:25:04 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <duoming@zju.edu.cn>, <linma@zju.edu.cn>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: [PATCH 5.10 2/2] hamradio: remove needs_free_netdev to avoid UAF
Date:   Tue, 12 Apr 2022 14:39:04 +0800
Message-ID: <1649745544-19915-2-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649745544-19915-1-git-send-email-xujia39@huawei.com>
References: <1649745544-19915-1-git-send-email-xujia39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 81b1d548d00bcd028303c4f3150fa753b9b8aa71 upstream.

The former patch "defer 6pack kfree after unregister_netdev" reorders
the kfree of two buffer after the unregister_netdev to prevent the race
condition. It also adds free_netdev() function in sixpack_close(), which
is a direct copy from the similar code in mkiss_close().

However, in sixpack driver, the flag needs_free_netdev is set to true in
sp_setup(), hence the unregister_netdev() will free the netdev
automatically. Therefore, as the sp is netdev_priv, use-after-free
occurs.

This patch removes the needs_free_netdev = true and just let the
free_netdev to finish this deallocation task.

Fixes: 0b9111922b1f ("hamradio: defer 6pack kfree after unregister_netdev")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20211111141402.7551-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 drivers/net/hamradio/6pack.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 82507a6..83dc1c2 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -311,7 +311,6 @@ static void sp_setup(struct net_device *dev)
 {
 	/* Finish setting up the DEVICE info. */
 	dev->netdev_ops		= &sp_netdev_ops;
-	dev->needs_free_netdev	= true;
 	dev->mtu		= SIXP_MTU;
 	dev->hard_header_len	= AX25_MAX_HEADER_LEN;
 	dev->header_ops 	= &ax25_header_ops;
-- 
1.8.3.1

