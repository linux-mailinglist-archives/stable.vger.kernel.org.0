Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714353A02AC
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbhFHTHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237745AbhFHTFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D02756191C;
        Tue,  8 Jun 2021 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177975;
        bh=NFA6GGpQmVNpgmfw4++B6ztSPKh4O+tlAWGEX2iWNpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tJ78nzZ9eLXwvAvbO2x48eC1lYhG+vsmby8usNifD6wayclLcZ2I+NyZuR2XZ50B
         LyzjtF/ZF+COiQGQUHa0OhdIGYqnRabK/zDhSBKN8tgZdslDi5cigm8YTNZh8I71hM
         ZrUedrg1qbfhVMWH5XPPZ6cQCfZv9vUr4KmXRkZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 030/161] net: dsa: tag_8021q: fix the VLAN IDs used for encoding sub-VLANs
Date:   Tue,  8 Jun 2021 20:26:00 +0200
Message-Id: <20210608175946.466247710@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
index 008c1ec6e20c..122ad5833fb1 100644
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



