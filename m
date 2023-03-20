Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B466C1625
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjCTPCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjCTPB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE702CC44
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4004FB80EC8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A854BC433EF;
        Mon, 20 Mar 2023 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324296;
        bh=By1mMK0XDG4leMSJPyWQeY9N0oCL+6jKZ1VOTWWAmCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lT5h49FkHUuvim6S3D6eNLj8/AmCKVslyv3QOIBTbyF1YjvUVvIXkXS4Sem4T1u2y
         ndjkyNZ93y43rV2p3xCyNNtOF9dtM8+ss1IlPfV3Yc9/ZRJwTdnUEXuKddmWIa1DjR
         1FvVo8Un679r7orEbo1yd6xsP2QRulztwSMoSf+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, gaoxingwang <gaoxingwang1@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/30] ipv4: Fix incorrect table ID in IOCTL path
Date:   Mon, 20 Mar 2023 15:54:36 +0100
Message-Id: <20230320145420.683766932@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
References: <20230320145420.204894191@linuxfoundation.org>
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
index ee467d744b07d..710f5609b7f4e 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -529,6 +529,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			cfg->fc_scope = RT_SCOPE_UNIVERSE;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	if (cmd == SIOCDELRT)
 		return 0;
 
-- 
2.39.2



