Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D124891A3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiAJHeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:34:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40998 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239923AbiAJHcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56B046066C;
        Mon, 10 Jan 2022 07:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5D3C36AED;
        Mon, 10 Jan 2022 07:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799934;
        bh=Fg09m/mCPd1Mc5MQ5ehZXYmVp5soqYL9q9NmgVntLis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=larjxkVmYlvNCePsqmd2myBEYrjMU5Utpih0Jgxi7UcJc5RA5MM8etJMiS96HGA9X
         kZ7ZM48YRAOBPDBCFqYqPxR41KDtzQDXoIzue2jZf0wmjHyk0Gd6HQmT1fUmuxp2PI
         8pfffo3ctPDWYHWYHMw+LI5aTqzjxZBCUMqZrLQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 21/72] ipv4: Check attribute length for RTA_FLOW in multipath route
Date:   Mon, 10 Jan 2022 08:22:58 +0100
Message-Id: <20220110071822.290525529@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

commit 664b9c4b7392ce723b013201843264bf95481ce5 upstream.

Make sure RTA_FLOW is at least 4B before using.

Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -731,8 +731,13 @@ static int fib_get_nhs(struct fib_info *
 			}
 
 			nla = nla_find(attrs, attrlen, RTA_FLOW);
-			if (nla)
+			if (nla) {
+				if (nla_len(nla) < sizeof(u32)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_FLOW");
+					return -EINVAL;
+				}
 				fib_cfg.fc_flow = nla_get_u32(nla);
+			}
 
 			fib_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
 			nla = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
@@ -963,8 +968,14 @@ int fib_nh_match(struct net *net, struct
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
 			nla = nla_find(attrs, attrlen, RTA_FLOW);
-			if (nla && nla_get_u32(nla) != nh->nh_tclassid)
-				return 1;
+			if (nla) {
+				if (nla_len(nla) < sizeof(u32)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_FLOW");
+					return -EINVAL;
+				}
+				if (nla_get_u32(nla) != nh->nh_tclassid)
+					return 1;
+			}
 #endif
 		}
 


