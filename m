Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC4F31C41
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfFANT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727579AbfFANT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:19:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8CFD272C0;
        Sat,  1 Jun 2019 13:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395196;
        bh=tbWvIJWdFYjCbnqY0TwJ2oWM5ZjnFur7mWM2r3xBZnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCh77K985J18QxXO+SPKxd01jIBpO4cAWPM81NEXDTmQ09TwiJqFpEHEkeODZIhoS
         /z8CnLyimRGH3GCmWvO51COXlq0v4arEKNpPDErcQ/UqF2DL5fYR2f8U+Q91sgbgaA
         Wie82Lm6tl9Krs3Pphr7kpuHmEHlmNZlnHtHh7AI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Masney <masneyb@onstation.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.0 007/173] drm/msm: correct attempted NULL pointer dereference in debugfs
Date:   Sat,  1 Jun 2019 09:16:39 -0400
Message-Id: <20190601131934.25053-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <masneyb@onstation.org>

[ Upstream commit 90f94660e53189755676543954101de78c26253b ]

msm_gem_describe() would attempt to dereference a NULL pointer via the
address space pointer when no IOMMU is present. Correct this by adding
the appropriate check.

Signed-off-by: Brian Masney <masneyb@onstation.org>
Fixes: 575f0485508b ("drm/msm: Clean up and enhance the output of the 'gem' debugfs node")
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190513234105.7531-2-masneyb@onstation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index c8886d3071fa3..bdf0089771bde 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -805,7 +805,8 @@ void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m)
 		seq_puts(m, "      vmas:");
 
 		list_for_each_entry(vma, &msm_obj->vmas, list)
-			seq_printf(m, " [%s: %08llx,%s,inuse=%d]", vma->aspace->name,
+			seq_printf(m, " [%s: %08llx,%s,inuse=%d]",
+				vma->aspace != NULL ? vma->aspace->name : NULL,
 				vma->iova, vma->mapped ? "mapped" : "unmapped",
 				vma->inuse);
 
-- 
2.20.1

