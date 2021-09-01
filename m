Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96D03FDA25
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244410AbhIAMak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244418AbhIAMaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:30:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C0B96101B;
        Wed,  1 Sep 2021 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499343;
        bh=zlhCOirBHcRPc+FT1T3bsIBUJ0ZW4Zrh3JIDaDaiV+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twPk/0H55lF6QrUnYU+1cFX6juqn9gg9shNpl4Xobf+JlUupfxGYd8sZf/kWca8qy
         mVDigkFb031PB8QS97Whl66VFVQkeIEE3t5o9hnPIs1I/czX8bE2ZkD/QU3Iyugfem
         9867vIVLQ+C6twFCSBUwu3zNIXgVqlD1bK/X/RUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/23] ip_gre: add validation for csum_start
Date:   Wed,  1 Sep 2021 14:26:54 +0200
Message-Id: <20210901122250.086546902@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
References: <20210901122249.786673285@linuxfoundation.org>
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
index 9940a59306b5..1a4d89f8361c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -443,6 +443,8 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
-- 
2.30.2



