Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E303327879D
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgIYMtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbgIYMs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:48:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A685621D91;
        Fri, 25 Sep 2020 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038139;
        bh=j5Jtr4jGrXGb5IdUSINTWALGWCnHhHZlYQSIiiDmmac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks6NBJwN7dmJm9vc8cR4jLT5EXTGTlI8JiDgeGLgxhr3cuWilIBu7hHydV3P0qhCJ
         wIbCwRDBdCw9vhU/1aN11eU1UFOn2dicjsNF8aWyDQzPP+tFo7wnZl/UdGaspCA9Xo
         AFUbSwhK/W/Jab7ozmwI/flHMJPjlFeKyCbJWFHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 18/56] net: Fix bridge enslavement failure
Date:   Fri, 25 Sep 2020 14:48:08 +0200
Message-Id: <20200925124730.555612010@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit e1b9efe6baebe79019a2183176686a0e709388ae ]

When a netdev is enslaved to a bridge, its parent identifier is queried.
This is done so that packets that were already forwarded in hardware
will not be forwarded again by the bridge device between netdevs
belonging to the same hardware instance.

The operation fails when the netdev is an upper of netdevs with
different parent identifiers.

Instead of failing the enslavement, have dev_get_port_parent_id() return
'-EOPNOTSUPP' which will signal the bridge to skip the query operation.
Other callers of the function are not affected by this change.

Fixes: 7e1146e8c10c ("net: devlink: introduce devlink_compat_switch_id_get() helper")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8641,7 +8641,7 @@ int dev_get_port_parent_id(struct net_de
 		if (!first.id_len)
 			first = *ppid;
 		else if (memcmp(&first, ppid, sizeof(*ppid)))
-			return -ENODATA;
+			return -EOPNOTSUPP;
 	}
 
 	return err;


