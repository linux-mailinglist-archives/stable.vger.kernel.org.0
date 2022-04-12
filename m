Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFA34FCB1B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346267AbiDLBDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343911AbiDLA5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:57:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F198B25E88;
        Mon, 11 Apr 2022 17:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0C81B81996;
        Tue, 12 Apr 2022 00:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295E0C385A4;
        Tue, 12 Apr 2022 00:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724580;
        bh=F744J9Wch+6CYGO7v0bbvWisdqdhidN8eTq9iIl7cEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkDxnS0ep5g43ll0sXj0oV8x/+OLo2cw4VbSQxGfRhiUaDfRPi+XRaXLJezCn0Hhs
         +a9o/W8BaIANVmvSJMgMGaGCd5ntbaUqhuUzvvxyjwVRB/FeiMn50S23JCZPgzQON7
         RbZKEgD3aVeNZDBWHE4DeICJdw+qoM5Y6afOO6+YDxehrO8iDFu24RMb8Kbg7uAHvu
         5jQ22gN3xu2AKnK05A2yeF/XoHnXhmqiLBf+w1QN1sP47HblC1/UYoHW/c3904fbGw
         j15V/+VkoqidXWgLd8TaGOGmpcOoskb2n73ZKnUrZQENYthHVRNG2NLR8G/GYLh+DL
         uxIzcaXiWNDBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     QintaoShen <unSimple1993@163.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Felix.Kuehling@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 09/30] drm/amdkfd: Check for potential null return of kmalloc_array()
Date:   Mon, 11 Apr 2022 20:48:43 -0400
Message-Id: <20220412004906.350678-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: QintaoShen <unSimple1993@163.com>

[ Upstream commit ebbb7bb9e80305820dc2328a371c1b35679f2667 ]

As the kmalloc_array() may return null, the 'event_waiters[i].wait' would lead to null-pointer dereference.
Therefore, it is better to check the return value of kmalloc_array() to avoid this confusion.

Signed-off-by: QintaoShen <unSimple1993@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index ba2c2ce0c55a..159be13ef20b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -531,6 +531,8 @@ static struct kfd_event_waiter *alloc_event_waiters(uint32_t num_events)
 	event_waiters = kmalloc_array(num_events,
 					sizeof(struct kfd_event_waiter),
 					GFP_KERNEL);
+	if (!event_waiters)
+		return NULL;
 
 	for (i = 0; (event_waiters) && (i < num_events) ; i++) {
 		init_wait(&event_waiters[i].wait);
-- 
2.35.1

