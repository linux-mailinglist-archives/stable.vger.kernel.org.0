Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BE44094BA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242160AbhIMOd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346504AbhIMObv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5122861BA5;
        Mon, 13 Sep 2021 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541118;
        bh=wEGxYt0NRMm/HmyEG2GpPfJ1BKVhbutcfRASDllrfoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNuNdpsTWVg+2l8kor+KoQhaoj72mHlHsFM8EayiIE66o6nCd+0+evrghHOZaDyAz
         o5rG7sX89Km/pafT6IuEdzukCapijv4uQKQxkDwWwOqA+PxsDK20J5Cz1Hau6G6zdC
         W7IxyECD0TyBtjQOY4IB+Gf3wnb8LagLl5ky+FHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 138/334] net: ti: am65-cpsw-nuss: fix wrong devlink release order
Date:   Mon, 13 Sep 2021 15:13:12 +0200
Message-Id: <20210913131118.028117756@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit acf34954efd17d4f65c7bb3e614381e6afc33222 ]

The commit that introduced devlink support released devlink resources in
wrong order, that made an unwind flow to be asymmetrical. In addition,
the am65-cpsw-nuss used internal to devlink core field - registered.

In order to fix the unwind flow and remove such access to the
registered field, rewrite the code to call devlink_port_unregister only
on registered ports.

Fixes: 58356eb31d60 ("net: ti: am65-cpsw-nuss: Add devlink support")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 34 ++++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 67a08cbba859..fb58fc470773 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2388,21 +2388,6 @@ static const struct devlink_param am65_cpsw_devlink_params[] = {
 			     am65_cpsw_dl_switch_mode_set, NULL),
 };
 
-static void am65_cpsw_unregister_devlink_ports(struct am65_cpsw_common *common)
-{
-	struct devlink_port *dl_port;
-	struct am65_cpsw_port *port;
-	int i;
-
-	for (i = 1; i <= common->port_num; i++) {
-		port = am65_common_get_port(common, i);
-		dl_port = &port->devlink_port;
-
-		if (dl_port->registered)
-			devlink_port_unregister(dl_port);
-	}
-}
-
 static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 {
 	struct devlink_port_attrs attrs = {};
@@ -2464,7 +2449,12 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 	return ret;
 
 dl_port_unreg:
-	am65_cpsw_unregister_devlink_ports(common);
+	for (i = i - 1; i >= 1; i--) {
+		port = am65_common_get_port(common, i);
+		dl_port = &port->devlink_port;
+
+		devlink_port_unregister(dl_port);
+	}
 dl_unreg:
 	devlink_unregister(common->devlink);
 dl_free:
@@ -2475,6 +2465,17 @@ dl_free:
 
 static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 {
+	struct devlink_port *dl_port;
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 1; i <= common->port_num; i++) {
+		port = am65_common_get_port(common, i);
+		dl_port = &port->devlink_port;
+
+		devlink_port_unregister(dl_port);
+	}
+
 	if (!AM65_CPSW_IS_CPSW2G(common) &&
 	    IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV)) {
 		devlink_params_unpublish(common->devlink);
@@ -2482,7 +2483,6 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 					  ARRAY_SIZE(am65_cpsw_devlink_params));
 	}
 
-	am65_cpsw_unregister_devlink_ports(common);
 	devlink_unregister(common->devlink);
 	devlink_free(common->devlink);
 }
-- 
2.30.2



