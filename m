Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4402738A0FD
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhETJ1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231435AbhETJ0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056F861355;
        Thu, 20 May 2021 09:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502733;
        bh=0CI2ZwNSZ4KkGK4JR7dWcrMIe/AmclU8g10YbHCsFBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds6pKKJVf3OQTRQ3IYPA+vT8SCmN7nXclT0Ow4i2GSiOw52GVn3e6iaFC1LPEmM6y
         yeV5kYhLWzxmF42craIC8Nz1q8mN0JrPCH315FcCGoxswnEQtex4JKOOrwBcCccXhW
         yywd/AiRS1YkEYPjyPrwc/RIFXZUPvfiuxf8sna0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e267bed19bfc5478fb33@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 33/45] net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info
Date:   Thu, 20 May 2021 11:22:21 +0200
Message-Id: <20210520092054.596219345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 2e9f60932a2c19e8a11b4a69d419f107024b05a0 ]

Check at start of fill_frame_info that the MAC header in the supplied
skb is large enough to fit a struct hsr_ethhdr, as otherwise this is
not a valid HSR frame. If it is too small, return an error which will
then cause the callers to clean up the skb. Fixes a KMSAN-found
uninit-value bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=f7e9b601f1414f814f7602a82b6619a8d80bce3f

Reported-by: syzbot+e267bed19bfc5478fb33@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index b218e4594009..6852e9bccf5b 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -520,6 +520,10 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 	struct ethhdr *ethhdr;
 	__be16 proto;
 
+	/* Check if skb contains hsr_ethhdr */
+	if (skb->mac_len < sizeof(struct hsr_ethhdr))
+		return -EINVAL;
+
 	memset(frame, 0, sizeof(*frame));
 	frame->is_supervision = is_supervision_frame(port->hsr, skb);
 	frame->node_src = hsr_get_node(port, &hsr->node_db, skb,
-- 
2.30.2



