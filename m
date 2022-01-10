Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B1048914E
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiAJHax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:30:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58326 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239720AbiAJH2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:28:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EA22B811E3;
        Mon, 10 Jan 2022 07:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0B7C36AE9;
        Mon, 10 Jan 2022 07:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799726;
        bh=D7vs6k8iFGyAvByHR8PckHt7Y5wDwH3cOCh2tIDChCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZiAND1SKZSequMeqBHfPzTuH22tMKHlPda0ZK4kR3y+rCHlfqTDHCUiXiFvGvKYk2
         S/KCXXI5Tsq1NaKKBb3QuRRa9tIRRb7amT4iP3K6zW+ckf3WZzBhWyos+A1d4Raqru
         N3TnStG74Ug9iwL96AW4PpsSzQB776xEoSLkPAfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/34] ipv6: Do cleanup if attribute validation fails in multipath route
Date:   Mon, 10 Jan 2022 08:23:23 +0100
Message-Id: <20220110071816.617673606@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
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
index 56f0783df5896..5ef6e27e026e9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5146,12 +5146,10 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 
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



