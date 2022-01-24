Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0149A955
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322483AbiAYDVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60264 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345165AbiAXUWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:22:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A288AB810BD;
        Mon, 24 Jan 2022 20:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EEFC340E8;
        Mon, 24 Jan 2022 20:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055752;
        bh=GDdWL9il9DOHbSzgLE5q3dJC5+8l0Mvknrnk8n4buMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwP7hphfAVYHNwCp1WwThbjPCIsqL/cXJcuOc9ajsyFCc6uCEi4/QJFE+ubXVnfHW
         Yl7pZ3P75c/ZYnkbshqoLlm7fSR57bw+IYM9PAxLaRfzX07HWR/5lQNtPzC0K5JG0A
         Hy5hh5I5sTMB0OYfmC/DeJlHVwPSADJS70vFjujU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/846] drm/msm/gpu: Dont allow zero fence_id
Date:   Mon, 24 Jan 2022 19:35:38 +0100
Message-Id: <20220124184108.543206462@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit ca3ffcbeb0c866d9b0cb38eaa2bd4416597b5966 ]

Elsewhere we treat zero as "no fence" and __msm_gem_submit_destroy()
skips removal from fence_idr.  We could alternately change this to use
negative values for "no fence" but I think it is more clear to not allow
zero as a valid fence_id.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: a61acbbe9cf8 ("drm/msm: Track "seqno" fences by idr")
Link: https://lore.kernel.org/r/20211129182344.292609-1-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index d9aef97eb93ad..7fb7ff043bcd7 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -887,7 +887,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 	 * to the underlying fence.
 	 */
 	submit->fence_id = idr_alloc_cyclic(&queue->fence_idr,
-			submit->user_fence, 0, INT_MAX, GFP_KERNEL);
+			submit->user_fence, 1, INT_MAX, GFP_KERNEL);
 	if (submit->fence_id < 0) {
 		ret = submit->fence_id = 0;
 		submit->fence_id = 0;
-- 
2.34.1



