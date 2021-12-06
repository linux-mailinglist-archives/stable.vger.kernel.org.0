Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C22646A93F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350304AbhLFVQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350300AbhLFVQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:16:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40847C0611F7;
        Mon,  6 Dec 2021 13:12:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD0AB81197;
        Mon,  6 Dec 2021 21:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78741C341C1;
        Mon,  6 Dec 2021 21:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825160;
        bh=T3yRgLCp/9PEM/7fq9iom2T9g59mfQVQIxFhlGFfXrk=;
        h=From:To:Cc:Subject:Date:From;
        b=kMQEt491P7M15oVAYo3wvGtQ6dZh9gMLu0+smRayXJj6KUvwpbG7E1FqTyOgKqYO5
         IQzub8eN5COg6bNdmp/03UUPl6TOCBKenMzsXqVSpYHI92Caxxelw0yqfgqzU43xGq
         jffiGpyTVPZK1D7cpC8PiZa3t/oHcMk6YflGw7lQWbrHS0atzX7+MRwqv5g/4h78Q4
         NqkaaZZqQYXFkwvsJNfFEuj6RId2W/1bZRqQitGBiEDowEA+1DsJ2BinQgVwYBzbkc
         q/GYriYoTsp2dvWUwtq3i2kTIw41luhofh4PMib08y0q7WUVcHxUzE26pP64zG99bM
         c/9p1Xd48/CeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 01/24] drm/msm: Fix null ptr access msm_ioctl_gem_submit()
Date:   Mon,  6 Dec 2021 16:12:06 -0500
Message-Id: <20211206211230.1660072-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <akhilpo@codeaurora.org>

[ Upstream commit 26d776fd0f79f093a5d0ce1a4c7c7a992bc3264c ]

Fix the below null pointer dereference in msm_ioctl_gem_submit():

 26545.260705:   Call trace:
 26545.263223:    kref_put+0x1c/0x60
 26545.266452:    msm_ioctl_gem_submit+0x254/0x744
 26545.270937:    drm_ioctl_kernel+0xa8/0x124
 26545.274976:    drm_ioctl+0x21c/0x33c
 26545.278478:    drm_compat_ioctl+0xdc/0xf0
 26545.282428:    __arm64_compat_sys_ioctl+0xc8/0x100
 26545.287169:    el0_svc_common+0xf8/0x250
 26545.291025:    do_el0_svc_compat+0x28/0x54
 26545.295066:    el0_svc_compat+0x10/0x1c
 26545.298838:    el0_sync_compat_handler+0xa8/0xcc
 26545.303403:    el0_sync_compat+0x188/0x1c0
 26545.307445:   Code: d503201f d503201f 52800028 4b0803e8 (b8680008)
 26545.318799:   Kernel panic - not syncing: Oops: Fatal exception

Signed-off-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20211118154903.2.I3ae019673a0cc45d83a193a7858748dd03dbb820@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 151d19e4453cd..bf95b81bf35b5 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -780,6 +780,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 		args->nr_cmds);
 	if (IS_ERR(submit)) {
 		ret = PTR_ERR(submit);
+		submit = NULL;
 		goto out_unlock;
 	}
 
-- 
2.33.0

