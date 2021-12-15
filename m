Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7EC475ECF
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343530AbhLORYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:24:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44760 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245408AbhLORYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B407F619EE;
        Wed, 15 Dec 2021 17:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9801FC36AE2;
        Wed, 15 Dec 2021 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589046;
        bh=xdzZiQCkQ0Zkt/lOGyRR+XYxWc80S57QkaLlSpGJmF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNZKYqOMze4sRa0DCvgx0jN6qCWmjWmdcm51jgPwRUa/ByvGrtZ5lKkPOtbYLarrQ
         k1wcy+J3uXW/bRx4xWwfo8C4JkwdJQ+wHspOBwmRVf0JTaNnCiAPe0nVDi0uOXoRQy
         g0IQDgetf8Anzvg+a2WtbeO6ax/zBrBbq6kYbW30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/42] drm/msm: Fix null ptr access msm_ioctl_gem_submit()
Date:   Wed, 15 Dec 2021 18:21:00 +0100
Message-Id: <20211215172027.321560285@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a38f23be497d8..d9aef97eb93ad 100644
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



