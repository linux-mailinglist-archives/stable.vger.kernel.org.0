Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9484A354801
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241260AbhDEVD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbhDEVDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:03:23 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF01C06178C
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:03:16 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e8so47570pfd.1
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DwT0KnEuUIJq24rdQeE8mKCkjKjD8jpbcE4NrdQ1jDk=;
        b=Fr8qThzIql+f5dVI1DPyzBCYZ7bW8to0OlpnA1PtfpUJElz6tg0FmtJko4VvDpjshN
         jTVOPsJ1eqJSiYM3A5BjmhzetT+XommnohAHrgUaDDlx/skjdLtTpFxQMGyQQmk8XcBU
         wjKZ2cpR+ZcDuzMn0pk60CXBrijqdI3zI15EL6t+I/KIlXWeu7SArD7sOiQzPWp+IcdF
         MSxE/YMjq+xIpiXVZLzVeixM6Ze91xE+sFVfC8R0XdsfQ54okPE26EuXBX8xnoxdt4wZ
         tOLoBtZ9cIfACWsGQ3WRYqlFQatove9of2R2uickyQcqRcYseD/z37AUasQ1z8xYoMQg
         c8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DwT0KnEuUIJq24rdQeE8mKCkjKjD8jpbcE4NrdQ1jDk=;
        b=Be8awOpL52aDOtj3TXCgV13NwqLkYlJV0BCb0HR1HUFnIq+cM7iOiCjHVqrU0wBmwD
         ekv9rWBM7wSMZJFVawoDwBZD3eH8FrdfDi9WVaL7GkGb9+noTI3nknykCmexIbN1SgxE
         UX3zXHhcNFoyWzdHncRRKfB02n1kV60xnF7zbhNEVwXWBE5pyVN/RsOXiO8QFduQ/UAy
         VdewI6ma6nxqWKRrCFIs0lMJK5GOxNIEDRrMW0JhLQaMa6h5x4/+Eg2sPPdKQEmdDM6L
         C5UiaGMVlcHaQfE0TU2NSsnCQRlImgsuUj/f1EVmMj0U++JM8q/WYmHhlMSjrZpeV5nD
         B6wQ==
X-Gm-Message-State: AOAM530HVggLcRbxw91yJa4eaTOcCxy2ilDyBI0/VI9/IQWDhkPhK2L1
        +E7CkltFgPl6YWDoc5ewiTp5nbf0wcpqhqDMg1p7qEnBv/JNFjU2oB81hhtRaEAhrL+ejQc5zO6
        H5S6yKpGcIxV2HHKo8OOVhGontjEi2rwmAACP3hVU7aGdnHq8OjVHSlG3EjM=
X-Google-Smtp-Source: ABdhPJwzGYBi3h+DeSc4okTkcRpTXY5f48FNdVL17pSatP67jZ3c3Nb72MJoDDhpwrHUxcCQSvhLqf42OA==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:dacd:b029:e5:cf71:3901 with SMTP id
 q13-20020a170902dacdb02900e5cf713901mr25018627plx.23.1617656596405; Mon, 05
 Apr 2021 14:03:16 -0700 (PDT)
Date:   Mon,  5 Apr 2021 21:02:30 +0000
In-Reply-To: <20210405210230.1707074-1-jxgao@google.com>
Message-Id: <20210405210230.1707074-9-jxgao@google.com>
Mime-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v5.10 8/8] nvme-pci: set min_align_mask
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

'commit 3d2d861eb03e ("nvme-pci: set min_align_mask")'

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
---
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3be352403839..dddccfe82abc 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2590,6 +2590,7 @@ static void nvme_reset_work(struct work_struct *work)
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
+	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 
-- 
2.27.0

