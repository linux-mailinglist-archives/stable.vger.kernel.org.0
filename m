Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E683547D4
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbhDEUwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhDEUwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:52:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B37C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:52:10 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oj6so312526pjb.5
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rePpgg0NtSFQvI03Pc8QaLoe8pSD5aFacV3/oLpjZHQ=;
        b=ZRTiEwiG+4b6sPnwdcIUTl2SBysqnBca1TYnqghxn86o7MzmKdJbBc2v/ZeQJSjl8g
         /z8dMokqdY15iLdZ3jm3DYC105gTvBTDm/Xgti4OSaZ7KnEID6lwgXZCTOSD8XQxGFt7
         sNwuUfDnjjG2XlAgrojFlrlmhAMlriZ8Bmn/bezumvHay0Kc3uWk8OxVK/gzmDktANIA
         azsVxaS7VisV2NaWXvG0yLmn7aaGhNmZUpx3ClRTtON0/z0hKZuTnLe7z4Rbhpysc/iN
         Jx8VbxFFhsEwHcD0YXZTE9H/Ql/3qNcRzGm5WWmUX7HHZqOpf1hCnAWa9ukdzp4zgBzZ
         KAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rePpgg0NtSFQvI03Pc8QaLoe8pSD5aFacV3/oLpjZHQ=;
        b=cFMCYeIIZHRUPno4ZjaoXFXmRmqAWMMoWMS7hj0P0gt9hzhrzshYEnE2ULzoXo/fr0
         sh04fRssp/mVj5YdHbUnwluxL4lGwZq0Ebbs6BvOdR8gle7HKPzoPqn6ElSb072YLTLR
         6uHsrZB/bRzJgA6QEfnEg0ul6mUXo1iD3c/yC0ypy8WlsSKbivBvbrr2zxEHGI8tUmOJ
         ViUYATIgNmlm9BABj7qti9Wfx6WJQvZhx9YY2cqxrWzNIeiKFDwDv+GMMyM8ZFHMD5yJ
         M2vK5dNjQl5S52aOtqQ2N+9Qce2PPv5Ly8SZobLs0iEx/QhIzYtnwHqx9NLP6TS/jfSL
         g7cg==
X-Gm-Message-State: AOAM530CiZd+N0n0tzGxucdj90AjUrhkChSkCBkFXeBuqiTkP1IWo2SO
        92vUg8eee0T8moIVpcwdK+Y50O7H0vsP7E8vW8u/HbD8+wZDz15rjRBXKHQuzZ5BMHcXfrf3o2x
        nQXBiGndOz8IoVxQKT5NBJHArrB8+UKxMW2iR4G9Eh8UE+j7Rct4ND0Y9LZg=
X-Google-Smtp-Source: ABdhPJxX4VdSH0GHmJVZttmoP354Ny8oZT4sk/TmDzG57ZdNjsxS65rByo2Nes1iZG7VPmKh7/LO+l4c9Q==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a63:5562:: with SMTP id f34mr18820254pgm.391.1617655929958;
 Mon, 05 Apr 2021 13:52:09 -0700 (PDT)
Date:   Mon,  5 Apr 2021 20:51:09 +0000
In-Reply-To: <20210405205109.1700468-1-jxgao@google.com>
Message-Id: <20210405205109.1700468-9-jxgao@google.com>
Mime-Version: 1.0
References: <20210405205109.1700468-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 5.4 8/8] nvme-pci: set min_align_mask
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
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 869f462e6b6e..087ae2b2a853 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2576,6 +2576,7 @@ static void nvme_reset_work(struct work_struct *work)
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
+	dma_set_min_align_mask(dev->dev, dev->ctrl.page_size - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 
-- 
2.27.0

