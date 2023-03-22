Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8036C55D7
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjCVUBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjCVUA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BAF6A1CB;
        Wed, 22 Mar 2023 12:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66093622B8;
        Wed, 22 Mar 2023 19:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF78DC4339C;
        Wed, 22 Mar 2023 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515111;
        bh=2sqtOj+1ALMyYEPN/XCPWThb1VdY14/vc//Wws1RtxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ad5Kpn8XmMNmxeQMCZ7Epl8iLEBw23WEMiafpGKN6/lz/ImUkX3IY3MyMRoIU43Hc
         pPqBwuGwJCUax8rncXE+uhMRcoEh6Jfq87PJq7UKOXqmUwhfhPY8DLB+ZTx6m81Pzz
         ZHTrPrMqYu1mctTGEShFM6kzcdzC2iEemPF29hfU0vVk8BxbguDIaik6+e4/awP/dB
         Z83FfKcq4J5HNUq5ah8Op9hZAKKIY7abdk40Ay32RMH3fteMT1IYRxhcq4jztCTMbd
         nmD4fTGEBlNmmEeeLfqeLqTrcPdUHFjqnzXVfwcJExXbJguh87hLBs4W0CGnj+i8cu
         cPV/S1Ewnzw7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chia-I Wu <olvaffe@gmail.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 25/45] drm/amdkfd: fix a potential double free in pqm_create_queue
Date:   Wed, 22 Mar 2023 15:56:19 -0400
Message-Id: <20230322195639.1995821-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit b2ca5c5d416b4e72d1e9d0293fc720e2d525fd42 ]

Set *q to NULL on errors, otherwise pqm_create_queue would free it
again.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 5137476ec18e6..4236539d9f932 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -218,8 +218,8 @@ static int init_user_queue(struct process_queue_manager *pqm,
 	return 0;
 
 cleanup:
-	if (dev->shared_resources.enable_mes)
-		uninit_queue(*q);
+	uninit_queue(*q);
+	*q = NULL;
 	return retval;
 }
 
-- 
2.39.2

