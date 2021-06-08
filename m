Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8193A017D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhFHSwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235228AbhFHSux (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F389A6146D;
        Tue,  8 Jun 2021 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177584;
        bh=KqYhOBpB+gMb1Qp3SR1AofPIlmvlllvO1NK0L5JYB3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2oIB/9ZQN6LSCj/GF+Xv3SErmKwz7FQxaSwlgt6B0qrH/pjxdDnd0bsXONTgEFUS
         sX/wnWAB6JufurBZznA8o54iGzXo5HGk58TX7GWDxSVkNjUZzM13G4lYPeDPFlbEGX
         P9Cvazjl+zFBw+79Pmh0Ex/OE/FM+6Y+oVRodSf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/137] net: dsa: tag_8021q: fix the VLAN IDs used for encoding sub-VLANs
Date:   Tue,  8 Jun 2021 20:26:05 +0200
Message-Id: <20210608175943.267366973@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4ef8d857b5f494e62bce9085031563fda35f9563 ]

When using sub-VLANs in the range of 1-7, the resulting value from:

	rx_vid = dsa_8021q_rx_vid_subvlan(ds, port, subvlan);

is wrong according to the description from tag_8021q.c:

 | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
 +-----------+-----+-----------------+-----------+-----------------------+
 |    DIR    | SVL |    SWITCH_ID    |  SUBVLAN  |          PORT         |
 +-----------+-----+-----------------+-----------+-----------------------+

For example, when ds->index == 0, port == 3 and subvlan == 1,
dsa_8021q_rx_vid_subvlan() returns 1027, same as it returns for
subvlan == 0, but it should have returned 1043.

This is because the low portion of the subvlan bits are not masked
properly when writing into the 12-bit VLAN value. They are masked into
bits 4:3, but they should be masked into bits 5:4.

Fixes: 3eaae1d05f2b ("net: dsa: tag_8021q: support up to 8 VLANs per port using sub-VLANs")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8e3e8a5b8559..a00b513c22a1 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -64,7 +64,7 @@
 #define DSA_8021Q_SUBVLAN_HI_SHIFT	9
 #define DSA_8021Q_SUBVLAN_HI_MASK	GENMASK(9, 9)
 #define DSA_8021Q_SUBVLAN_LO_SHIFT	4
-#define DSA_8021Q_SUBVLAN_LO_MASK	GENMASK(4, 3)
+#define DSA_8021Q_SUBVLAN_LO_MASK	GENMASK(5, 4)
 #define DSA_8021Q_SUBVLAN_HI(x)		(((x) & GENMASK(2, 2)) >> 2)
 #define DSA_8021Q_SUBVLAN_LO(x)		((x) & GENMASK(1, 0))
 #define DSA_8021Q_SUBVLAN(x)		\
-- 
2.30.2



