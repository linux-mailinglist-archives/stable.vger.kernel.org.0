Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A6C35BEBB
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbhDLJBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238219AbhDLI5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD93C61285;
        Mon, 12 Apr 2021 08:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217802;
        bh=m56k5u6+RkxYZi05OLvW+cqFJy6o/KsMmAfZLWadI3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1tPUSprJ7izBnt7y0nK6chyBnwLMBpKf6nhC23GQd9B2AT0DsG3BquD9uRqMyu9f
         G6dmpjCj/I1UKrwlDPVYIEfhIKOG+Y0F5kiFKAaXuI+UH264+vRvoRRb/+o0XgU/pv
         AMyzyCT4NMLP/ImAc6JAMuK74ZBrboolnPIWKi84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/188] net: openvswitch: conntrack: simplify the return expression of ovs_ct_limit_get_default_limit()
Date:   Mon, 12 Apr 2021 10:41:05 +0200
Message-Id: <20210412084018.638936442@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index 4beb96139d77..96a49aa3a128 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2025,15 +2025,11 @@ static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
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



