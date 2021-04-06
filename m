Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB23355D1A
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbhDFUof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245587AbhDFUof (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:35 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75E8C061756
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:26 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x11so13350115qki.22
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rePpgg0NtSFQvI03Pc8QaLoe8pSD5aFacV3/oLpjZHQ=;
        b=FX3QcbUXsZ59fiysV19KfwNB413SDl/OlsR+WLyXtn9ZBiHJPKMd2bENepGaL4VSKb
         jutDqNThkQVO6KaxOF8ybJymqywdem5D2Cz9e6rrNrHaUvoWfpvYK+8T0sgVYVHk4W2s
         99n5ikrVe3rB3KDJeJPsvbVkj+opdgteG2liTJhJDwyQaiOlM7rzoAW9Mm1+q9Q+mwEJ
         BDhHXCqC4NT6vT9V+qOES9V5ti5Vn3k5CogfAw0DbIiNc73UvTP2IKZ1o3gST/siXb5C
         RIepwGyHeczFiFWECoCETLUUd2ei33/nFPwBBNXnY4FEKsy416Bo6jdzma22sNxYIdQy
         33vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rePpgg0NtSFQvI03Pc8QaLoe8pSD5aFacV3/oLpjZHQ=;
        b=dS7ElxqN6Peerrn1OdvBAA/hN02tIjM876K9aJ7g2SH+Cxxi/5leljHahWyiPKfC9u
         loj1BHAHc8knbn4DdWeeaC7/g138tiOH7UGWDT2VmTIyleTK/xhcVzbzmF+VSzfeLAIf
         llgHuZdRf/BqUIbUgDOmsH755rl+AeVih2aKf7hNDh2v5Pg9WAs7hn7S4DqYHzNKDVhq
         nd677PP5d1JkalrYABN6hgOP/bO9xUli6JnwcY9WgHx0jF9tEqRh7CKaQLa3+WVTcI3x
         4q1amQeT1JbDrxbG3Yaw2d4TWurEtYZcC7haiwWBsWY+/wUgvbgivF3Azyrl0yEaLY5g
         d/XA==
X-Gm-Message-State: AOAM533USzvT+z2mG1dxrGzdb1CPgsfb4vTmwYC8Qn38pU56IC4MTHPh
        /Ia6xmz4nso0Cbx1FF9XlS+XrrfZwP6uzCXbTnJsbsu06llw2nSyGNoOB7P0pUw4hgngkoZEtzM
        KyiUv0Up9WyxllG8+wlhFV0sSUOP/DovDGUaJm/d1FJ63UUZcm5b/LLtfihE=
X-Google-Smtp-Source: ABdhPJxmNHKj0YsagYpo3qjbBR8hT+Z9H+94vNmOc6KtrwrB13ZpYlcu/Qp6o3GX/MPrUzlm8axQT+6Sfw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a0c:ee81:: with SMTP id u1mr20076365qvr.14.1617741866073;
 Tue, 06 Apr 2021 13:44:26 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:27 +0000
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Message-Id: <20210406204326.1932888-9-jxgao@google.com>
Mime-Version: 1.0
References: <20210406204326.1932888-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 8/8] nvme-pci: set min_align_mask
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

