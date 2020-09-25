Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD542788DC
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgIYM63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbgIYMs4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:48:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0526221741;
        Fri, 25 Sep 2020 12:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038136;
        bh=3CxEedJgFMUT9aAxvc8DjPu3Fk3FQFyN00bflofktYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3ZMBGPhf0vXk3PnbzXHlvzjZcGbMZbjTY+Rhj+3mi6VlB1+IbM7FlvmSENXBn4VM
         FCb5ReScKi83BUaPFVeIxnR6vxKIZ/G18ovUwUh7m26zykkWIyz5KdJLh3vzlCXFXR
         Pfz9Lm2wgmlss1yhnYh/2wAUgP0+FpuVV1iR1G+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 17/56] net: dsa: rtl8366: Properly clear member config
Date:   Fri, 25 Sep 2020 14:48:07 +0200
Message-Id: <20200925124730.414777419@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 4ddcaf1ebb5e4e99240f29d531ee69d4244fe416 ]

When removing a port from a VLAN we are just erasing the
member config for the VLAN, which is wrong: other ports
can be using it.

Just mask off the port and only zero out the rest of the
member config once ports using of the VLAN are removed
from it.

Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/rtl8366.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -452,13 +452,19 @@ int rtl8366_vlan_del(struct dsa_switch *
 				return ret;
 
 			if (vid == vlanmc.vid) {
-				/* clear VLAN member configurations */
-				vlanmc.vid = 0;
-				vlanmc.priority = 0;
-				vlanmc.member = 0;
-				vlanmc.untag = 0;
-				vlanmc.fid = 0;
-
+				/* Remove this port from the VLAN */
+				vlanmc.member &= ~BIT(port);
+				vlanmc.untag &= ~BIT(port);
+				/*
+				 * If no ports are members of this VLAN
+				 * anymore then clear the whole member
+				 * config so it can be reused.
+				 */
+				if (!vlanmc.member && vlanmc.untag) {
+					vlanmc.vid = 0;
+					vlanmc.priority = 0;
+					vlanmc.fid = 0;
+				}
 				ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
 				if (ret) {
 					dev_err(smi->dev,


