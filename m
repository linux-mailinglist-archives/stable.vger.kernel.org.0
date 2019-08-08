Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8273386978
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404713AbfHHTHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404329AbfHHTHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72D172184E;
        Thu,  8 Aug 2019 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291261;
        bh=DAdtXfgx/bifb6FxOTO5QwM7dVYdmXyUQzw6mUtFeMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ixte5Liq5kbSxZRE83oNHKuOvl83Ph3Tp7ACHNw9UL7mfcHiS+L0UV6d5tII/Ciaj
         pLYQltFuo8QSypuJhX+u/6SGrkNjLp73s8nkAGJi78hwEL+gaSmWbPuQc4swLx+OzW
         psY+FR6FgUBGi+h655MoARj6O8qyWRZobtU75bEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 49/56] rocker: fix memory leaks of fib_work on two error return paths
Date:   Thu,  8 Aug 2019 21:05:15 +0200
Message-Id: <20190808190455.173992870@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 011f175428d46461f94a65dacb9a416529d08dda ]

Currently there are two error return paths that leak memory allocated
to fib_work. Fix this by kfree'ing fib_work before returning.

Addresses-Coverity: ("Resource leak")
Fixes: 19a9d136f198 ("ipv4: Flag fib_info with a fib_nh using IPv6 gateway")
Fixes: dbcc4fa718ee ("rocker: Fail attempts to use routes with nexthop objects")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/rocker/rocker_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2208,6 +2208,7 @@ static int rocker_router_fib_event(struc
 
 			if (fen_info->fi->fib_nh_is_v6) {
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 gateway with IPv4 route is not supported");
+				kfree(fib_work);
 				return notifier_from_errno(-EINVAL);
 			}
 		}


