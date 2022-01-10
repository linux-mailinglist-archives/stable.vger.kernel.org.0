Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD90248925D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbiAJHmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241087AbiAJHjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:39:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DFBC061763;
        Sun,  9 Jan 2022 23:33:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1960F60B62;
        Mon, 10 Jan 2022 07:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015DEC36AE9;
        Mon, 10 Jan 2022 07:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800020;
        bh=dZLDfgXpMHsQktAQ1CcOfPtuyA+EHT7IeIuECDDH3lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qML+ZvnHcc7qPZnvYeq1MCTLUkacUb7kTOCpCThDW5cB3b72nWp9GWMveK52oXkSq
         odFcVEHsKG7c4EF7KTzp9q9g8mb+1niyIHJTNoHPzbZM6So1kNjF0d4tYIXghIyE6K
         Pnw5Al5DtwechVU/D5ozl8W5wlK3gy7m0dLtxW9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 52/72] ipv6: Do cleanup if attribute validation fails in multipath route
Date:   Mon, 10 Jan 2022 08:23:29 +0100
Message-Id: <20220110071823.305562333@linuxfoundation.org>
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

[ Upstream commit 95bdba23b5b4aa75fe3e6c84335e638641c707bb ]

As Nicolas noted, if gateway validation fails walking the multipath
attribute the code should jump to the cleanup to free previously
allocated memory.

Fixes: 1ff15a710a86 ("ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route")
Signed-off-by: David Ahern <dsahern@kernel.org>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20220103170555.94638-1-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0eceb0e88976b..0632382a5427b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5277,12 +5277,10 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				int ret;
-
-				ret = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
 							extack);
-				if (ret)
-					return ret;
+				if (err)
+					goto cleanup;
 
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
-- 
2.34.1



