Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663AD4EEFF7
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347113AbiDAObn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347201AbiDAOap (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:30:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0317728AC7F;
        Fri,  1 Apr 2022 07:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5915B8240F;
        Fri,  1 Apr 2022 14:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409F5C340F2;
        Fri,  1 Apr 2022 14:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823258;
        bh=PTQafVcH6uGdJl+Xnw4Rt465WL/8+lgTK90mj/4yFRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFDYZnVyzfXs7rLa+YyKKB2v5IZGFL/yGYrhbTBOnvh04lpFgRNhiNNGn2Qhd5+wB
         BgTI7jYBWlSuCHgpUeGMNdAM0jQ+lwvO14fTgdUsMsC3sNd+R0puz18SD50h1yiySg
         +ScvXsN1vbpO3Uf/7QizWCOQ3Yk2Rzm+AQ7imgVIemBaGFeQIRkZK8KTR+U0a2HuU5
         cCGHiQWtFXECq2QYfQIOeNOAQOJPgUzaRT+3leKNzK+HRHQDTE8Ah41AcoNozEZBtu
         7T8GEcsnmvlRCDcACDEcoTahI8EvRatWPYMH4YdXTdD0LgD07Tw3pBkt4RGbIyXE4I
         QhYrRVXHxfDtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongzhi Liu <lyz_cs@pku.edu.cn>, Melissa Wen <mwen@igalia.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 037/149] drm/v3d: fix missing unlock
Date:   Fri,  1 Apr 2022 10:23:44 -0400
Message-Id: <20220401142536.1948161-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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

From: Yongzhi Liu <lyz_cs@pku.edu.cn>

[ Upstream commit e57c1a3bd5e8e0c7181f65ae55581f0236a8f284 ]

[why]
Unlock is needed on the error handling path to prevent dead lock.
v3d_submit_cl_ioctl and v3d_submit_csd_ioctl is missing unlock.

[how]
Fix this by changing goto target on the error handling path. So
changing the goto to target an error handling path
that includes drm_gem_unlock reservations.

Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1643377262-109975-1-git-send-email-lyz_cs@pku.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index c7ed2e1cbab6..92bc0faee84f 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -798,7 +798,7 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
 
 		if (!render->base.perfmon) {
 			ret = -ENOENT;
-			goto fail;
+			goto fail_perfmon;
 		}
 	}
 
@@ -847,6 +847,7 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
 
 fail_unreserve:
 	mutex_unlock(&v3d->sched_lock);
+fail_perfmon:
 	drm_gem_unlock_reservations(last_job->bo,
 				    last_job->bo_count, &acquire_ctx);
 fail:
@@ -1027,7 +1028,7 @@ v3d_submit_csd_ioctl(struct drm_device *dev, void *data,
 						     args->perfmon_id);
 		if (!job->base.perfmon) {
 			ret = -ENOENT;
-			goto fail;
+			goto fail_perfmon;
 		}
 	}
 
@@ -1056,6 +1057,7 @@ v3d_submit_csd_ioctl(struct drm_device *dev, void *data,
 
 fail_unreserve:
 	mutex_unlock(&v3d->sched_lock);
+fail_perfmon:
 	drm_gem_unlock_reservations(clean_job->bo, clean_job->bo_count,
 				    &acquire_ctx);
 fail:
-- 
2.34.1

