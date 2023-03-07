Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465B16AEE35
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjCGSKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjCGSKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD321A3B7F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 676A0B819C1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72E7C4339E;
        Tue,  7 Mar 2023 18:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212270;
        bh=bESz5YXKTObq0V7ITK9xXLVOrD03FJnvaNMiMWEXcb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtqJKRfg8q7arAqUJR/LuztLq32Sc6vH2+Mx2W8/G7YeMZicoHegGD7OTlsfActaU
         MuqCUY3bsg2mnVHYVEJhnLVPdstolvXQKnSNChcqcJ7BWAcYoc6NI7wghDyYyZE4vS
         Dhk8elDe5LQrisrhZ9WMwpUwV188pBPz7gqZ+4Ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/885] wifi: wilc1000: add missing unregister_netdev() in wilc_netdev_ifc_init()
Date:   Tue,  7 Mar 2023 17:51:05 +0100
Message-Id: <20230307170007.541420641@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 2b88974ecb358990e1c33fabcd0b9e142bab7f21 ]

Fault injection test reports this issue:

kernel BUG at net/core/dev.c:10731!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
Call Trace:
  <TASK>
  wilc_netdev_ifc_init+0x19f/0x220 [wilc1000 884bf126e9e98af6a708f266a8dffd53f99e4bf5]
  wilc_cfg80211_init+0x30c/0x380 [wilc1000 884bf126e9e98af6a708f266a8dffd53f99e4bf5]
  wilc_bus_probe+0xad/0x2b0 [wilc1000_spi 1520a7539b6589cc6cde2ae826a523a33f8bacff]
  spi_probe+0xe4/0x140
  really_probe+0x17e/0x3f0
  __driver_probe_device+0xe3/0x170
  driver_probe_device+0x49/0x120

The root case here is alloc_ordered_workqueue() fails, but
cfg80211_unregister_netdevice() or unregister_netdev() not be called in
error handling path. To fix add unregister_netdev goto lable to add the
unregister operation in error handling path.

Fixes: 09ed8bfc5215 ("wilc1000: Rename workqueue from "WILC_wq" to "NETDEV-wq"")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1669289902-23639-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 6f3ae0dff77ce..e9f59de31b0b9 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -981,7 +981,7 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 						    ndev->name);
 	if (!wl->hif_workqueue) {
 		ret = -ENOMEM;
-		goto error;
+		goto unregister_netdev;
 	}
 
 	ndev->needs_free_netdev = true;
@@ -996,6 +996,11 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 
 	return vif;
 
+unregister_netdev:
+	if (rtnl_locked)
+		cfg80211_unregister_netdevice(ndev);
+	else
+		unregister_netdev(ndev);
   error:
 	free_netdev(ndev);
 	return ERR_PTR(ret);
-- 
2.39.2



