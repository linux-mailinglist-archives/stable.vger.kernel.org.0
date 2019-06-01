Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2394631F5E
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfFANRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbfFANRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:17:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8061827227;
        Sat,  1 Jun 2019 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395034;
        bh=scxhZynwZodEPPgyPa4Jy0luRfXCFIG9QxNi2wfXlKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMbyILE5MCNZMfK70LuvMQvHLVF/vFCMdvbovVxzUdGbm5sBADDhGn6X+BQLb5bt5
         /TQnh0lA/NO0AoI/xkUlpOTTicgTtAnau13b6jgFZtsLOm9azsSuO6e6G8zjJ2Qh8I
         CzOyBtXErF0WVDE6C8eebLtPnYgDGJFQIRAfBv68=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Masney <masneyb@onstation.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 007/186] drm/msm: correct attempted NULL pointer dereference in debugfs
Date:   Sat,  1 Jun 2019 09:13:43 -0400
Message-Id: <20190601131653.24205-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
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
index 18ca651ab942a..23de4d1b7b1ac 100644
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

