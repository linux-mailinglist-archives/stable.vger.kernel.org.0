Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDE24D7A2
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfFTSN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbfFTSN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:13:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01DC52082C;
        Thu, 20 Jun 2019 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054408;
        bh=SjfTpmvzvuQZ9JZgKZvtzkAgoLB4u3yXSE2feqq0kUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcN+zS6qFgs8AYE7bJpEqNeR3bGpK2rBj3knf5DAXevsmBAJv8yIsvhFNt7C+xwak
         fKyRTToImnQd1uzti2a4wAMNeHg/zw3FiNfNaVVB+7BOqMp3fCxNZSisG4gDQgVqKo
         cbnMoD3vneS3gHn8YL1Le81bKiiFsj9ZOBFNYNzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 08/98] net: dsa: rtl8366: Fix up VLAN filtering
Date:   Thu, 20 Jun 2019 19:56:35 +0200
Message-Id: <20190620174349.751989092@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 760c80b70bed2cd01630e8595d1bbde910339f31 ]

We get this regression when using RTL8366RB as part of a bridge
with OpenWrt:

WARNING: CPU: 0 PID: 1347 at net/switchdev/switchdev.c:291
	 switchdev_port_attr_set_now+0x80/0xa4
lan0: Commit of attribute (id=7) failed.
(...)
realtek-smi switch lan0: failed to initialize vlan filtering on this port

This is because it is trying to disable VLAN filtering
on VLAN0, as we have forgot to add 1 to the port number
to get the right VLAN in rtl8366_vlan_filtering(): when
we initialize the VLAN we associate VLAN1 with port 0,
VLAN2 with port 1 etc, so we need to add 1 to the port
offset.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/rtl8366.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -307,7 +307,8 @@ int rtl8366_vlan_filtering(struct dsa_sw
 	struct rtl8366_vlan_4k vlan4k;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, port))
+	/* Use VLAN nr port + 1 since VLAN0 is not valid */
+	if (!smi->ops->is_vlan_valid(smi, port + 1))
 		return -EINVAL;
 
 	dev_info(smi->dev, "%s filtering on port %d\n",
@@ -318,12 +319,12 @@ int rtl8366_vlan_filtering(struct dsa_sw
 	 * The hardware support filter ID (FID) 0..7, I have no clue how to
 	 * support this in the driver when the callback only says on/off.
 	 */
-	ret = smi->ops->get_vlan_4k(smi, port, &vlan4k);
+	ret = smi->ops->get_vlan_4k(smi, port + 1, &vlan4k);
 	if (ret)
 		return ret;
 
 	/* Just set the filter to FID 1 for now then */
-	ret = rtl8366_set_vlan(smi, port,
+	ret = rtl8366_set_vlan(smi, port + 1,
 			       vlan4k.member,
 			       vlan4k.untag,
 			       1);


