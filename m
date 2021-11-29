Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0811C461F19
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354690AbhK2Snw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:43:52 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55800 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhK2SlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:41:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90508CE1407;
        Mon, 29 Nov 2021 18:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FCFC53FCD;
        Mon, 29 Nov 2021 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211079;
        bh=ZF3r0r2UruYi/mCGp9N0oOtVMQwckisIQTu75MBOy2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Alkwk2px2eYlpQNw1Lgp9LNjUddwnrgs9tAagHuHWGDjnq1nyQQUWeKKjXDlRoEAp
         9Jd2SusfPdxUWA9WqYf7HW42G/7FHYUqbroUpG4+hrOWdXYcA//k4qIXcbDajj2+xA
         4yMZ3+ta/9ZYgJQKBN4RsUO1EXMkLNq9p3UCtQqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/179] netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY
Date:   Mon, 29 Nov 2021 19:17:39 +0100
Message-Id: <20211129181721.095726442@linuxfoundation.org>
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

[ Upstream commit ad81d4daf6a3f4769a346e635d5e1e967ca455d9 ]

filter->orig_flags was used for a reply context.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f1e5443fe7c74..2663764d0b6ee 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1011,7 +1011,7 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 						   CTA_TUPLE_REPLY,
 						   filter->family,
 						   &filter->zone,
-						   filter->orig_flags);
+						   filter->reply_flags);
 		if (err < 0) {
 			err = -EINVAL;
 			goto err_filter;
-- 
2.33.0



