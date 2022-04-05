Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2094F30F6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbiDEJfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbiDEIQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1C5A5EB5;
        Tue,  5 Apr 2022 01:03:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0777BB81BA7;
        Tue,  5 Apr 2022 08:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5960CC385A0;
        Tue,  5 Apr 2022 08:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145797;
        bh=1R95iKwLg6uykAlkrYJDXyi0yVHdPcfqRxwyL5W0GOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MKtSL4wFyaeHtZVO9giCqlTxCblcGMSIptOMoHz0IBpQ1OaqZS/ne4ICLaXtHI3j
         ZT5a/vJcwUo4yLTCEt+T2BOXqJpMJmmI1ovSMaqhAnIUjeopYZksdBLTJOkb4Qmzht
         7s/000BNQ/xPpTC7Y5YuK0+0xdoSc4YUuBgPaajU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0533/1126] Netvsc: Call hv_unmap_memory() in the netvsc_device_remove()
Date:   Tue,  5 Apr 2022 09:21:20 +0200
Message-Id: <20220405070423.275859303@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

[ Upstream commit b539324f6fe798bdb186e4e91eafb37dd851db2a ]

netvsc_device_remove() calls vunmap() inside which should not be
called in the interrupt context. Current code calls hv_unmap_memory()
in the free_netvsc_device() which is rcu callback and maybe called
in the interrupt context. This will trigger BUG_ON(in_interrupt())
in the vunmap(). Fix it via moving hv_unmap_memory() to netvsc_device_
remove().

Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index afa81a9480cc..e675d1016c3c 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -154,19 +154,15 @@ static void free_netvsc_device(struct rcu_head *head)
 
 	kfree(nvdev->extension);
 
-	if (nvdev->recv_original_buf) {
-		hv_unmap_memory(nvdev->recv_buf);
+	if (nvdev->recv_original_buf)
 		vfree(nvdev->recv_original_buf);
-	} else {
+	else
 		vfree(nvdev->recv_buf);
-	}
 
-	if (nvdev->send_original_buf) {
-		hv_unmap_memory(nvdev->send_buf);
+	if (nvdev->send_original_buf)
 		vfree(nvdev->send_original_buf);
-	} else {
+	else
 		vfree(nvdev->send_buf);
-	}
 
 	bitmap_free(nvdev->send_section_map);
 
@@ -765,6 +761,12 @@ void netvsc_device_remove(struct hv_device *device)
 		netvsc_teardown_send_gpadl(device, net_device, ndev);
 	}
 
+	if (net_device->recv_original_buf)
+		hv_unmap_memory(net_device->recv_buf);
+
+	if (net_device->send_original_buf)
+		hv_unmap_memory(net_device->send_buf);
+
 	/* Release all resources */
 	free_netvsc_device_rcu(net_device);
 }
@@ -1821,6 +1823,12 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 	netif_napi_del(&net_device->chan_table[0].napi);
 
 cleanup2:
+	if (net_device->recv_original_buf)
+		hv_unmap_memory(net_device->recv_buf);
+
+	if (net_device->send_original_buf)
+		hv_unmap_memory(net_device->send_buf);
+
 	free_netvsc_device(&net_device->rcu);
 
 	return ERR_PTR(ret);
-- 
2.34.1



