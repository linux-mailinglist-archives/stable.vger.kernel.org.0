Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5A25218E9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243900AbiEJNlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245125AbiEJNid (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4094E244F24;
        Tue, 10 May 2022 06:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A81615C8;
        Tue, 10 May 2022 13:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0D3C385A6;
        Tue, 10 May 2022 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189233;
        bh=YmCIwfczu1mXcczkqwoETbSEQm5ZZgmkMLoLZWVLehw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvgYP1V9xCLzqVv6Kc8UAvyDWIOV5JJjKnHsnljLp/yS/SYLPHwNz9lIXUI8gz+ok
         /wylx/0/4nAPfQVdvl34A2GHgIUCXYwD/qjxDGgLxnAFbtKK6ZbvGY0IbkO0DCFR+o
         IDZfridahsvocdSR/IbG75s1UwQ8j2Sv97VbPtSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 54/70] selftests: ocelot: tc_flower_chains: specify conform-exceed action for policer
Date:   Tue, 10 May 2022 15:08:13 +0200
Message-Id: <20220510130734.447328140@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 5a7c5f70c743c6cf32b44b05bd6b19d4ad82f49d upstream.

As discussed here with Ido Schimmel:
https://patchwork.kernel.org/project/netdevbpf/patch/20220224102908.5255-2-jianbol@nvidia.com/

the default conform-exceed action is "reclassify", for a reason we don't
really understand.

The point is that hardware can't offload that police action, so not
specifying "conform-exceed" was always wrong, even though the command
used to work in hardware (but not in software) until the kernel started
adding validation for it.

Fix the command used by the selftest by making the policer drop on
exceed, and pass the packet to the next action (goto) on conform.

Fixes: 8cd6b020b644 ("selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20220503121428.842906-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -185,7 +185,7 @@ setup_prepare()
 
 	tc filter add dev $eth0 ingress chain $(IS2 0 0) pref 1 \
 		protocol ipv4 flower skip_sw ip_proto udp dst_port 5201 \
-		action police rate 50mbit burst 64k \
+		action police rate 50mbit burst 64k conform-exceed drop/pipe \
 		action goto chain $(IS2 1 0)
 }
 


