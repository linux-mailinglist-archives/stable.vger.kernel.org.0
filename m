Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D37B46258F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhK2WlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbhK2WkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:40:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F674C043CC7;
        Mon, 29 Nov 2021 10:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECA93B815B1;
        Mon, 29 Nov 2021 18:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E427C53FCD;
        Mon, 29 Nov 2021 18:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210577;
        bh=jgeilegboZbZGZiJPAXtw2VMPtxtLuDp4kMhKHauHxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeccp+03XyQtaKraxKqWk+iWBKRVq0Ar5nfgtmtmvOBNZCjs7F+wDjY9WLIqHBlkJ
         Lgh6E7f26Xg2a4jMVyRPqxpipKUEIYU7otpxXunpAvN2x7zcc5PDicWi87zKyJaR7c
         gi6N9ost/S14kSIjMc55RT9jJBOBRQE2kJ2cid90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/121] netfilter: ctnetlink: do not erase error code with EINVAL
Date:   Mon, 29 Nov 2021 19:17:53 +0100
Message-Id: <20211129181713.064887872@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 39e0ff41688a7..60a1a666e797a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -974,10 +974,8 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
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



