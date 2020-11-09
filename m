Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7F82ABBB3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732526AbgKIN3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732507AbgKINL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:11:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59DF820663;
        Mon,  9 Nov 2020 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927519;
        bh=k4bdtbA0dFbR9aFZwYxBWMXTGB4kKHFu9Z/ClaWl9Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cicXjg37GJRMSqXhYg+kpyLN6IexJu/ulytXkvagT9gnDWSRmBuAoIVkLVgWQyt6m
         kgwn32hZFbwL/jaiKVH2L66YzrNKl8gUsrPlxVG5w/toarXB1fw6/QGxTp+0nUHXz3
         IffDI8aeLJ25M0UnFoXiZrDyQCoCofuLrYK2ZJTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 16/85] ionic: check port ptr before use
Date:   Mon,  9 Nov 2020 13:55:13 +0100
Message-Id: <20201109125023.366063108@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
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
@@ -125,6 +125,11 @@ static int ionic_get_link_ksettings(stru
 
 	ethtool_link_ksettings_zero_link_mode(ks, supported);
 
+	if (!idev->port_info) {
+		netdev_err(netdev, "port_info not initialized\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* The port_info data is found in a DMA space that the NIC keeps
 	 * up-to-date, so there's no need to request the data from the
 	 * NIC, we already have it in our memory space.


