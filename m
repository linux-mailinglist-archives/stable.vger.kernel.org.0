Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDFE5B83C5
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiINJD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiINJCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:02:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCCA760F5;
        Wed, 14 Sep 2022 02:01:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FDC861993;
        Wed, 14 Sep 2022 09:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966FFC433D6;
        Wed, 14 Sep 2022 09:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146117;
        bh=iygKThSUt2oRdx8axchV5M5xahy5an58AJy+GGf6yAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwPZN5f2I1/CyjNHbA/ISFaxMKhcqSRmrcGcHDq02BsC+TQKHCDGqLoh2Wjlh9pK5
         ZK3YKk1DEK+3QlEJzunCVj4/oBxNmLg1bZKSmHD/zynZEHCwNt3ZYJixF10EiaJnUU
         bpYxjAKAAhdFwH3n+kJbSn8Vz2CwzWsk8FmMp+in+qU/z6PqDP0ACqusUz3gvO4yYo
         TTr3M6PefucpX2Na6/zLX6Mq6uMEqtwXWGhnreUylMVh/1lL8lE2XNUdIBpeG3iAPF
         ArcSWafMsEQhfO9VcrbpXQO4dDhOpPuR0aLw+h2TkSLxi22S+iIk0Un5p9ApguaA6K
         thSkp5PnySXEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ZhenGuo Yin <zhenguo.yin@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, ray.huang@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 15/22] drm/ttm: update bulk move object of ghost BO
Date:   Wed, 14 Sep 2022 05:00:56 -0400
Message-Id: <20220914090103.470630-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: ZhenGuo Yin <zhenguo.yin@amd.com>

[ Upstream commit d91c411c744b55e860fbafc9a499f4f22d64c762 ]

[Why]
Ghost BO is released with non-empty bulk move object. There is a
warning trace:
WARNING: CPU: 19 PID: 1582 at ttm/ttm_bo.c:366 ttm_bo_release+0x2e1/0x2f0 [amdttm]
Call Trace:
  amddma_resv_reserve_fences+0x10d/0x1f0 [amdkcl]
  amdttm_bo_put+0x28/0x30 [amdttm]
  amdttm_bo_move_accel_cleanup+0x126/0x200 [amdttm]
  amdgpu_bo_move+0x1a8/0x770 [amdgpu]
  ttm_bo_handle_move_mem+0xb0/0x140 [amdttm]
  amdttm_bo_validate+0xbf/0x100 [amdttm]

[How]
The resource of ghost BO should be moved to LRU directly, instead of
using bulk move. The bulk move object of ghost BO should set to NULL
before function ttm_bo_move_to_lru_tail_unlocked.

v2: set bulk move to NULL manually if no resource associated with ghost BO

Fixed: 5b951e487fd6bf5f ("drm/ttm: fix bulk move handling v2")
Signed-off-by: ZhenGuo Yin <zhenguo.yin@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220906084619.2545456-1-zhenguo.yin@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 1cbfb00c1d658..57a27847206ff 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -239,6 +239,9 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	if (fbo->base.resource) {
 		ttm_resource_set_bo(fbo->base.resource, &fbo->base);
 		bo->resource = NULL;
+		ttm_bo_set_bulk_move(&fbo->base, NULL);
+	} else {
+		fbo->base.bulk_move = NULL;
 	}
 
 	dma_resv_init(&fbo->base.base._resv);
-- 
2.35.1

