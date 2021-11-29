Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010DB461EEC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379728AbhK2Sly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:41:54 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55118 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379761AbhK2Sjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:39:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1EECCE12FD;
        Mon, 29 Nov 2021 18:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D841C56747;
        Mon, 29 Nov 2021 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210991;
        bh=8RTYIUjH0PNBcrk5s0EjYuDQBABRdZwd0ciLyfyYJ7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKdQzRfmXyEv+ALYxHk76wuXV+Fj/JXHXVHEl3k6vywoRkyMcRalcjei3+x1d52Yu
         KgiP0wiTtRXRdbO3SIFbUTLCN+kiqg5rIwpNVPnvZMqn69lXY6uvjMPTfJiGs0xlkx
         CRzdUCr1Ps3l/L30DfP1deo22sqYrVih6lUetHLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/179] netfilter: ctnetlink: do not erase error code with EINVAL
Date:   Mon, 29 Nov 2021 19:17:40 +0100
Message-Id: <20211129181721.125442835@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

[ Upstream commit 77522ff02f333434612bd72df9b376f8d3836e4d ]

And be consistent in error management for both orig/reply filtering

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2663764d0b6ee..c7708bde057cb 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1012,10 +1012,8 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 						   filter->family,
 						   &filter->zone,
 						   filter->reply_flags);
-		if (err < 0) {
-			err = -EINVAL;
+		if (err < 0)
 			goto err_filter;
-		}
 	}
 
 	return filter;
-- 
2.33.0



