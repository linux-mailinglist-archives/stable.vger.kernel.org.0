Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F8A27886D
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgIYMzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729616AbgIYMy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91ACF206DB;
        Fri, 25 Sep 2020 12:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038498;
        bh=3CxEedJgFMUT9aAxvc8DjPu3Fk3FQFyN00bflofktYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsFM/1J5A2HVt7UxNrN8aYofgVULSKjisF7c+oCNKaXloCsR1WXuXGC0TETREi+br
         lF9Iwu/87WM91p7uzEJw5ISXBEC+W4XILrYDoUBU3QFx4702/hiLjuUI+ZeJyrIjMp
         JvHR5NyR1N5+IdYTZNOWV1gcf5yKNJ6ZWZJjtxjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 11/37] net: dsa: rtl8366: Properly clear member config
Date:   Fri, 25 Sep 2020 14:48:39 +0200
Message-Id: <20200925124722.639625577@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
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


