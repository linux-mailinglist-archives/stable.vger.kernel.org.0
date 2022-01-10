Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BF74890FC
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbiAJH2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:28:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56806 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbiAJH0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:26:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF903B81215;
        Mon, 10 Jan 2022 07:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E65C36AE9;
        Mon, 10 Jan 2022 07:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799568;
        bh=BotyTAlYBjydCinMhmpoBUzlSmL9tfPoNk3DnutdsdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eikY/NFxXCsQcLrN9JIvO8b9Wc8MqNq2e91hC4zTWFmhVa7Duo4RVxgRi11IFqBZI
         9r4F2lKoqcnPYTqf7orRtsLs28zKFFNnKWE7Bmf1cmHAOByQydX6Fhykz2RkQZ+OPr
         EsiibfBPlyP+TvyinZb+dwuYBWOa+eqt0X+QwAYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/22] ipv6: Continue processing multipath route even if gateway attribute is invalid
Date:   Mon, 10 Jan 2022 08:23:10 +0100
Message-Id: <20220110071814.835570848@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071814.261471354@linuxfoundation.org>
References: <20220110071814.261471354@linuxfoundation.org>
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
index 9ae48a20c3207..008ebda35ed22 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3367,8 +3367,10 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
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
@@ -3377,6 +3379,7 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 		if (err)
 			last_err = err;
 
+next_rtnh:
 		rtnh = rtnh_next(rtnh, &remaining);
 	}
 
-- 
2.34.1



