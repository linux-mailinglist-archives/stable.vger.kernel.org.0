Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731D932E8E3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhCEM3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231959AbhCEM3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:29:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69D4A6503C;
        Fri,  5 Mar 2021 12:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947341;
        bh=mFSrD1wneVhbIU/DX/3UfO3ldbpjEGrofRg/SJrcfFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPrQtjxdnHJ7T1UO5qkAd8Y7oPbs3NXpVc3xcXfoyIuqJ1wVGgrvneLIpv+AqtiLn
         Y93J76J4LEA6jh6Vqo3Qm1a0jAToIuPJUoJyV2F6YwPP0Zs7uj4VX885nlz/apm+56
         vsd3MbJGwpnW50G61OPmuW6VT87jD2jYtaBCfj+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yotam Gigi <yotam.gi@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 030/102] net: psample: Fix netlink skb length with tunnel info
Date:   Fri,  5 Mar 2021 13:20:49 +0100
Message-Id: <20210305120904.762036214@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

commit a93dcaada2ddb58dbc72652b42548adedd646d7a upstream.

Currently, the psample netlink skb is allocated with a size that does
not account for the nested 'PSAMPLE_ATTR_TUNNEL' attribute and the
padding required for the 64-bit attribute 'PSAMPLE_TUNNEL_KEY_ATTR_ID'.
This can result in failure to add attributes to the netlink skb due
to insufficient tail room. The following error message is printed to
the kernel log: "Could not create psample log message".

Fix this by adjusting the allocation size to take into account the
nested attribute and the padding.

Fixes: d8bed686ab96 ("net: psample: Add tunnel support")
CC: Yotam Gigi <yotam.gi@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Link: https://lore.kernel.org/r/20210225075145.184314-1-cmi@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/psample/psample.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -309,10 +309,10 @@ static int psample_tunnel_meta_len(struc
 	unsigned short tun_proto = ip_tunnel_info_af(tun_info);
 	const struct ip_tunnel_key *tun_key = &tun_info->key;
 	int tun_opts_len = tun_info->options_len;
-	int sum = 0;
+	int sum = nla_total_size(0);	/* PSAMPLE_ATTR_TUNNEL */
 
 	if (tun_key->tun_flags & TUNNEL_KEY)
-		sum += nla_total_size(sizeof(u64));
+		sum += nla_total_size_64bit(sizeof(u64));
 
 	if (tun_info->mode & IP_TUNNEL_INFO_BRIDGE)
 		sum += nla_total_size(0);


