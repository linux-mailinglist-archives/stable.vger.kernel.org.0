Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6183B5B6FD7
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbiIMOSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiIMOR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:17:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5AF642D9;
        Tue, 13 Sep 2022 07:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ADD5614B7;
        Tue, 13 Sep 2022 14:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A32C433C1;
        Tue, 13 Sep 2022 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078307;
        bh=xxPNsh/xajkhmhzlrFDpsytceTtjFF4T+3PHIVSJ6hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYX6YlLrqI0FqsFaXysWCiJaQdpzL2P/WDdgX/cneWgHjHZBdVpzQr1FOT0OqITnc
         5IAkykTMyHqKX4cNqI1oHyrGyGFuj5bjvTZ4wAJHvzmZ9w0xAJIzhSDOYS5Lb5H9la
         vzHCISmD5CKIpaUFFpMexZ6PAPpz1ViXL313sodg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Guralnik <michaelgur@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 090/192] RDMA/cma: Fix arguments order in net device validation
Date:   Tue, 13 Sep 2022 16:03:16 +0200
Message-Id: <20220913140414.449047516@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 27cfde795a96aef1e859a5480489944b95421e46 ]

Fix the order of source and destination addresses when resolving the
route between server and client to validate use of correct net device.

The reverse order we had so far didn't actually validate the net device
as the server would try to resolve the route to itself, thus always
getting the server's net device.

The issue was discovered when running cm applications on a single host
between 2 interfaces with same subnet and source based routing rules.
When resolving the reverse route the source based route rules were
ignored.

Fixes: f887f2ac87c2 ("IB/cma: Validate routing of incoming requests")
Link: https://lore.kernel.org/r/1c1ec2277a131d277ebcceec987fd338d35b775f.1661251872.git.leonro@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fabca5e51e3d4..4dd133eccfdfb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1719,8 +1719,8 @@ cma_ib_id_from_event(struct ib_cm_id *cm_id,
 		}
 
 		if (!validate_net_dev(*net_dev,
-				 (struct sockaddr *)&req->listen_addr_storage,
-				 (struct sockaddr *)&req->src_addr_storage)) {
+				 (struct sockaddr *)&req->src_addr_storage,
+				 (struct sockaddr *)&req->listen_addr_storage)) {
 			id_priv = ERR_PTR(-EHOSTUNREACH);
 			goto err;
 		}
-- 
2.35.1



