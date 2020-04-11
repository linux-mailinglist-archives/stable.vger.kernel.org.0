Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED4A1A5A6A
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgDKXnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbgDKXGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B213821924;
        Sat, 11 Apr 2020 23:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646381;
        bh=f09a1w7fNlXQ8Ts8ys9hzmXwKs22qUSqpWGXW9bs7b0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhfIw2LKYniMN2Ogk88+g1jg8fdNj2zFLKzJ3H07ZgfFepf0WSIScmwRocNosC1H+
         jeorckTFuIc/b71nx5FZvqLy39jdgSa1l/tkUNztjIk4u/AeuB3SJF8SNPyhcdes5k
         hIlZWBmPh5ssS9+MjpaALrttNiF+maLjXDzFEC0s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 122/149] dmaengine: idxd: check return result from check_vma() in cdev
Date:   Sat, 11 Apr 2020 19:03:19 -0400
Message-Id: <20200411230347.22371-122-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit b391554c61cb353c279523a706734b090aaf9000 ]

The returned result from the check_vma() function in the cdev ->mmap() call
needs to be handled. Add the check and returning error.

Fixes: 42d279f9137a ("dmaengine: idxd: add char driver to expose submission portal to userland")
Reported-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/158264926659.9387.14325163515683047959.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 989b7a25ca614..677ccbe6261f4 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -139,6 +139,8 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	dev_dbg(&pdev->dev, "%s called\n", __func__);
 	rc = check_vma(wq, vma, __func__);
+	if (rc < 0)
+		return rc;
 
 	vma->vm_flags |= VM_DONTCOPY;
 	pfn = (base + idxd_get_wq_portal_full_offset(wq->id,
-- 
2.20.1

