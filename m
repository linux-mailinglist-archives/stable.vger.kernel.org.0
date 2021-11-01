Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9716441697
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhKAJ1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59239 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232233AbhKAJZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:25:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07EBC611CC;
        Mon,  1 Nov 2021 09:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758508;
        bh=5TlQ6vGlCib0RwDkFOOqWBnf2JRpB/cz1ydcz49TyKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuKcypyZz91947aSlSBKg2RHPJ9tPHoMGVTU0xrgtUi/BAP2vamXTX3ECYYgER88y
         bjlDHtN4bqpyffEWvt+ue5+w/IJPnsPzzbQNLJlC0qo2dXp1P+Y8fVQZbPCppTvBfb
         YSgZ3glBggvh+m3vUW86oDK4d7zEhZgeWlzFlano=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuiko Oshino <yuiko.oshino@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 28/35] net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
Date:   Mon,  1 Nov 2021 10:17:40 +0100
Message-Id: <20211101082458.305646755@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuiko Oshino <yuiko.oshino@microchip.com>

commit d6423d2ec39cce2bfca418c81ef51792891576bc upstream.

The driver needs to clean up and return when the initialization fails on resume.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3003,6 +3003,8 @@ static int lan743x_pm_resume(struct devi
 	if (ret) {
 		netif_err(adapter, probe, adapter->netdev,
 			  "lan743x_hardware_init returned %d\n", ret);
+		lan743x_pci_cleanup(adapter);
+		return ret;
 	}
 
 	/* open netdev when netdev is at running state while resume.


