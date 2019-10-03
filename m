Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81AFCA85B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390912AbfJCQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390948AbfJCQZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:25:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7C6220867;
        Thu,  3 Oct 2019 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119939;
        bh=j1VMz70szKG1in2f+5pz0U3jeGXcWdIJYP6XH2tNQWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBelC5Pz7s1bndCpJk8w/nzxY3dJ40El++8e9HFf1mXDFrFcjbIYFkEFj/oWWw5c/
         PvDKHfvmFoapyJcFK4dLXF8eHHnAoD9kfmnBuWM41eLcn174xNs1bgxwChCuo0vd3H
         czd2TDc0B1eRrxssckKBq6U/mepT5RpF8baM+m8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Mamonov <pmamonov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.2 005/313] net/phy: fix DP83865 10 Mbps HDX loopback disable function
Date:   Thu,  3 Oct 2019 17:49:43 +0200
Message-Id: <20191003154534.045366125@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Mamonov <pmamonov@gmail.com>

[ Upstream commit e47488b2df7f9cb405789c7f5d4c27909fc597ae ]

According to the DP83865 datasheet "the 10 Mbps HDX loopback can be
disabled in the expanded memory register 0x1C0.1". The driver erroneously
used bit 0 instead of bit 1.

Fixes: 4621bf129856 ("phy: Add file missed in previous commit.")
Signed-off-by: Peter Mamonov <pmamonov@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/national.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/phy/national.c
+++ b/drivers/net/phy/national.c
@@ -105,14 +105,17 @@ static void ns_giga_speed_fallback(struc
 
 static void ns_10_base_t_hdx_loopack(struct phy_device *phydev, int disable)
 {
+	u16 lb_dis = BIT(1);
+
 	if (disable)
-		ns_exp_write(phydev, 0x1c0, ns_exp_read(phydev, 0x1c0) | 1);
+		ns_exp_write(phydev, 0x1c0,
+			     ns_exp_read(phydev, 0x1c0) | lb_dis);
 	else
 		ns_exp_write(phydev, 0x1c0,
-			     ns_exp_read(phydev, 0x1c0) & 0xfffe);
+			     ns_exp_read(phydev, 0x1c0) & ~lb_dis);
 
 	pr_debug("10BASE-T HDX loopback %s\n",
-		 (ns_exp_read(phydev, 0x1c0) & 0x0001) ? "off" : "on");
+		 (ns_exp_read(phydev, 0x1c0) & lb_dis) ? "off" : "on");
 }
 
 static int ns_config_init(struct phy_device *phydev)


