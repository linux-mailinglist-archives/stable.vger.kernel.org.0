Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05245B7337
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiIMPE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiIMPEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:04:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12FB31238;
        Tue, 13 Sep 2022 07:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E2DDB80F9B;
        Tue, 13 Sep 2022 14:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D76AC433C1;
        Tue, 13 Sep 2022 14:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079389;
        bh=ZvBFeRpS6FJNk1e3hXE1x7y+C30QeFlKGNXI8yWVbCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTgOXdY/urj6VjRlJqGiNJxPnkq7z/rRibKD8ZCIAGitBp0Lf9BUiq87W7IpRtvYI
         hRKDBiYOXynGHOrkXrQuu8rQRMeKvrSZqFyeWqcXIHu92JrQyhuwZA3GVGl3vUBIkd
         XEbYqSt64iVGVPY6ftE+feH+qdePPAvMM7cyUxYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Guralnik <michaelgur@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/108] RDMA/cma: Fix arguments order in net device validation
Date:   Tue, 13 Sep 2022 16:07:02 +0200
Message-Id: <20220913140357.529332072@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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
index de7df5ab06f3b..cf174aa7fe25b 100644
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



