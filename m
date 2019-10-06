Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CECCD798
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfJFRcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbfJFRb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:31:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7EB02080F;
        Sun,  6 Oct 2019 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383119;
        bh=qbJambDLBU2iCC1IS1jCXXoXh7F8TMycRq4h3giH+D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSsbawUNn75B0DOQpHEks7oYh2Vd27Ad+TYoe0Q8Ei0Z2QGaRjJkOypiZVzc1UXsf
         flvXsZXE+t8bwqvP0oddjI+WaliWYNN1vgJcYeHsIz+1oY8T7FApIfWlXEPG2XHUYh
         RW/TA/kmb8TtPXJC9tlrWli/57lwJeMFh7GAfTsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 094/106] net: dsa: rtl8366: Check VLAN ID and not ports
Date:   Sun,  6 Oct 2019 19:21:40 +0200
Message-Id: <20191006171201.248363083@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e8521e53cca584ddf8ec4584d3c550a6c65f88c4 ]

There has been some confusion between the port number and
the VLAN ID in this driver. What we need to check for
validity is the VLAN ID, nothing else.

The current confusion came from assigning a few default
VLANs for default routing and we need to rewrite that
properly.

Instead of checking if the port number is a valid VLAN
ID, check the actual VLAN IDs passed in to the callback
one by one as expected.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/rtl8366.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -339,10 +339,12 @@ int rtl8366_vlan_prepare(struct dsa_swit
 			 const struct switchdev_obj_port_vlan *vlan)
 {
 	struct realtek_smi *smi = ds->priv;
+	u16 vid;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, port))
-		return -EINVAL;
+	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
+		if (!smi->ops->is_vlan_valid(smi, vid))
+			return -EINVAL;
 
 	dev_info(smi->dev, "prepare VLANs %04x..%04x\n",
 		 vlan->vid_begin, vlan->vid_end);
@@ -370,8 +372,9 @@ void rtl8366_vlan_add(struct dsa_switch
 	u16 vid;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, port))
-		return;
+	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
+		if (!smi->ops->is_vlan_valid(smi, vid))
+			return;
 
 	dev_info(smi->dev, "add VLAN on port %d, %s, %s\n",
 		 port,


