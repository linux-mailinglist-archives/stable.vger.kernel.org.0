Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9394891F5
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240931AbiAJHhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240058AbiAJHaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A23C028BB7;
        Sun,  9 Jan 2022 23:27:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2B63B81205;
        Mon, 10 Jan 2022 07:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B44BC36AE9;
        Mon, 10 Jan 2022 07:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799664;
        bh=ldemisgRMwXP+iN87RvpgDewWLe8tBYlf7SosR+KaLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUXaAhxkUqVUytXfA64Y7N8UU7cTCgrEnmuwenvUu0HL0xe9Gt8Exw1uBkmfMmYZB
         JjcB+BNdqOcfF6BqijQc32E6kfAmz6yZ9ZhZKbHDLwej7lufpBtbEtggjvSnxZiyVf
         OhpcK0FpDrqNt+G0Ukm81T5jvJ549+hWe2dJgapI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/21] ipv6: Continue processing multipath route even if gateway attribute is invalid
Date:   Mon, 10 Jan 2022 08:23:16 +0100
Message-Id: <20220110071814.448271281@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
References: <20220110071813.967414697@linuxfoundation.org>
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
index 1bc81be07ccda..8a437c20eeccd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4608,8 +4608,10 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
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
@@ -4618,6 +4620,7 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 		if (err)
 			last_err = err;
 
+next_rtnh:
 		rtnh = rtnh_next(rtnh, &remaining);
 	}
 
-- 
2.34.1



