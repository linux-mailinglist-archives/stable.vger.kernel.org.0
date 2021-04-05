Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE003547D2
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhDEUwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhDEUwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:52:12 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699D3C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:52:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u5so6525276plg.2
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UTdKj8ocmS3qFB4iDfyzZRZ0xX14Ta3gzafAciDjQIQ=;
        b=A7CWfwEsG/RiJSmID/lPUPcyzvSpCxu11vZwOH8K+XGB+kyMov3hUUbQ2lKLJZN6Gc
         fEW0W6/AIGWK/kjMAEarPaGFNivoTGzExc1kzZZYkJQneptV+3l0rAYt45ElTMVDIiv7
         GWdVrT8BMeRltutJ7iPITkGmq5TJjRmpoi3Wtp6zMQWqnXYH7ASNqL/SPg3hmJuhHIxF
         uf21Y2/rFgASKDeECUcDNlOlHbCgD2D1x+2GBxSNWUcF/G+x8Mj/dbjvbOlzRwUAHVFk
         NFQfKz3r+QEsApzAeNlAaagakOJoM5OgMXqJ08JwmAWWn+gN5iRyDX8VVPGNL06QziMn
         nAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UTdKj8ocmS3qFB4iDfyzZRZ0xX14Ta3gzafAciDjQIQ=;
        b=qTZwFJdRlnFAK9bNc3NrdUWeMldZVgLacOmDZZOvcri7UUfStWdZSzlGkgVfZyKuN4
         gf6Tyn2fz4+0h8inUGHmrBtfeJux95HnvXEAM7ZS32oOA/KCtdW+i48IX/4w+yOuMCSx
         jlJFtZ+opelM9Al2Q5TebCrdAj9AcB4AGearCkfLad9FvyvcYIvdvKJYOIB4dk9QqkbO
         8nFUJft6vfI20+llm/fKU7j3FdtK1tu6NOyn3iymc9a5lKhfD+kMpHL5VVLB2AQSmHHg
         bpVlgUn33wLsewX/pNVMz+dszcaeQoP6cnRP+ukxJPve/tnrT/d5g+62YuZppegElKYw
         8Xtg==
X-Gm-Message-State: AOAM533N30A8zpnzB+iAp6XR0a40+qwgUBC0kJ3e7AH3rr3nyjX+4dKb
        yvQ6AkJ/FBNL+e2F1cfWOjTml3n1ap/SiYMH7cH1u5+x3iYO+fDwWeDb0FgyQJYj/mQVeOcQ018
        YPwNvmBMp9vU85P5o1E3kJgDIlUmsRe5UENKy80oM0MhyQh3dRpF+EKBKFdY=
X-Google-Smtp-Source: ABdhPJykqyjw7Ex/CXK/LY2xy7kXunYqCQLUWXCQ8QBpsUgIR1VAnLGofgM2qNB3je6Wo6C8KxRfKsnTkw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:90a:df01:: with SMTP id
 gp1mr170094pjb.1.1617655923536; Mon, 05 Apr 2021 13:52:03 -0700 (PDT)
Date:   Mon,  5 Apr 2021 20:51:07 +0000
In-Reply-To: <20210405205109.1700468-1-jxgao@google.com>
Message-Id: <20210405205109.1700468-7-jxgao@google.com>
Mime-Version: 1.0
References: <20210405205109.1700468-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 5.4 6/8] swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
    
'commit 16fc3cef33a0 ("swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single")'

swiotlb_tbl_map_single currently nevers sets a tlb_addr that is not
aligned to the tlb bucket size.  But we're going to add such a case
soon, for which this adjustment would be bogus.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index dbd6cda6ace6..faf51614f02e 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -639,7 +639,6 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
-	orig_addr += (unsigned long)tlb_addr & ((1 << IO_TLB_SHIFT) - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
-- 
2.27.0

