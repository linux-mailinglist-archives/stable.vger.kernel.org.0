Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41514FDA97
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352189AbiDLHXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353617AbiDLHPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:15:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687BB3A724;
        Mon, 11 Apr 2022 23:57:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C79EB60EEB;
        Tue, 12 Apr 2022 06:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5D4C385A1;
        Tue, 12 Apr 2022 06:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746630;
        bh=nrsOPGqxxHc5zGk9m8VTGwzLfhtP518ODdSA1JttUR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prDZjNOTuHCYNSr1b+5QfTK6i0AreOjrpxwya1s7cygYVzrm/wvq0TPisCuv7mi6w
         re7bLhK8qhDoUQBtFQbqOOceUnz5leLzQFI1OCEKNe87osZr8kclnWms3Al5BOdXYo
         lL1RtZD9Be5zXsMUOvX5NkypFbBJjO04BJmqELa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Melissa Wen <mwen@igalia.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 034/285] drm/v3d: fix missing unlock
Date:   Tue, 12 Apr 2022 08:28:11 +0200
Message-Id: <20220412062944.661150123@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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
index e47ae40a865a..91bdec3e0ef7 100644
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
2.35.1



