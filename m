Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26283FDB33
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343994AbhIAMi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344163AbhIAMhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 879FB61131;
        Wed,  1 Sep 2021 12:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499650;
        bh=GUKhH7urC3fWP/dJb2D4FsZqyIFxSwiQuVhO0ShoeFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rb3cKMPmShq5DpquZd+Kzn9lCGZvUO6SqGQ49z2lKIEsi55nhIHT0LarYMgEpX512
         6Yb6NhQnDDv+GYWAORaDmu/81fQTMVNkwN/V7nN4mYWQqSmhowtjn6GIW0OF1yU+HY
         JTUl59JuSAGmeQOP0KtbmWTmzCRlSqRaoAWlLUMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/103] ip_gre: add validation for csum_start
Date:   Wed,  1 Sep 2021 14:27:43 +0200
Message-Id: <20210901122301.663406152@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
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
index e70291748889..a0829495b211 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -468,6 +468,8 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
-- 
2.30.2



