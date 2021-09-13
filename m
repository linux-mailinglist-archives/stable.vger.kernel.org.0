Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30B24094FD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242170AbhIMOgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347507AbhIMOel (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7CF61BCF;
        Mon, 13 Sep 2021 13:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541182;
        bh=6nmA9n4kK62ghSGdCzVMvQVavRXk0YcfciuHa7ei03A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anVSt+7PVX/eX10jr9fjmTvzhN2YZzMGHFPrX+g+ssZC+3BHhfR4r8j44PuI/AlcE
         IKJR6en6vU3ClAbutD5Id0HPKb4oXAhkh8CWClIqS2PYKZf9wnMB8RpzeE61purH7f
         2iDg1kxRmnQFNrXv1+x/epcorfDKTO/XLGv3ml8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 169/334] net: dsa: build tag_8021q.c as part of DSA core
Date:   Mon, 13 Sep 2021 15:13:43 +0200
Message-Id: <20210913131119.054037398@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8b6e638b4be2ad77f61fb93b4e1776c6ccc2edab ]

Upcoming patches will add tag_8021q related logic to switch.c and
port.c, in order to allow it to make use of cross-chip notifiers.
In addition, a struct dsa_8021q_context *ctx pointer will be added to
struct dsa_switch.

It seems fairly low-reward to #ifdef the *ctx from struct dsa_switch and
to provide shim implementations of the entire tag_8021q.c calling
surface (not even clear what to do about the tag_8021q cross-chip
notifiers to avoid compiling them). The runtime overhead for switches
which don't use tag_8021q is fairly small because all helpers will check
for ds->tag_8021q_ctx being a NULL pointer and stop there.

So let's make it part of dsa_core.o.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/Kconfig     | 12 ------------
 net/dsa/Makefile    |  3 +--
 net/dsa/tag_8021q.c |  2 --
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 00bb89b2d86f..bca1b5d66df2 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -18,16 +18,6 @@ if NET_DSA
 
 # Drivers must select the appropriate tagging format(s)
 
-config NET_DSA_TAG_8021Q
-	tristate
-	select VLAN_8021Q
-	help
-	  Unlike the other tagging protocols, the 802.1Q config option simply
-	  provides helpers for other tagging implementations that might rely on
-	  VLAN in one way or another. It is not a complete solution.
-
-	  Drivers which use these helpers should select this as dependency.
-
 config NET_DSA_TAG_AR9331
 	tristate "Tag driver for Atheros AR9331 SoC with built-in switch"
 	help
@@ -126,7 +116,6 @@ config NET_DSA_TAG_OCELOT_8021Q
 	tristate "Tag driver for Ocelot family of switches, using VLAN"
 	depends on MSCC_OCELOT_SWITCH_LIB || \
 	          (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
-	select NET_DSA_TAG_8021Q
 	help
 	  Say Y or M if you want to enable support for tagging frames with a
 	  custom VLAN-based header. Frames that require timestamping, such as
@@ -149,7 +138,6 @@ config NET_DSA_TAG_LAN9303
 
 config NET_DSA_TAG_SJA1105
 	tristate "Tag driver for NXP SJA1105 switches"
-	select NET_DSA_TAG_8021Q
 	select PACKING
 	help
 	  Say Y or M if you want to enable support for tagging frames with the
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 44bc79952b8b..67ea009f242c 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -1,10 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # the core
 obj-$(CONFIG_NET_DSA) += dsa_core.o
-dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o
+dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o tag_8021q.o
 
 # tagging formats
-obj-$(CONFIG_NET_DSA_TAG_8021Q) += tag_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
 obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 4aa29f90ecea..0d1db3e37668 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -493,5 +493,3 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
 	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
-
-MODULE_LICENSE("GPL v2");
-- 
2.30.2



