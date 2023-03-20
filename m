Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6ED6C186C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbjCTPYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjCTPXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B55429E02
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55BC7CE12EF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2E1C4339E;
        Mon, 20 Mar 2023 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325413;
        bh=H4qY2TbkHitOr7C2UAql4BrVsYvI8u8pPbSbikkSMnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKgCO5mjryOAW2Ld1E72HhlFlV38Rcgrrz4yqMYTsUMa/HbV2NeftYoA8/nwV8naD
         rv6QWvm+7rAVq4b4taEHg9wfCC93dgENpptAO9O0I0Lif+kXR6WFvq5TDOG2tGI9PG
         k+a5MNBDWo2qQBNGTOBdAww8sb4eMwatzKAgfwsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, gaoxingwang <gaoxingwang1@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/198] ipv4: Fix incorrect table ID in IOCTL path
Date:   Mon, 20 Mar 2023 15:53:40 +0100
Message-Id: <20230320145510.963255378@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index b5736ef16ed2d..390f4be7f7bec 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -576,6 +576,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			cfg->fc_scope = RT_SCOPE_UNIVERSE;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	if (cmd == SIOCDELRT)
 		return 0;
 
-- 
2.39.2



