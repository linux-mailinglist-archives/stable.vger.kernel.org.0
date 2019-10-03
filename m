Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAC8CAB92
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfJCP4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730610AbfJCP4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:56:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FEC5207FF;
        Thu,  3 Oct 2019 15:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118190;
        bh=PzDVJIaJusdMjmT/cggQNTFeh15nn52NkL+YCM8KRfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tP1JyMjqNZ4G7VDj0yjmFhwLQrUEUI9Chmze8ZHtD43VKglOn2MnvqOYAZY3zBSEs
         2Xb8qod8zsUFXOCnQdH3zgIH4crZb/eKvXZDqIVc8geAitdrmagbt0cJf/dU358d9b
         9T3g7t7u+uzw0PfFRzawXR2a9a3VMHooF/hwTW6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Mamonov <pmamonov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.4 22/99] net/phy: fix DP83865 10 Mbps HDX loopback disable function
Date:   Thu,  3 Oct 2019 17:52:45 +0200
Message-Id: <20191003154304.750742111@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
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
@@ -110,14 +110,17 @@ static void ns_giga_speed_fallback(struc
 
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


