Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDA41BCBA3
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgD1S6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbgD1S24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D122A208E0;
        Tue, 28 Apr 2020 18:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098536;
        bh=XOTjo0i8DbOr9GRbY+k+F3BY0aAQvmrwYJwPgt2C8sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEqDqycZgQVaecB0aSovhlcVGmgvF63Y8Z/gi44vYd5VqRw6AOUmVKqr7UOVx5DeV
         8WrunfsN0voXWsiCtGQyG2M5l3sUM0gbMTkVewv2NCTaXKYzUE2iiODvW13tUHUUEv
         FQby30vaFEQyRDbHoK2QzQYVsAYmG4RX8LQGgzFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 068/167] net: dsa: b53: Rework ARL bin logic
Date:   Tue, 28 Apr 2020 20:24:04 +0200
Message-Id: <20200428182233.572934793@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 6344dbde6a27d10d16246d734b968f84887841e2 ]

When asking the ARL to read a MAC address, we will get a number of bins
returned in a single read. Out of those bins, there can essentially be 3
states:

- all bins are full, we have no space left, and we can either replace an
  existing address or return that full condition

- the MAC address was found, then we need to return its bin index and
  modify that one, and only that one

- the MAC address was not found and we have a least one bin free, we use
  that bin index location then

The code would unfortunately fail on all counts.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |   30 ++++++++++++++++++++++++++----
 drivers/net/dsa/b53/b53_regs.h   |    3 +++
 2 files changed, 29 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1463,6 +1463,7 @@ static int b53_arl_read(struct b53_devic
 			u16 vid, struct b53_arl_entry *ent, u8 *idx,
 			bool is_valid)
 {
+	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
 	unsigned int i;
 	int ret;
 
@@ -1470,6 +1471,8 @@ static int b53_arl_read(struct b53_devic
 	if (ret)
 		return ret;
 
+	bitmap_zero(free_bins, dev->num_arl_entries);
+
 	/* Read the bins */
 	for (i = 0; i < dev->num_arl_entries; i++) {
 		u64 mac_vid;
@@ -1481,16 +1484,24 @@ static int b53_arl_read(struct b53_devic
 			   B53_ARLTBL_DATA_ENTRY(i), &fwd_entry);
 		b53_arl_to_entry(ent, mac_vid, fwd_entry);
 
-		if (!(fwd_entry & ARLTBL_VALID))
+		if (!(fwd_entry & ARLTBL_VALID)) {
+			set_bit(i, free_bins);
 			continue;
+		}
 		if ((mac_vid & ARLTBL_MAC_MASK) != mac)
 			continue;
 		if (dev->vlan_enabled &&
 		    ((mac_vid >> ARLTBL_VID_S) & ARLTBL_VID_MASK) != vid)
 			continue;
 		*idx = i;
+		return 0;
 	}
 
+	if (bitmap_weight(free_bins, dev->num_arl_entries) == 0)
+		return -ENOSPC;
+
+	*idx = find_first_bit(free_bins, dev->num_arl_entries);
+
 	return -ENOENT;
 }
 
@@ -1520,10 +1531,21 @@ static int b53_arl_op(struct b53_device
 	if (op)
 		return ret;
 
-	/* We could not find a matching MAC, so reset to a new entry */
-	if (ret) {
+	switch (ret) {
+	case -ENOSPC:
+		dev_dbg(dev->dev, "{%pM,%.4d} no space left in ARL\n",
+			addr, vid);
+		return is_valid ? ret : 0;
+	case -ENOENT:
+		/* We could not find a matching MAC, so reset to a new entry */
+		dev_dbg(dev->dev, "{%pM,%.4d} not found, using idx: %d\n",
+			addr, vid, idx);
 		fwd_entry = 0;
-		idx = 1;
+		break;
+	default:
+		dev_dbg(dev->dev, "{%pM,%.4d} found, using idx: %d\n",
+			addr, vid, idx);
+		break;
 	}
 
 	/* For multicast address, the port is a bitmask and the validity
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -323,6 +323,9 @@
 #define   ARLTBL_STATIC			BIT(15)
 #define   ARLTBL_VALID			BIT(16)
 
+/* Maximum number of bin entries in the ARL for all switches */
+#define B53_ARLTBL_MAX_BIN_ENTRIES	4
+
 /* ARL Search Control Register (8 bit) */
 #define B53_ARL_SRCH_CTL		0x50
 #define B53_ARL_SRCH_CTL_25		0x20


