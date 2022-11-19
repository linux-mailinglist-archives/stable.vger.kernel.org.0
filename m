Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53F76309B9
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiKSCRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbiKSCQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:16:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D178FE41;
        Fri, 18 Nov 2022 18:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CBB5624B7;
        Sat, 19 Nov 2022 02:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDC4C433C1;
        Sat, 19 Nov 2022 02:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823993;
        bh=mmTliwXsNLCTNGG626gIBpomIlTwqu97eYzbGxNtVek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T15YcGhJZ8sdBJdYUAj41oikMue0ful0HOghaWFjkfF2Ft2vFDY6xWtVJbzV03Kb6
         pGlzTP/CyR4AZpK5CGyAddCOHyAhRPtz6nBEW5CZnyQJQ552ChFqC2wLaJIT0v28+U
         mIDI1JMyxnbfARDiNgQfoLrkzo6KUStq9cB2LFdKYK28JsBtBjvJP2liIuFDgoIpq5
         uBlOqWCI4ZDHuh2RCsHCDwYKWnGn3xPSjlO2kVUP7hIwDMV3gA0E3O1L5WZkU2Tupk
         ouuRmd3MjrOMdEBfFiZq89CXXEol+xpz5NwyL14oOQ8zO6cKKDwICUI4hMIf8GSPVq
         BwQKlQbF+ugjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, luben.tuikov@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 38/44] drm/amdgpu: Unlock bo_list_mutex after error handling
Date:   Fri, 18 Nov 2022 21:11:18 -0500
Message-Id: <20221119021124.1773699-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 64f65135c41a75f933d3bca236417ad8e9eb75de ]

Get below kernel WARNING backtrace when pressing ctrl-C to kill kfdtest
application.

If amdgpu_cs_parser_bos returns error after taking bo_list_mutex, as
caller amdgpu_cs_ioctl will not unlock bo_list_mutex, this generates the
kernel WARNING.

Add unlock bo_list_mutex after amdgpu_cs_parser_bos error handling to
cleanup bo_list userptr bo.

 WARNING: kfdtest/2930 still has locks held!
 1 lock held by kfdtest/2930:
  (&list->bo_list_mutex){+.+.}-{3:3}, at: amdgpu_cs_ioctl+0xce5/0x1f10 [amdgpu]
  stack backtrace:
   dump_stack_lvl+0x44/0x57
   get_signal+0x79f/0xd00
   arch_do_signal_or_restart+0x36/0x7b0
   exit_to_user_mode_prepare+0xfd/0x1b0
   syscall_exit_to_user_mode+0x19/0x40
   do_syscall_64+0x40/0x80

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index b7bae833c804..9d59f83c8faa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -655,6 +655,7 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 		}
 		mutex_unlock(&p->bo_list->bo_list_mutex);
 	}
+	mutex_unlock(&p->bo_list->bo_list_mutex);
 	return r;
 }
 
-- 
2.35.1

