Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB9F5B7111
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiIMOfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbiIMOeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E36D100;
        Tue, 13 Sep 2022 07:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A23D614AE;
        Tue, 13 Sep 2022 14:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74981C433C1;
        Tue, 13 Sep 2022 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078720;
        bh=H9j1S5WO1PTxyUbgXXYFWPH+ln1MJ7nZt4QuhPFMriw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VR3KCYMaI6zGMO0wgFlURrpR3H8OJYEugxpLBEHTNZOutjrTnjQfmXokJ4bmMhDOp
         rffxP5j+6/lyw4s8lemah6f3O4QU+tKCO/xO2fAvaHW4OA2ok8E3ylKrQcKjRI3+aY
         RO2YzGCd1P5vZZ2dtmnjESsUpLFIn6YPPRsDenmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Guralnik <michaelgur@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/121] RDMA/cma: Fix arguments order in net device validation
Date:   Tue, 13 Sep 2022 16:04:07 +0200
Message-Id: <20220913140359.765596252@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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
index a814dabcdff43..0da66dd40d6a8 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1718,8 +1718,8 @@ cma_ib_id_from_event(struct ib_cm_id *cm_id,
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



