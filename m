Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D6B5830C1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiG0Rli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiG0RlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:41:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243FF88F0A;
        Wed, 27 Jul 2022 09:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA642B821D5;
        Wed, 27 Jul 2022 16:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DC8C433D6;
        Wed, 27 Jul 2022 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940692;
        bh=dBqxS9MFnhhp2KUlVEf/seckEOvY4cbnnTTfewgHBMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gp4GgQlSe+9cRxzNmrxNwyYBBmvytQJFiNqup0kvNNr7WsHO0DZRCp5RhN2h34t1K
         DErdcKWyALEU4MB6ckrJTRXawgRtHChH5+aBil1ozaK/QKWD6P/Q/9Uwhc1z/XqnpZ
         VYIoWcN85uWv2IBpp8byU7z1xE/JbQxzRAou9MsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 115/158] ip: Fix data-races around sysctl_ip_prot_sock.
Date:   Wed, 27 Jul 2022 18:12:59 +0200
Message-Id: <20220727161026.078402813@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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
index 4a15b6bcb4b8..1c979fd1904c 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -357,7 +357,7 @@ static inline bool sysctl_dev_name_is_allowed(const char *name)
 
 static inline bool inet_port_requires_bind_service(struct net *net, unsigned short port)
 {
-	return port < net->ipv4.sysctl_ip_prot_sock;
+	return port < READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 }
 
 #else
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6b718688865e..344cdcd5a7d5 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -88,7 +88,7 @@ static int ipv4_local_port_range(struct ctl_table *table, int write,
 		 * port limit.
 		 */
 		if ((range[1] < range[0]) ||
-		    (range[0] < net->ipv4.sysctl_ip_prot_sock))
+		    (range[0] < READ_ONCE(net->ipv4.sysctl_ip_prot_sock)))
 			ret = -EINVAL;
 		else
 			set_local_port_range(net, range);
@@ -114,7 +114,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		.extra2 = &ip_privileged_port_max,
 	};
 
-	pports = net->ipv4.sysctl_ip_prot_sock;
+	pports = READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 
@@ -126,7 +126,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		if (range[0] < pports)
 			ret = -EINVAL;
 		else
-			net->ipv4.sysctl_ip_prot_sock = pports;
+			WRITE_ONCE(net->ipv4.sysctl_ip_prot_sock, pports);
 	}
 
 	return ret;
-- 
2.35.1



