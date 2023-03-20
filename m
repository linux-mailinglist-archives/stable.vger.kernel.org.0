Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13EB6C166C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjCTPGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbjCTPFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:05:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EA72BF14
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:01:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 536306159E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635A2C4339C;
        Mon, 20 Mar 2023 15:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324450;
        bh=Oa8+C99wmB/ytIZip85OCBHzkcqr8qOr4yJkl1BSc4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKbWjteK+FK6cGxcY7GzB5zm3EsdPo/ACOVh1M3FjxawTMlgg6gwlVHhsdXrCTtxM
         qqGHTNFnoAZKnmJXu+GuRduGIeXnKtpr16E/MVdWCeUyziHpb9s1z0Wrm0iaC/HddV
         wfczTTa5cDEY2EqB4TiEMBEXq6FtjZbHtdDQZCEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, gaoxingwang <gaoxingwang1@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/60] ipv4: Fix incorrect table ID in IOCTL path
Date:   Mon, 20 Mar 2023 15:54:37 +0100
Message-Id: <20230320145432.094597079@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 8a2618e14f81604a9b6ad305d57e0c8da939cd65 ]

Commit f96a3d74554d ("ipv4: Fix incorrect route flushing when source
address is deleted") started to take the table ID field in the FIB info
structure into account when determining if two structures are identical
or not. This field is initialized using the 'fc_table' field in the
route configuration structure, which is not set when adding a route via
IOCTL.

The above can result in user space being able to install two identical
routes that only differ in the table ID field of their associated FIB
info.

Fix by initializing the table ID field in the route configuration
structure in the IOCTL path.

Before the fix:

 # ip route add default via 192.0.2.2
 # route add default gw 192.0.2.2
 # ip -4 r show default
 # default via 192.0.2.2 dev dummy10
 # default via 192.0.2.2 dev dummy10

After the fix:

 # ip route add default via 192.0.2.2
 # route add default gw 192.0.2.2
 SIOCADDRT: File exists
 # ip -4 r show default
 default via 192.0.2.2 dev dummy10

Audited the code paths to ensure there are no other paths that do not
properly initialize the route configuration structure when installing a
route.

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Fixes: f96a3d74554d ("ipv4: Fix incorrect route flushing when source address is deleted")
Reported-by: gaoxingwang <gaoxingwang1@huawei.com>
Link: https://lore.kernel.org/netdev/20230314144159.2354729-1-gaoxingwang1@huawei.com/
Tested-by: gaoxingwang <gaoxingwang1@huawei.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230315124009.4015212-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_frontend.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index be31eeacb0beb..c31003d8c22f8 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -583,6 +583,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			cfg->fc_scope = RT_SCOPE_UNIVERSE;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	if (cmd == SIOCDELRT)
 		return 0;
 
-- 
2.39.2



