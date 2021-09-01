Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4694B3FDAA9
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343570AbhIAMdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245058AbhIAMcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:32:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 787E6610A4;
        Wed,  1 Sep 2021 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499486;
        bh=zeEvUuszwiYqTY6ggz3znMNZIDpSJn+dcgcebvlWcy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPDQNB/kE6E5BReckhXOFfZ1PFRrJ4sm23L3sXmnME9ZpubabzXgkXNuoy7ngSVFe
         8lmzxDRzb0vu13GAc9FK43wPNzAmzZv+ilSedbcL+ii0EWiRdLIIJo996WyTF/bSmh
         dn0kXWsf3gZijd9OtENxb10y+YZfGaM7NeOt8doY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/48] ip_gre: add validation for csum_start
Date:   Wed,  1 Sep 2021 14:28:08 +0200
Message-Id: <20210901122254.001761921@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>

[ Upstream commit 1d011c4803c72f3907eccfc1ec63caefb852fcbf ]

Validate csum_start in gre_handle_offloads before we call _gre_xmit so
that we do not crash later when the csum_start value is used in the
lco_csum function call.

This patch deals with ipv4 code.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index fedad3a3e61b..fd8298b8b1c5 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -446,6 +446,8 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
-- 
2.30.2



