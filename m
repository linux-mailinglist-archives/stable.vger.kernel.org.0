Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA501658092
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbiL1QSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbiL1QRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC9012D3A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5805E6156B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7158DC433D2;
        Wed, 28 Dec 2022 16:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244186;
        bh=Tb/biD9tF9fdsYz9RjtBO/7A1mIYzWTOS+IRfhhp5iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYEIDdOI71cFt/6hFItP5zN2zqxPZsJyYaaaUbiZw6W3SwJjXw4MXE6XSqS5GiFQL
         ByMeBD2m7JkMf6f2g0ABw/jOQWgy2c8aeSAWf+mVzcWdzL1jJSbZzjGot58kGxzL0T
         PqyARjUq4+EmjBXqFO3d9V0vHBwexAa+MY4Loml8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Zhang <markzhang@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0608/1146] RDMA/restrack: Release MR restrack when delete
Date:   Wed, 28 Dec 2022 15:35:47 +0100
Message-Id: <20221228144346.685829257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit dac153f2802db1ad46207283cb9b2aae3d707a45 ]

The MR restrack also needs to be released when delete it, otherwise it
cause memory leak as the task struct won't be released.

Fixes: 13ef5539def7 ("RDMA/restrack: Count references to the verbs objects")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/703db18e8d4ef628691fb93980a709be673e62e3.1667810736.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 1f935d9f6178..01a499a8b88d 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -343,8 +343,6 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
 	rt = &dev->res[res->type];
 
 	old = xa_erase(&rt->xa, res->id);
-	if (res->type == RDMA_RESTRACK_MR)
-		return;
 	WARN_ON(old != res);
 
 out:
-- 
2.35.1



