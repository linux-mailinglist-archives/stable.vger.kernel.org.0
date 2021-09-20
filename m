Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516A54124CC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381475AbhITSiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379307AbhITSgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D811F61ABD;
        Mon, 20 Sep 2021 17:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158946;
        bh=bJW8nCMqEq7PQUJwPZa0hP+gqBaIsHjbiGqYKiTIwlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeufLGqBxr9yNEdC9yaH7TkQAy+WO9PvK8v7EzwDyHXK1LCAkJBxHBbikQj3423Bn
         B9qVZAa8l45HApB/QTBPbhH4RGZAgF2J++CJsVCM2CqfNNJr8M90ErnC40+nLEm+/d
         dK5OeypocAeE8ipIi2p0wG9WD2c1YJiq8Y6vXcJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/122] net: dsa: tag_rtl4_a: Fix egress tags
Date:   Mon, 20 Sep 2021 18:44:34 +0200
Message-Id: <20210920163919.140386125@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
index e9176475bac8..24375ebd684e 100644
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



