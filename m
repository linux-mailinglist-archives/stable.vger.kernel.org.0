Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F09489258
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbiAJHmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241348AbiAJHio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:38:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0768C0251BB;
        Sun,  9 Jan 2022 23:33:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B6C761195;
        Mon, 10 Jan 2022 07:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE3BC36AE9;
        Mon, 10 Jan 2022 07:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800017;
        bh=pIy1WMLRL1/hblQa3DF157uiTR8ua4oiky7YY8yMuC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQQiIc+iuNJGNHkrohUfPRhQ98jqCzVEVbmtw6IG39Z+/1wtvH252DLB+mCBEvFy9
         suzfNT/ykQ494henNkiUSOG0/vIVGd5BprjwAMSTV5SB/HPqhWV4mIBZsijKikUsGX
         nUl6NR+/RnKLQQmb8su2SnzE4Zf+Nr0uB8gTvo5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/72] ipv6: Continue processing multipath route even if gateway attribute is invalid
Date:   Mon, 10 Jan 2022 08:23:28 +0100
Message-Id: <20220110071823.273440090@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit e30a845b0376eb51c9c94f56bbd53b2e08ba822f ]

ip6_route_multipath_del loop continues processing the multipath
attribute even if delete of a nexthop path fails. For consistency,
do the same if the gateway attribute is invalid.

Fixes: 1ff15a710a86 ("ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route")
Signed-off-by: David Ahern <dsahern@kernel.org>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20220103171911.94739-1-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d050e0f5baa46..0eceb0e88976b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5459,8 +5459,10 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 			if (nla) {
 				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
 							extack);
-				if (err)
-					return err;
+				if (err) {
+					last_err = err;
+					goto next_rtnh;
+				}
 
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
@@ -5469,6 +5471,7 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 		if (err)
 			last_err = err;
 
+next_rtnh:
 		rtnh = rtnh_next(rtnh, &remaining);
 	}
 
-- 
2.34.1



