Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4104469F1F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391421AbhLFPpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390549AbhLFPmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A35C0698D7;
        Mon,  6 Dec 2021 07:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F4091B8111C;
        Mon,  6 Dec 2021 15:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4290CC34900;
        Mon,  6 Dec 2021 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804503;
        bh=EixqWfw/xv1siXi7kj5OHxa7sRjTqKUbRtjbhNJnhtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqqQ2lVrCp96K3JeF53uC9fgzQSmGUW0x5/1cSt0DIh5hkUEPonklkgg4Pvr162nY
         CBWRqUv87eKuKuTuS/jNTImBmiXBQp1vVNC50qT4OQZY5SDLTYAY9//L33vqkiTKYn
         rc3sNrIoATCQVMeW8Cr2bqjy+S948Z4/UitfwZsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/207] mctp: Dont let RTM_DELROUTE delete local routes
Date:   Mon,  6 Dec 2021 15:57:03 +0100
Message-Id: <20211206145616.122165208@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 76d001603c509562181f3787a7065b8e163bc7b9 ]

We need to test against the existing route type, not
the rtm_type in the netlink request.

Fixes: 83f0a0b7285b ("mctp: Specify route types, require rtm_type in RTM_*ROUTE messages")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 5ca186d53cb0f..fb1bf4ec85296 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -760,7 +760,7 @@ static int mctp_route_add(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 }
 
 static int mctp_route_remove(struct mctp_dev *mdev, mctp_eid_t daddr_start,
-			     unsigned int daddr_extent)
+			     unsigned int daddr_extent, unsigned char type)
 {
 	struct net *net = dev_net(mdev->dev);
 	struct mctp_route *rt, *tmp;
@@ -777,7 +777,8 @@ static int mctp_route_remove(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 
 	list_for_each_entry_safe(rt, tmp, &net->mctp.routes, list) {
 		if (rt->dev == mdev &&
-		    rt->min == daddr_start && rt->max == daddr_end) {
+		    rt->min == daddr_start && rt->max == daddr_end &&
+		    rt->type == type) {
 			list_del_rcu(&rt->list);
 			/* TODO: immediate RTM_DELROUTE */
 			mctp_route_release(rt);
@@ -795,7 +796,7 @@ int mctp_route_add_local(struct mctp_dev *mdev, mctp_eid_t addr)
 
 int mctp_route_remove_local(struct mctp_dev *mdev, mctp_eid_t addr)
 {
-	return mctp_route_remove(mdev, addr, 0);
+	return mctp_route_remove(mdev, addr, 0, RTN_LOCAL);
 }
 
 /* removes all entries for a given device */
@@ -975,7 +976,7 @@ static int mctp_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (rtm->rtm_type != RTN_UNICAST)
 		return -EINVAL;
 
-	rc = mctp_route_remove(mdev, daddr_start, rtm->rtm_dst_len);
+	rc = mctp_route_remove(mdev, daddr_start, rtm->rtm_dst_len, RTN_UNICAST);
 	return rc;
 }
 
-- 
2.33.0



