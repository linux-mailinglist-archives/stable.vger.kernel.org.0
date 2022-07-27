Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708E2582E9B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiG0ROx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiG0RNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:13:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD1276963;
        Wed, 27 Jul 2022 09:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5BD3B821BA;
        Wed, 27 Jul 2022 16:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE25C433C1;
        Wed, 27 Jul 2022 16:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940138;
        bh=TLs54fR9ZjrgFajJSrQMbGvCC1KeHOx8HI9w8RnTpT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1b+dhEhgd3QrfxOkQ1TAnGIwNO45ieCg7/VlJcc6mRi+VDPXNVu8mKaQ5UmMKquk5
         TSdDXePBIwxllPQ13BYHtcNmZm22zCgXpoNMUvxCn1hIMB35/E6uKYv8io8CA5HGBa
         15gOptq315507pwVtRRoSCJ6S7QjzLAOSSnc9ux0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/201] ip: Fix data-races around sysctl_ip_prot_sock.
Date:   Wed, 27 Jul 2022 18:10:23 +0200
Message-Id: <20220727161032.705219293@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
index a0ac57af82dc..8462ced0c21e 100644
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
index ead5db7e24ea..a36728277e32 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -97,7 +97,7 @@ static int ipv4_local_port_range(struct ctl_table *table, int write,
 		 * port limit.
 		 */
 		if ((range[1] < range[0]) ||
-		    (range[0] < net->ipv4.sysctl_ip_prot_sock))
+		    (range[0] < READ_ONCE(net->ipv4.sysctl_ip_prot_sock)))
 			ret = -EINVAL;
 		else
 			set_local_port_range(net, range);
@@ -123,7 +123,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		.extra2 = &ip_privileged_port_max,
 	};
 
-	pports = net->ipv4.sysctl_ip_prot_sock;
+	pports = READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 
@@ -135,7 +135,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		if (range[0] < pports)
 			ret = -EINVAL;
 		else
-			net->ipv4.sysctl_ip_prot_sock = pports;
+			WRITE_ONCE(net->ipv4.sysctl_ip_prot_sock, pports);
 	}
 
 	return ret;
-- 
2.35.1



