Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F86541C9A
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382602AbiFGV7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382609AbiFGVvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C762923D571;
        Tue,  7 Jun 2022 12:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BC4DB82182;
        Tue,  7 Jun 2022 19:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607F0C385A2;
        Tue,  7 Jun 2022 19:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628942;
        bh=kHhAYoGsPhV9+EArSetHwxqqBlxp/Pw5NoliB/+7KMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCQf9XRmaouDwOPsyKZjKykbPNd1TuNbJQzd6ORUe0tkcVoPOkA2pEvLgAqHHS+ZT
         yGlY6PQdoFZ0vTqtFB3v5Nxc+811ioYmxfUDBbS0W0wjsb5u/dKlKT7oTZTDbovQEz
         Fc8+cWxMlWTx7GCrXcmKpQmqBdEBF9cwVb/k1t6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 513/879] hv_netvsc: Fix potential dereference of NULL pointer
Date:   Tue,  7 Jun 2022 19:00:31 +0200
Message-Id: <20220607165017.766421564@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongzhi Liu <lyz_cs@pku.edu.cn>

[ Upstream commit eb4c0788964730d12e8dd520bd8f5217ca48321c ]

The return value of netvsc_devinfo_get()
needs to be checked to avoid use of NULL
pointer in case of an allocation failure.

Fixes: 0efeea5fb153 ("hv_netvsc: Add the support of hibernation")
Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/1652962188-129281-1-git-send-email-lyz_cs@pku.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index fde1c492ca02..b1dece6b9698 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2671,7 +2671,10 @@ static int netvsc_suspend(struct hv_device *dev)
 
 	/* Save the current config info */
 	ndev_ctx->saved_netvsc_dev_info = netvsc_devinfo_get(nvdev);
-
+	if (!ndev_ctx->saved_netvsc_dev_info) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = netvsc_detach(net, nvdev);
 out:
 	rtnl_unlock();
-- 
2.35.1



