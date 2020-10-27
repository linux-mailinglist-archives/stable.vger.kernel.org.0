Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B63629C337
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902120AbgJ0ObO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759940AbgJ0Oaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:30:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4AFD20754;
        Tue, 27 Oct 2020 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809029;
        bh=BhncGg9zaCLc/KLPXCiToLwauHrEKoHa+9CUnCk2/8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCNZWqQReRjA06hnxobIkbPx3KjwJ/7BdbQXaYm1Ci939pNnN+oPmHwKJ7u1CtZLl
         Ml/1S2PNfhlMTXzb8XzIhQKKAmTau+AlaKxMqguRfUC7YpzJDG3ILxmvWw4WXtOScD
         ZVLgpiTIZj3RwNu+ptarTKEbHdmq4DRtoAe0I1Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Tesarik <ptesarik@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.4 018/408] r8169: fix data corruption issue on RTL8402
Date:   Tue, 27 Oct 2020 14:49:16 +0100
Message-Id: <20201027135455.901478394@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ef9da46ddef071e1bbb943afbbe9b38771855554 ]

Petr reported that after resume from suspend RTL8402 partially
truncates incoming packets, and re-initializing register RxConfig
before the actual chip re-initialization sequence is needed to avoid
the issue.

Reported-by: Petr Tesarik <ptesarik@suse.cz>
Proposed-by: Petr Tesarik <ptesarik@suse.cz>
Tested-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5514,6 +5514,10 @@ static int rtl8169_change_mtu(struct net
 	dev->mtu = new_mtu;
 	netdev_update_features(dev);
 
+	/* Reportedly at least Asus X453MA truncates packets otherwise */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+		rtl_init_rxcfg(tp);
+
 	return 0;
 }
 


