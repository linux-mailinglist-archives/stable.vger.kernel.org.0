Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2150043F34
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbfFMPzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731540AbfFMIvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E51721744;
        Thu, 13 Jun 2019 08:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415910;
        bh=CB7xnMfGQghiPEoa7Avn67rxvZbJsKlGhvbDQdoi0uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiKPr6wiCNi5vuB6vc8fi1VdSmNCMORY2eNf8EYrXeP4LASUcBbMunP7Az+X7lIUZ
         AkHMa6UgwumjB1VifyEOxrZ3GPrqbK6vqwLdDVxmzvPo17ejhF0L13nEUInM+0A7+s
         0pP6HITKcaJIr6xnjLbfNLbF3dFS+HVJgfhKHdLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 008/155] drm/msm: correct attempted NULL pointer dereference in debugfs
Date:   Thu, 13 Jun 2019 10:32:00 +0200
Message-Id: <20190613075653.209291319@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 18ca651ab942..23de4d1b7b1a 100644
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



