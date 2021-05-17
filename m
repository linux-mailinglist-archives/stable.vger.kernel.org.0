Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD8238304C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbhEQO0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239444AbhEQOYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:24:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0236613CD;
        Mon, 17 May 2021 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260752;
        bh=sVWSqwsCjEediVEth53I4tx8AYE5sxNh7/5+UMoiWTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ec2bmWBe3SwL1wMQ5vHxXMHdqQyGIAdMIXe8dIZHtfcx7swLva3JaA6H48BcgJUjI
         T0SWF6SFg1QFCvZahIcQtkdmX7ECqjyi4ygIPBLuJclLb9ra5J11sr33MpGFZPz6cY
         UOpuwqBbR3787A+9+/FKKoGFlUGRu4AUBQsCvxCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 225/363] ethtool: fix missing NLM_F_MULTI flag when dumping
Date:   Mon, 17 May 2021 16:01:31 +0200
Message-Id: <20210517140310.198118260@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit cf754ae331be7cc192b951756a1dd031e9ed978a ]

When dumping the ethtool information from all the interfaces, the
netlink reply should contain the NLM_F_MULTI flag. This flag allows
userspace tools to identify that multiple messages are expected.

Link: https://bugzilla.redhat.com/1953847
Fixes: 365f9ae4ee36 ("ethtool: fix genlmsg_put() failure handling in ethnl_default_dumpit()")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 50d3c8896f91..25a55086d2b6 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -384,7 +384,8 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 	int ret;
 
 	ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-			   &ethtool_genl_family, 0, ctx->ops->reply_cmd);
+			   &ethtool_genl_family, NLM_F_MULTI,
+			   ctx->ops->reply_cmd);
 	if (!ehdr)
 		return -EMSGSIZE;
 
-- 
2.30.2



