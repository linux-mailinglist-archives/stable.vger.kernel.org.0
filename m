Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0552B86FE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388956AbfISWdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405883AbfISWLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:11:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 319E6218AF;
        Thu, 19 Sep 2019 22:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931112;
        bh=vaGfJQtgEX20SkVdECVKbd9a+wVF0Ps8/spkJNFEFtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1jlu80HpkLtWC6Z4jz8NDPcu4ptgBslJdh/w/4pqOf3GugfYK2W7OeoeopYFfvPz
         4fmiff28EBxiA+YRgSXABzPrh2jRd4CT1p4vtGBOxPwiaOEpjko4SO1ntLXmNjnAiK
         RWus/8GYOwUtOoHhFx8/7blBDs49axC8LK/Kqe+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 103/124] net: aquantia: reapply vlan filters on up
Date:   Fri, 20 Sep 2019 00:03:11 +0200
Message-Id: <20190919214822.949275123@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit c2ef057ee775e229d3138add59f937d93a3a59d8 ]

In case of device reconfiguration the driver may reset the device invisible
for other modules, vlan module in particular. So vlans will not be
removed&created and vlan filters will not be configured in the device.
The patch reapplies the vlan filters at device start.

Fixes: 7975d2aff5afb ("net: aquantia: add support of rx-vlan-filter offload")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 5315df5ff6f83..4ebf083c51c5f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -61,6 +61,10 @@ static int aq_ndev_open(struct net_device *ndev)
 	if (err < 0)
 		goto err_exit;
 
+	err = aq_filters_vlans_update(aq_nic);
+	if (err < 0)
+		goto err_exit;
+
 	err = aq_nic_start(aq_nic);
 	if (err < 0)
 		goto err_exit;
-- 
2.20.1



