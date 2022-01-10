Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F6F489108
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbiAJH2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239370AbiAJH0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:26:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BFFC029830;
        Sun,  9 Jan 2022 23:25:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00C60B81205;
        Mon, 10 Jan 2022 07:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31425C36AE9;
        Mon, 10 Jan 2022 07:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799551;
        bh=TkZ85wTMGS/gP/1XImUn9MD23NSXxpERlZhhbiKTp24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKCJ/YoVpc/g7D/5pTYCIbXZoI3+q1ECU1jJPSv+4rUUUxMDpXVH38ujmKNQaWovN
         JxeA9yy2LQtR8Agd8VencYNB73hA+cu7k9Isc3K3GTDEsJY0SD6hkXW7tNo/MVp150
         jzYw+QhElmJ982G8ECGiKkEu/kdszJbQIQ3sDdx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 11/22] ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
Date:   Mon, 10 Jan 2022 08:23:04 +0100
Message-Id: <20220110071814.639438308@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071814.261471354@linuxfoundation.org>
References: <20220110071814.261471354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

commit 1ff15a710a862db1101b97810af14aedc835a86a upstream.

Make sure RTA_GATEWAY for IPv6 multipath route has enough bytes to hold
an IPv6 address.

Fixes: 6b9ea5a64ed5 ("ipv6: fix multipath route replace error recovery")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3365,7 +3365,11 @@ static int ip6_route_multipath_del(struc
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				nla_memcpy(&r_cfg.fc_gateway, nla, 16);
+				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+							extack);
+				if (err)
+					return err;
+
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 		}


