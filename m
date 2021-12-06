Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1A6469D08
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356140AbhLFP16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:27:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40678 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356569AbhLFPWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:22:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CB0A612DB;
        Mon,  6 Dec 2021 15:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7026EC341C2;
        Mon,  6 Dec 2021 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803934;
        bh=L1qaNGXU6bejk8ImdcDhO7c6jEDjEEWi7YqN7a9ocl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjZViyTePAeYilxeZqnZhylOAi+Ldlh3qw+jJa7Ov6vJ73PH4vwAQeGcpx69PsZa/
         AOD011OWtS4IJDGYoHQdy00kFjktBKVyRtOm+nfkXo1ipazXWnokMrfnthR4+VmUlG
         TtbjpZsDi4WiCWQHR7KW6eesXi7Dbq9gRGhmSqxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Danilov <ndanilov@aquantia.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 097/130] atlatnic: enable Nbase-t speeds with base-t
Date:   Mon,  6 Dec 2021 15:56:54 +0100
Message-Id: <20211206145603.008506128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Danilov <ndanilov@aquantia.com>

commit aa685acd98eae25d5351e30288d6cfb65b9c80a5 upstream.

When 2.5G is advertised, N-Base should be advertised against the T-base
caps. N5G is out of use in baseline code and driver should treat both 5G
and N5G (and also 2.5G and N2.5G) equally from user perspective.

Fixes: 5cfd54d7dc186 ("net: atlantic: minimal A2 fw_ops")
Signed-off-by: Nikita Danilov <ndanilov@aquantia.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_common.h                |   25 ++++------
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c |    3 -
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c |    4 -
 3 files changed, 13 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -53,20 +53,19 @@
 
 #define AQ_NIC_RATE_10G		BIT(0)
 #define AQ_NIC_RATE_5G		BIT(1)
-#define AQ_NIC_RATE_5GSR	BIT(2)
-#define AQ_NIC_RATE_2G5		BIT(3)
-#define AQ_NIC_RATE_1G		BIT(4)
-#define AQ_NIC_RATE_100M	BIT(5)
-#define AQ_NIC_RATE_10M		BIT(6)
-#define AQ_NIC_RATE_1G_HALF	BIT(7)
-#define AQ_NIC_RATE_100M_HALF	BIT(8)
-#define AQ_NIC_RATE_10M_HALF	BIT(9)
+#define AQ_NIC_RATE_2G5		BIT(2)
+#define AQ_NIC_RATE_1G		BIT(3)
+#define AQ_NIC_RATE_100M	BIT(4)
+#define AQ_NIC_RATE_10M		BIT(5)
+#define AQ_NIC_RATE_1G_HALF	BIT(6)
+#define AQ_NIC_RATE_100M_HALF	BIT(7)
+#define AQ_NIC_RATE_10M_HALF	BIT(8)
 
-#define AQ_NIC_RATE_EEE_10G	BIT(10)
-#define AQ_NIC_RATE_EEE_5G	BIT(11)
-#define AQ_NIC_RATE_EEE_2G5	BIT(12)
-#define AQ_NIC_RATE_EEE_1G	BIT(13)
-#define AQ_NIC_RATE_EEE_100M	BIT(14)
+#define AQ_NIC_RATE_EEE_10G	BIT(9)
+#define AQ_NIC_RATE_EEE_5G	BIT(10)
+#define AQ_NIC_RATE_EEE_2G5	BIT(11)
+#define AQ_NIC_RATE_EEE_1G	BIT(12)
+#define AQ_NIC_RATE_EEE_100M	BIT(13)
 #define AQ_NIC_RATE_EEE_MSK     (AQ_NIC_RATE_EEE_10G |\
 				 AQ_NIC_RATE_EEE_5G |\
 				 AQ_NIC_RATE_EEE_2G5 |\
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -132,9 +132,6 @@ static enum hw_atl_fw2x_rate link_speed_
 	if (speed & AQ_NIC_RATE_5G)
 		rate |= FW2X_RATE_5G;
 
-	if (speed & AQ_NIC_RATE_5GSR)
-		rate |= FW2X_RATE_5G;
-
 	if (speed & AQ_NIC_RATE_2G5)
 		rate |= FW2X_RATE_2G5;
 
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -154,7 +154,7 @@ static void a2_link_speed_mask2fw(u32 sp
 {
 	link_options->rate_10G = !!(speed & AQ_NIC_RATE_10G);
 	link_options->rate_5G = !!(speed & AQ_NIC_RATE_5G);
-	link_options->rate_N5G = !!(speed & AQ_NIC_RATE_5GSR);
+	link_options->rate_N5G = link_options->rate_5G;
 	link_options->rate_2P5G = !!(speed & AQ_NIC_RATE_2G5);
 	link_options->rate_N2P5G = link_options->rate_2P5G;
 	link_options->rate_1G = !!(speed & AQ_NIC_RATE_1G);
@@ -192,8 +192,6 @@ static u32 a2_fw_lkp_to_mask(struct lkp_
 		rate |= AQ_NIC_RATE_10G;
 	if (lkp_link_caps->rate_5G)
 		rate |= AQ_NIC_RATE_5G;
-	if (lkp_link_caps->rate_N5G)
-		rate |= AQ_NIC_RATE_5GSR;
 	if (lkp_link_caps->rate_2P5G)
 		rate |= AQ_NIC_RATE_2G5;
 	if (lkp_link_caps->rate_1G)


