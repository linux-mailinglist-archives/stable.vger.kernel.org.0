Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBC935BD9C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhDLIwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238732AbhDLIuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4DDC61220;
        Mon, 12 Apr 2021 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217419;
        bh=o5i3hKzknm+DUIjdw9i7lfB2r8/qKgvC5L2eLFR0IwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jkd0ePfEhfnPtZxaFLLIZz/cYYBW7/wQ/mXB0njQe8hW0KJjHwk5exXxcrudD+iA9
         Jahb/fIqcFk5A/gh2NIRN8KohFKWfz/mnNXHnLpSM4CJ1DwwtUcW+VoqaSdwVQtSZT
         o8o+nwCyqm6Y2LP2o4qHln8D0a0hXo9TTEjkUp28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/111] net: openvswitch: conntrack: simplify the return expression of ovs_ct_limit_get_default_limit()
Date:   Mon, 12 Apr 2021 10:41:05 +0200
Message-Id: <20210412084007.150886966@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 5e359044c107ecbdc2e9b3fd5ce296006e6de4bc ]

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index d06d7d58eaf2..e905248b11c2 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2020,15 +2020,11 @@ static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
 					  struct sk_buff *reply)
 {
 	struct ovs_zone_limit zone_limit;
-	int err;
 
 	zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
 	zone_limit.limit = info->default_limit;
-	err = nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
-	if (err)
-		return err;
 
-	return 0;
+	return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
 }
 
 static int __ovs_ct_limit_get_zone_limit(struct net *net,
-- 
2.30.2



