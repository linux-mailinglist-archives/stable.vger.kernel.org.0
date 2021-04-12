Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF1535BD7F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbhDLIv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238485AbhDLIt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79EAA6127A;
        Mon, 12 Apr 2021 08:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217355;
        bh=ydBzpuGoeZ2kJN+fhVJl1Az0edvI9ghNf3U5TAmUP8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bK2qLjO2myQmlHAnXhsWHZuA6wCPELvcZaaV5TjxGf2O74ULESzECdRewbXienB2v
         WzLHJlNC0apIeKf9K3GAPfyjCQJ4rae24iZep/n037OeFgomesEA+e27aMdp3N8UGH
         EDahjUgMgych73eKKvJbbeVnWPecwIbk34T4hytk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/111] openvswitch: fix send of uninitialized stack memory in ct limit reply
Date:   Mon, 12 Apr 2021 10:41:06 +0200
Message-Id: <20210412084007.180919758@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 4d51419d49930be2701c2633ae271b350397c3ca ]

'struct ovs_zone_limit' has more members than initialized in
ovs_ct_limit_get_default_limit().  The rest of the memory is a random
kernel stack content that ends up being sent to userspace.

Fix that by using designated initializer that will clear all
non-specified fields.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e905248b11c2..b6f98eba71f1 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2019,10 +2019,10 @@ static int ovs_ct_limit_del_zone_limit(struct nlattr *nla_zone_limit,
 static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
 					  struct sk_buff *reply)
 {
-	struct ovs_zone_limit zone_limit;
-
-	zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
-	zone_limit.limit = info->default_limit;
+	struct ovs_zone_limit zone_limit = {
+		.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE,
+		.limit   = info->default_limit,
+	};
 
 	return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
 }
-- 
2.30.2



