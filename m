Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462C22F19F7
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbhAKPot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbhAKPot (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:44:49 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902C7C061794
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 07:44:08 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id m23so97810pgl.6
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 07:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=FfPhYcgmpWfwmSV36aZsn2I7a8UwoF5mD7MCCfCIqsM=;
        b=hzZWrMpCqJJDhEcCP2t/Pa1Lp/Mjs7S51gLMqdSGernAmS6D1MVKbdz8bc3aUH6JsV
         YwxEi0Wo5x6CpbhjAiZYIRCQx1IjF1ebjNsbiiq8KU5sfGnJHhSwfmwD2ceKh6aEAw30
         04G7l1e6RT+UWbUfrUr7ABpI/vAUo02eYnSCREkCVMiqxVhaZdkwCGZZCvoXWWI+23Kk
         FtcC60BODKq43VdlxVuUGYUMH+qPvAsJ17RFnX5oHSVmWhlVyaVbvBR8ltTQoI+yMBOM
         zjHP+j1uNC28b6zicrOmjH1B16kiJWLFecCe1oigeKVm7YZddi1L3UxN4OgoLaxzkaXC
         pplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=FfPhYcgmpWfwmSV36aZsn2I7a8UwoF5mD7MCCfCIqsM=;
        b=IkzzX+BidzURRRXs5BeTi8HgQ5Yx6qgLZf2rqY6pRH2/2Szu/XVKKUHPF93qJXDkkX
         TCPyxC3hFuFVTWyCj5dcEhJq+kWjh8e8ErtMFUIDy9oUJq94mzMmyrTbQ8BvsA2/hLZO
         xgIdshdJHCt2YWIoBwzwnNUA+zZUBsauisaJGsB8Ay23RXg3yz3GVxfbFdpgCrJpz54a
         70gpiV8seK+D2J09OrEIJytDsRaclrhk9+Q2arJFsODlo+TvmB/l0bPcXuE3kHKOQmcW
         E4Usfzlq49ASApF6NKkFI9kJr9mPyHkUopIoPITcXSooZTZRVDqzi7x2Kkrxxj3VftmC
         M1jQ==
X-Gm-Message-State: AOAM530LxykUOhgrGMGoH7n1PQARQRrdyD0qjQDNX6KZtFiTfuiaZ2z5
        gWClhF3JSKxFD77HfTa9bbAftO3vXzjm
X-Google-Smtp-Source: ABdhPJyLqwzeL4t2eytHl1iY8HQ1baI3DclZDFWZdkBLNL7yQv+KBJSfikwzJGitgqEBvIQ9yMlu+w/nBd/j
Sender: "marcorr via sendgmr" <marcorr@marcorr.c.googlers.com>
X-Received: from marcorr.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1d18])
 (user=marcorr job=sendgmr) by 2002:a17:902:d90c:b029:da:9930:9da7 with SMTP
 id c12-20020a170902d90cb02900da99309da7mr17350870plz.85.1610379848075; Mon,
 11 Jan 2021 07:44:08 -0800 (PST)
Date:   Mon, 11 Jan 2021 07:43:35 -0800
Message-Id: <20210111154335.23388-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH] dma: mark unmapped DMA scatter/gather invalid
From:   Marc Orr <marcorr@google.com>
To:     hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        jxgao@google.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch updates dma_direct_unmap_sg() to mark each scatter/gather
entry invalid, after it's unmapped. This fixes two issues:

1. It makes the unmapping code able to tolerate a double unmap.
2. It prevents the NVMe driver from erroneously treating an unmapped DMA
address as mapped.

The bug that motivated this patch was the following sequence, which
occurred within the NVMe driver, with the kernel flag `swiotlb=force`.

* NVMe driver calls dma_direct_map_sg()
* dma_direct_map_sg() fails part way through the scatter gather/list
* dma_direct_map_sg() calls dma_direct_unmap_sg() to unmap any entries
  succeeded.
* NVMe driver calls dma_direct_unmap_sg(), redundantly, leading to a
  double unmap, which is a bug.

With this patch, a hadoop workload running on a cluster of three AMD
SEV VMs, is able to succeed. Without the patch, the hadoop workload
suffers application-level and even VM-level failures.

Tested-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Marc Orr <marcorr@google.com>
Reviewed-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
---
 kernel/dma/direct.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 0a4881e59aa7..3d9b17fe5771 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -374,9 +374,11 @@ void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sgl,
 	struct scatterlist *sg;
 	int i;
 
-	for_each_sg(sgl, sg, nents, i)
+	for_each_sg(sgl, sg, nents, i) {
 		dma_direct_unmap_page(dev, sg->dma_address, sg_dma_len(sg), dir,
 			     attrs);
+		sg->dma_address = DMA_MAPPING_ERROR;
+	}
 }
 EXPORT_SYMBOL(dma_direct_unmap_sg);
 #endif
-- 
2.30.0.284.gd98b1dd5eaa7-goog

