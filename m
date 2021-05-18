Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5803882AF
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352714AbhERWVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352720AbhERWVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:21:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4330C061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:43 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 15-20020a630c4f0000b029021a6da9af28so7101303pgm.22
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4DWD3vKJbxnyYgDFODnMSjcluqEq2rz8B5SXsTiG2k8=;
        b=PIGUhl5wqQJJdkVVT424CvWOhII/9d0CIP8feFRXI6gc0mfcJQeIPZW6Wm1+rd8zXu
         rbHwicBUaTzEZBjufmjJHANiB0LJPYi9UC45LUfcu2Ao64M+ya9Pi4PhaJbqpYhc1Thr
         1HSJkteqRv4DlDj/svy/2TiXWTtaDIn+QTy9+YB4EeZgL0zFSPqQZL7mjQGO0Rg5kTmX
         nDCL1oi6VnRxaZ2EFZI7Db/1bNghtB9Cf5KkSC/YoePFDkKBiY0HjxvVji6yYoXZYylR
         o9Cl4MgAsWY8Wmdxk8ciPpqoOisw+lpcVh4Y9V5W3yB9Vd9gEqtLOGnJ1i+DuHkjRRP3
         W5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4DWD3vKJbxnyYgDFODnMSjcluqEq2rz8B5SXsTiG2k8=;
        b=ZyKZjFEsyq9bECB3Qm36kW/9EytMTKVRG4WSzK4TvgZiLOs/6vHRFRZ3ixIJlW1cP1
         5+rs/mIC7VvnO/pvRuSLtb/bl/M7ARy9NyTvcIf3fjO0uBMveZKnU5R2A4DoHoWqZDG1
         XOtDvy2bUo7sqP6LdNQcmHGkqLTdY0TwscmDlL8DQePe2gbQxwmFV9nWv+SV+3QLkirG
         2LEBXwdv4ErzL19HHvNTDg49z0+vQ3uzzD3JXsnXNYLKPEEzsorBXuAUNPgDDHTYvb3X
         T+HNk2/1uB3oiWwNIxHoeWPoUA+gnnE53JZzZ5uXvNc+PV5g56KU0MakAQOONw0xMWz8
         RmCA==
X-Gm-Message-State: AOAM532B20+4l/cQ+ZrFKcOZX04LI1AOQxLaXLOTz5OD5yRtP4njh84c
        6hH8mWwFroTEvFQPQ/fDuK+osCUahlNdVFZbeKYxxVuoz59ug4QWWkLIyarW6EOtNdoncjUrY5k
        57xluX0/sDXND54SNb30sqrdi6iO8o4wqHldJHj6I2sOUsaPYeLC9GcoatSY=
X-Google-Smtp-Source: ABdhPJz6AF5J3kOWsbwR/MgpgawjNM0p0sF3jCukEaUvvqURK7j74wNiwyHOlNoihmiM7rJiV3U/Xbnv9w==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a62:bd14:0:b029:2de:8bf7:2df8 with SMTP id
 a20-20020a62bd140000b02902de8bf72df8mr4415494pff.60.1621376383078; Tue, 18
 May 2021 15:19:43 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:19 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-10-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 9/9] nvme-pci: set min_align_mask
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PRP addressing scheme requires all PRP entries except for the
first one to have a zero offset into the NVMe controller pages (which
can be different from the Linux PAGE_SIZE).  Use the min_align_mask
device parameter to ensure that swiotlb does not change the address
of the buffer modulo the device page size to ensure that the PRPs
won't be malformed.

Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Upstream: 3d2d861eb03e8ee96dc430a54361c900cbe28afd
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3bee3724e9fa..0fe86858f39c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2628,6 +2628,7 @@ static void nvme_reset_work(struct work_struct *work)
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
+	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 
-- 
2.31.1.751.gd2f1c929bd-goog

