Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EE513F862
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgAPQzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgAPQzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 082AD22464;
        Thu, 16 Jan 2020 16:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193704;
        bh=bdU4W6NQUKwa38DROjElBeIEwAa7e1UupvtmZlJXjRM=;
        h=From:To:Cc:Subject:Date:From;
        b=MhbhV+5IxqV/Gye42s9tyuvD3p9gSzv6UwD2qIysvD8Qva7FoofrQdZiL94ZJ2TlW
         RYepKR47FL49q+fgtKGxTUUPqO/QHnWho9uritmiImtDFTliSiLOx8J3fWlXxa5TQ0
         5JDgD9gUnz5soFhdOborokc0UEtJAHFx+jQhdcZQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Rosin <peda@axentia.se>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 001/671] drm/sti: do not remove the drm_bridge that was never added
Date:   Thu, 16 Jan 2020 11:43:52 -0500
Message-Id: <20200116165502.8838-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

[ Upstream commit 66e31a72dc38543b2d9d1ce267dc78ba9beebcfd ]

Removing the drm_bridge_remove call should avoid a NULL dereference
during list processing in drm_bridge_remove if the error path is ever
taken.

The more natural approach would perhaps be to add a drm_bridge_add,
but there are several other bridges that never call drm_bridge_add.
Just removing the drm_bridge_remove is the easier fix.

Fixes: 84601dbdea36 ("drm: sti: rework init sequence")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20180806061910.29914-2-peda@axentia.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_hda.c  | 1 -
 drivers/gpu/drm/sti/sti_hdmi.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 49438337f70d..19b9b5ed1297 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -721,7 +721,6 @@ static int sti_hda_bind(struct device *dev, struct device *master, void *data)
 	return 0;
 
 err_sysfs:
-	drm_bridge_remove(bridge);
 	return -EINVAL;
 }
 
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 34cdc4644435..ccf718404a1c 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -1315,7 +1315,6 @@ static int sti_hdmi_bind(struct device *dev, struct device *master, void *data)
 	return 0;
 
 err_sysfs:
-	drm_bridge_remove(bridge);
 	hdmi->drm_connector = NULL;
 	return -EINVAL;
 }
-- 
2.20.1

