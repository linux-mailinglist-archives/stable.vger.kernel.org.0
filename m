Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118EB1CAF7E
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgEHMkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbgEHMkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B7B421835;
        Fri,  8 May 2020 12:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941601;
        bh=YOt3SrFAUM73v1SQAW95vlQCcrp2aXIPWM4dzi4UCCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVe4IknIrKgWjI/d3LbTaZRHSk7bsymPChnIOR8J+lNvlJXayUcAGUcS9/uE5S7ls
         dEECPhIORN00vRsJg0fIeq/v5aImkFDQOqRPky7jLCOD4zOq3cgZM7350ampjjKQZe
         eMmqm7hC/3uL0K5G66jiuiwlzimMpd2cyyH45Bvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 096/312] phy: fix device reference leaks
Date:   Fri,  8 May 2020 14:31:27 +0200
Message-Id: <20200508123131.285141534@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 17ae1c650c1ecf8dc8e16d54b0f68a345965f43f upstream.

Make sure to drop the reference taken by bus_find_device_by_name()
before returning from phy_connect() and phy_attach().

Note that both function still take a reference to the phy device
through phy_attach_direct().

Fixes: e13934563db0 ("[PATCH] PHY Layer fixup")
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/phy_device.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -522,6 +522,7 @@ struct phy_device *phy_connect(struct ne
 	phydev = to_phy_device(d);
 
 	rc = phy_connect_direct(dev, phydev, handler, interface);
+	put_device(d);
 	if (rc)
 		return ERR_PTR(rc);
 
@@ -721,6 +722,7 @@ struct phy_device *phy_attach(struct net
 	phydev = to_phy_device(d);
 
 	rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
+	put_device(d);
 	if (rc)
 		return ERR_PTR(rc);
 


