Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AEB2ABAFF
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbgKINRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732608AbgKINRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CBA9206D8;
        Mon,  9 Nov 2020 13:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927865;
        bh=IWpnoVGgPrEpqICtl5BEhk3ZA7dFCqn5AXHcmN04IpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYJu3sPrQz1bnbAWrfPkpt9oEm/ukwOY4A5bTsMzPQToj2+/sT03pL+d0r+fIW380
         Y7LMGzOwG+uWfe6qUNNCQLrDVowZKppvs4rwOc7QdFussdMukC1j3v8e1VW/cgg0pf
         wUflZcQ9DAoJnim8tIZvNhAKyRP59sbvpAbx9uoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 030/133] ionic: check port ptr before use
Date:   Mon,  9 Nov 2020 13:54:52 +0100
Message-Id: <20201109125032.164577627@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 2bcbf42add911ef63a6d90e92001dc2bcb053e68 ]

Check for corner case of port_init failure before using
the port_info pointer.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Link: https://lore.kernel.org/r/20201104195606.61184-1-snelson@pensando.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -126,6 +126,11 @@ static int ionic_get_link_ksettings(stru
 
 	ethtool_link_ksettings_zero_link_mode(ks, supported);
 
+	if (!idev->port_info) {
+		netdev_err(netdev, "port_info not initialized\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* The port_info data is found in a DMA space that the NIC keeps
 	 * up-to-date, so there's no need to request the data from the
 	 * NIC, we already have it in our memory space.


