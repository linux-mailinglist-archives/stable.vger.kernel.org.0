Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6FD12F0E6
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgABWST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgABWSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60E3221582;
        Thu,  2 Jan 2020 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003497;
        bh=GbbVOGT3ssLiWOJrq9q3+/pq8O/Q6xx45RyYpvxGwGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PymgbRLdSLJvobd3cjZAVd9HX+Pyxwnn3r31+QiT5zETNEXDzJTa2vLx/fNwGWPk2
         hoJjYHP0OeJPehkSCaeBb4tAlWVVY8fzeGCkkSvAh+9migX7rpd14e5/5+CfCNuI96
         LloP5CKXBbmLVFC3aGdTa0vu/QFdF4Tn7jxB3G3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 186/191] ipv6/addrconf: only check invalid header values when NETLINK_F_STRICT_CHK is set
Date:   Thu,  2 Jan 2020 23:07:48 +0100
Message-Id: <20200102215849.500783837@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 2beb6d2901a3f73106485d560c49981144aeacb1 ]

In commit 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for
doit handlers") we add strict check for inet6_rtm_getaddr(). But we did
the invalid header values check before checking if NETLINK_F_STRICT_CHK
is set. This may break backwards compatibility if user already set the
ifm->ifa_prefixlen, ifm->ifa_flags, ifm->ifa_scope in their netlink code.

I didn't move the nlmsg_len check because I thought it's a valid check.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for doit handlers")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5231,16 +5231,16 @@ static int inet6_rtm_valid_getaddr_req(s
 		return -EINVAL;
 	}
 
+	if (!netlink_strict_get_check(skb))
+		return nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+					      ifa_ipv6_policy, extack);
+
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifa_prefixlen || ifm->ifa_flags || ifm->ifa_scope) {
 		NL_SET_ERR_MSG_MOD(extack, "Invalid values in header for get address request");
 		return -EINVAL;
 	}
 
-	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
-					      ifa_ipv6_policy, extack);
-
 	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
 					    ifa_ipv6_policy, extack);
 	if (err)


