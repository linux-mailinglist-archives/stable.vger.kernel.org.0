Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08771582D19
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbiG0Qxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240847AbiG0Qwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FD94BD2D;
        Wed, 27 Jul 2022 09:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2C3A61A8E;
        Wed, 27 Jul 2022 16:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE91BC433D6;
        Wed, 27 Jul 2022 16:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939678;
        bh=7tUwbhJn/upPpdE53yuKmq3MgAo3oROg4bOvWtnkuN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGwa7Tyvl7jupl7ttHFDTFqv1aE86dCdHINpmEQs6MrwGSacK9FwLM6M3UY2ywxec
         aEvoFqVfwn9Uj257UrWZOfMIBvMIJH3JjXktKMp/yzw9cgLDhyz9dJ8fR3/3xiJ9Ts
         7kzYID8jL1Y/m0Kyz9Fan9vMTCZjPLWYG0Yacdbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/105] ip: Fix data-races around sysctl_ip_prot_sock.
Date:   Wed, 27 Jul 2022 18:10:52 +0200
Message-Id: <20220727161014.705716126@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 9b55c20f83369dd54541d9ddbe3a018a8377f451 ]

sysctl_ip_prot_sock is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

Fixes: 4548b683b781 ("Introduce a sysctl that modifies the value of PROT_SOCK.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h           | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index d715b25a8dc4..c5822d7824cd 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -352,7 +352,7 @@ static inline bool sysctl_dev_name_is_allowed(const char *name)
 
 static inline bool inet_port_requires_bind_service(struct net *net, unsigned short port)
 {
-	return port < net->ipv4.sysctl_ip_prot_sock;
+	return port < READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 }
 
 #else
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 08829809e88b..86f553864f98 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -95,7 +95,7 @@ static int ipv4_local_port_range(struct ctl_table *table, int write,
 		 * port limit.
 		 */
 		if ((range[1] < range[0]) ||
-		    (range[0] < net->ipv4.sysctl_ip_prot_sock))
+		    (range[0] < READ_ONCE(net->ipv4.sysctl_ip_prot_sock)))
 			ret = -EINVAL;
 		else
 			set_local_port_range(net, range);
@@ -121,7 +121,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		.extra2 = &ip_privileged_port_max,
 	};
 
-	pports = net->ipv4.sysctl_ip_prot_sock;
+	pports = READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 
@@ -133,7 +133,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		if (range[0] < pports)
 			ret = -EINVAL;
 		else
-			net->ipv4.sysctl_ip_prot_sock = pports;
+			WRITE_ONCE(net->ipv4.sysctl_ip_prot_sock, pports);
 	}
 
 	return ret;
-- 
2.35.1



