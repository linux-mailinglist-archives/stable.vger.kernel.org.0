Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AAB3ED67F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhHPNVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240612AbhHPNT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEFA663316;
        Mon, 16 Aug 2021 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119704;
        bh=WCWSREiGsdTCRgU1r9ypj7YAPXjgrjO6iWSzadKqA1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJNSKDEX1SRhxaWDc1XRTXyf+D4/+YtFeicrvb1DNujL55k9689nfhR60P6kvmpb9
         ZUj7I3NVYedv38jQviHQ2V4ZY82u56ApTYrRH8ZgqhkkB0MJzoZHXR5vaVT7Drc+hc
         8kYEfO4elkOQxr1wpb8uSyvxOMuGLSOuMhKhbns0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 097/151] net: dsa: microchip: ksz8795: Dont use phy_port_cnt in VLAN table lookup
Date:   Mon, 16 Aug 2021 15:02:07 +0200
Message-Id: <20210816125447.269935960@linuxfoundation.org>
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

[ Upstream commit 411d466d94a6b16a20c8b552e403b7e8ce2397a2 ]

The magic number 4 in VLAN table lookup was the number of entries we
can read and write at once.  Using phy_port_cnt here doesn't make
sense and presumably broke VLAN filtering for 3-port switches.  Change
it back to 4.

Fixes: 4ce2a984abd8 ("net: dsa: microchip: ksz8795: use phy_port_cnt ...")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8e2a8103d590..8eb9a45c98cf 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -684,8 +684,8 @@ static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	shifts = ksz8->shifts;
 
 	ksz8_r_table(dev, TABLE_VLAN, addr, &data);
-	addr *= dev->phy_port_cnt;
-	for (i = 0; i < dev->phy_port_cnt; i++) {
+	addr *= 4;
+	for (i = 0; i < 4; i++) {
 		dev->vlan_cache[addr + i].table[0] = (u16)data;
 		data >>= shifts[VLAN_TABLE];
 	}
@@ -699,7 +699,7 @@ static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
 	u64 buf;
 
 	data = (u16 *)&buf;
-	addr = vid / dev->phy_port_cnt;
+	addr = vid / 4;
 	index = vid & 3;
 	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
 	*vlan = data[index];
@@ -713,7 +713,7 @@ static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 	u64 buf;
 
 	data = (u16 *)&buf;
-	addr = vid / dev->phy_port_cnt;
+	addr = vid / 4;
 	index = vid & 3;
 	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
 	data[index] = vlan;
-- 
2.30.2



