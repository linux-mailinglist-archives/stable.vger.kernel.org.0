Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9182C3CAA2E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242987AbhGOTM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243632AbhGOTJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21590613D8;
        Thu, 15 Jul 2021 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375963;
        bh=bCoeEDpeakw8Oebug4Gh/pTMiYMIT4eJH2E2tGUXFGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCWUWA5Ivua5aWdtEEOQgOc0UoIHZamDd1o9RdWGrCpamDWAtwxh2oXWlvUwmOeKZ
         E5P+knAgF4BiEii23e5vUfJzJpkV8omTwyLi6fCYsyRi1Zo271zDS5IUP24yarzthC
         AbEKQQin35r4y+3hx6lo1ubm/WukQkdgEAzjcEwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 066/266] icmp: fix lib conflict with trinity
Date:   Thu, 15 Jul 2021 20:37:01 +0200
Message-Id: <20210715182625.903768521@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Roeseler <andreas.a.roeseler@gmail.com>

[ Upstream commit e32ea44c7ae476f4c90e35ab0a29dc8ff082bc11 ]

Including <linux/in.h> and <netinet/in.h> in the dependencies breaks
compilation of trinity due to multiple definitions. <linux/in.h> is only
used in <linux/icmp.h> to provide the definition of the struct in_addr,
but this can be substituted out by using the datatype __be32.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/icmp.h | 3 +--
 net/ipv4/icmp.c           | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index c1da8244c5e1..163c0998aec9 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -20,7 +20,6 @@
 
 #include <linux/types.h>
 #include <asm/byteorder.h>
-#include <linux/in.h>
 #include <linux/if.h>
 #include <linux/in6.h>
 
@@ -154,7 +153,7 @@ struct icmp_ext_echo_iio {
 		struct {
 			struct icmp_ext_echo_ctype3_hdr ctype3_hdr;
 			union {
-				struct in_addr	ipv4_addr;
+				__be32		ipv4_addr;
 				struct in6_addr	ipv6_addr;
 			} ip_addr;
 		} addr;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 752e392083e6..0a57f1892e7e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1066,7 +1066,7 @@ static bool icmp_echo(struct sk_buff *skb)
 			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
 					 sizeof(struct in_addr))
 				goto send_mal_query;
-			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr.s_addr);
+			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
 			break;
 #if IS_ENABLED(CONFIG_IPV6)
 		case ICMP_AFI_IP6:
-- 
2.30.2



