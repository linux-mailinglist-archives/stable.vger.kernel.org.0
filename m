Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7762132E
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiKHNrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiKHNrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:47:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947705984E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:47:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 305746158F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D01C433D6;
        Tue,  8 Nov 2022 13:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915260;
        bh=KuIRv2mqGxIGFKGZjLzix0ISC8L+bUnVqrCckcfVv9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MM7+XZUHEQjCuN5+sHtC4ZxwlZNesnrKZnl/MXGiu8Rjiwsn/isoE5OfwuCktHQYx
         E7s0KvlSxcERVJ2h5mNVdxgQ+YB+Xcg8FH8HVF5laT0iP1nJk9y4fvu7PlVAj0hyal
         OQlHdG1LFZG49ZnVyuhqEECct8azkqvbOWxZSPdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/74] RDMA/cma: Use output interface for net_dev check
Date:   Tue,  8 Nov 2022 14:38:29 +0100
Message-Id: <20221108133333.724703225@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit eb83f502adb036cd56c27e13b9ca3b2aabfa790b ]

Commit 27cfde795a96 ("RDMA/cma: Fix arguments order in net device
validation") swapped the src and dst addresses in the call to
validate_net_dev().

As a consequence, the test in validate_ipv4_net_dev() to see if the
net_dev is the right one, is incorrect for port 1 <-> 2 communication when
the ports are on the same sub-net. This is fixed by denoting the
flowi4_oif as the device instead of the incoming one.

The bug has not been observed using IPv6 addresses.

Fixes: 27cfde795a96 ("RDMA/cma: Fix arguments order in net device validation")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Link: https://lore.kernel.org/r/20221012141542.16925-1-haakon.bugge@oracle.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cf174aa7fe25..052d15629153 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1434,7 +1434,7 @@ static bool validate_ipv4_net_dev(struct net_device *net_dev,
 		return false;
 
 	memset(&fl4, 0, sizeof(fl4));
-	fl4.flowi4_iif = net_dev->ifindex;
+	fl4.flowi4_oif = net_dev->ifindex;
 	fl4.daddr = daddr;
 	fl4.saddr = saddr;
 
-- 
2.35.1



