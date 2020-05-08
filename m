Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E671CAF34
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEHNPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728681AbgEHMpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2C921473;
        Fri,  8 May 2020 12:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941943;
        bh=vZrATeGy2MPM3x6OJ+weUND1lMKETe0dUmLEuxDKKCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkG9u0MsRQCsFY0NKQdtY8de8GpZk3LwoeaP+CGEdsV+UW4QVZ4NEvwEIncHS13ci
         a+DP7ufopMYv+dS3zDGWHzoApU01AjK/ZF6MFwMkeAHqGXwRxpWJz/m3T6En0cwC68
         Em199+WcQGGipgUyFtJyLvPaMOqRjPYZl6Rnyh9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 195/312] ipv6: add missing netconf notif when all is updated
Date:   Fri,  8 May 2020 14:33:06 +0200
Message-Id: <20200508123138.159632987@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit d26c638c16cb54f6fb1507e27df93ede692db572 upstream.

The 'default' value was not advertised.

Fixes: f3a1bfb11ccb ("rtnl/ipv6: use netconf msg to advertise forwarding status")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/addrconf.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -771,7 +771,14 @@ static int addrconf_fixup_forwarding(str
 	}
 
 	if (p == &net->ipv6.devconf_all->forwarding) {
+		int old_dflt = net->ipv6.devconf_dflt->forwarding;
+
 		net->ipv6.devconf_dflt->forwarding = newf;
+		if ((!newf) ^ (!old_dflt))
+			inet6_netconf_notify_devconf(net, NETCONFA_FORWARDING,
+						     NETCONFA_IFINDEX_DEFAULT,
+						     net->ipv6.devconf_dflt);
+
 		addrconf_forward_change(net, newf);
 		if ((!newf) ^ (!old))
 			inet6_netconf_notify_devconf(net, NETCONFA_FORWARDING,


