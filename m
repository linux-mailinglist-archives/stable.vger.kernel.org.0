Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FC441264A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387232AbhITS4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383438AbhITSsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685E96337A;
        Mon, 20 Sep 2021 17:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159252;
        bh=wxfST2Fog1zgK7JmnzSoNEyc7dj48I3zfUBseGYCqaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJIqLvf3F4+dbwzivJ/Iwp8uqQwqdIvF93YcmI3i//2FsJjwsmpZ3uFdsxgsqLW1P
         GX7Nxr/Hl5NDjbT+WU6S5MjP+EkvrIh2QdA5AlOAYMcMEu8U5/GTZJQoPy+Ku3HWLV
         T7mqpkkWZIKRZmgMMF8mI4HuDUGzeUmife1wgmCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 147/168] net: dsa: tag_rtl4_a: Fix egress tags
Date:   Mon, 20 Sep 2021 18:44:45 +0200
Message-Id: <20210920163926.489089758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 0e90dfa7a8d817db755c7b5d89d77b9c485e4180 ]

I noticed that only port 0 worked on the RTL8366RB since we
started to use custom tags.

It turns out that the format of egress custom tags is actually
different from ingress custom tags. While the lower bits just
contain the port number in ingress tags, egress tags need to
indicate destination port by setting the bit for the
corresponding port.

It was working on port 0 because port 0 added 0x00 as port
number in the lower bits, and if you do this the packet appears
at all ports, including the intended port. Ooops.

Fix this and all ports work again. Use the define for shifting
the "type A" into place while we're at it.

Tested on the D-Link DIR-685 by sending traffic to each of
the ports in turn. It works.

Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_rtl4_a.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 57c46b4ab2b3..e34b80fa52e1 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -54,9 +54,10 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	p = (__be16 *)tag;
 	*p = htons(RTL4_A_ETHERTYPE);
 
-	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
-	/* The lower bits is the port number */
-	out |= (u8)dp->index;
+	out = (RTL4_A_PROTOCOL_RTL8366RB << RTL4_A_PROTOCOL_SHIFT) | (2 << 8);
+	/* The lower bits indicate the port number */
+	out |= BIT(dp->index);
+
 	p = (__be16 *)(tag + 2);
 	*p = htons(out);
 
-- 
2.30.2



