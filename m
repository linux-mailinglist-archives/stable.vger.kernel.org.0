Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098CE3ED671
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbhHPNVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239176AbhHPNSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BE6060E78;
        Mon, 16 Aug 2021 13:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119660;
        bh=aU+dILaSwvr5fSKvXLVDDKlEXH+Api1e54oEa5Vxlw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbWYjUJ1QZSx2wh5rSLVZEzyYUlsCKuVBG+zok6W1+ELqkCuxX4kWMGQKF5pCb04B
         4cGN20BCVOmXORaNQuXsLMOVrPKTuVRpUgbExKohsrGiIYpY1WhwGEEPZh7GzUWwDY
         G89lRxQjt3RV9/Ld92EFZNz9rV+Gs1qGhOx3ID/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 095/151] net: dsa: microchip: ksz8795: Use software untagging on CPU port
Date:   Mon, 16 Aug 2021 15:02:05 +0200
Message-Id: <20210816125447.206487181@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@mind.be>

[ Upstream commit 9130c2d30c17846287b803a9803106318cbe5266 ]

On the CPU port, we can support both tagged and untagged VLANs at the
same time by doing any necessary untagging in software rather than
hardware.  To enable that, keep the CPU port's Remove Tag flag cleared
and set the dsa_switch::untag_bridge_pvid flag.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 46ef5bc79cbd..4bd735c5183c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1109,8 +1109,10 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 	/* If a VLAN is added with untagged flag different from the
 	 * port's Remove Tag flag, we need to change the latter.
 	 * Ignore VID 0, which is always untagged.
+	 * Ignore CPU port, which will always be tagged.
 	 */
-	if (untagged != p->remove_tag && vlan->vid != 0) {
+	if (untagged != p->remove_tag && vlan->vid != 0 &&
+	    port != dev->cpu_port) {
 		unsigned int vid;
 
 		/* Reject attempts to add a VLAN that requires the
@@ -1655,6 +1657,11 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt;
 
+	/* We rely on software untagging on the CPU port, so that we
+	 * can support both tagged and untagged VLANs
+	 */
+	dev->ds->untag_bridge_pvid = true;
+
 	return 0;
 }
 
-- 
2.30.2



