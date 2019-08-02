Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C57A7F292
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390228AbfHBJtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392041AbfHBJq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8418A2086A;
        Fri,  2 Aug 2019 09:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739188;
        bh=F9f8+XQ9K6uxWrdp5WlnfE4VLwtyVaBH0OGVXCRB8DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euEVrLxa2ASBB9HiZqfQdyNoihKpJ9cim9f5AWpJW8WMGerKTBTdMJ5e7fbRp0wCp
         goRJ75Oq6knWC/Q3Lg8oMtv4ijTTERzoBsVHpuOTOQR0Xi7GmbfiS7nzXaLhSfB2RQ
         SNLVh3eeakOdBXhbsOY5DCjob9ODECPL/oiQYjNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 133/223] ipv4: dont set IPv6 only flags to IPv4 addresses
Date:   Fri,  2 Aug 2019 11:35:58 +0200
Message-Id: <20190802092247.529407536@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

[ Upstream commit 2e60546368165c2449564d71f6005dda9205b5fb ]

Avoid the situation where an IPV6 only flag is applied to an IPv4 address:

    # ip addr add 192.0.2.1/24 dev dummy0 nodad home mngtmpaddr noprefixroute
    # ip -4 addr show dev dummy0
    2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
        inet 192.0.2.1/24 scope global noprefixroute dummy0
           valid_lft forever preferred_lft forever

Or worse, by sending a malicious netlink command:

    # ip -4 addr show dev dummy0
    2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
        inet 192.0.2.1/24 scope global nodad optimistic dadfailed home tentative mngtmpaddr noprefixroute stable-privacy dummy0
           valid_lft forever preferred_lft forever

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/devinet.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -67,6 +67,11 @@
 
 #include "fib_lookup.h"
 
+#define IPV6ONLY_FLAGS	\
+		(IFA_F_NODAD | IFA_F_OPTIMISTIC | IFA_F_DADFAILED | \
+		 IFA_F_HOMEADDRESS | IFA_F_TENTATIVE | \
+		 IFA_F_MANAGETEMPADDR | IFA_F_STABLE_PRIVACY)
+
 static struct ipv4_devconf ipv4_devconf = {
 	.data = {
 		[IPV4_DEVCONF_ACCEPT_REDIRECTS - 1] = 1,
@@ -453,6 +458,9 @@ static int __inet_insert_ifa(struct in_i
 	ifa->ifa_flags &= ~IFA_F_SECONDARY;
 	last_primary = &in_dev->ifa_list;
 
+	/* Don't set IPv6 only flags to IPv4 addresses */
+	ifa->ifa_flags &= ~IPV6ONLY_FLAGS;
+
 	for (ifap = &in_dev->ifa_list; (ifa1 = *ifap) != NULL;
 	     ifap = &ifa1->ifa_next) {
 		if (!(ifa1->ifa_flags & IFA_F_SECONDARY) &&


