Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2601383002
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239005AbhEQOWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239008AbhEQOVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 780E96145A;
        Mon, 17 May 2021 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260690;
        bh=deHbqRUUgZPz+UsnjEDUFUzpigvktFyFPnMrbOKAWJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/zWR2uC8hzYVltH18OljJjuA7EIyEPsrTRGreiyfXLju58Otvl3nB8dXorqs333b
         R4JlZ/4tOSy3bXgda/0hfDwv6KZGNJzSvZLKBJlJH7Hmrn69BASKbp2hRgu6YD+ogU
         YB15jPHv4P+cFFAPVj+6r57jJhpu+QvGFjbIba+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Chen <chenhao288@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 196/363] net: hns3: fix for vxlan gpe tx checksum bug
Date:   Mon, 17 May 2021 16:01:02 +0200
Message-Id: <20210517140309.207389447@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit 905416f18fe74bdd4de91bf94ef5a790a36e4b99 ]

When skb->ip_summed is CHECKSUM_PARTIAL, for non-tunnel udp packet,
which has a dest port as the IANA assigned, the hardware is expected
to do the checksum offload, but the hardware whose version is below
V3 will not do the checksum offload when udp dest port is 4790.

So fixes it by doing the checksum in software for this case.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 59d4d1e87f65..d24bafb7ce46 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -823,7 +823,7 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
  * and it is udp packet, which has a dest port as the IANA assigned.
  * the hardware is expected to do the checksum offload, but the
  * hardware will not do the checksum offload when udp dest port is
- * 4789 or 6081.
+ * 4789, 4790 or 6081.
  */
 static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 {
@@ -841,7 +841,8 @@ static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 
 	if (!(!skb->encapsulation &&
 	      (l4.udp->dest == htons(IANA_VXLAN_UDP_PORT) ||
-	      l4.udp->dest == htons(GENEVE_UDP_PORT))))
+	      l4.udp->dest == htons(GENEVE_UDP_PORT) ||
+	      l4.udp->dest == htons(4790))))
 		return false;
 
 	skb_checksum_help(skb);
-- 
2.30.2



