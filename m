Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A729A3547FF
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbhDEVD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbhDEVDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:03:17 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74C6C061788
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:03:09 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e6so1717796pls.16
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8EqNrvwkdxIVET2zGHel+i15pcUppE3BUHuAXOCRu9A=;
        b=ElbG+ls2SrN1CoymPx4ZWhtpqVC1gKGQDtHSJXI0uMAMwel4JmIcmmdgnZMSN2P1Wl
         jkimY4voGRce6I8UfP1FXs+GTRdXYV3urwt5kHwLofD5rmpsgPuLGxJ7OH1Ib+E+2KYu
         5ImJleH9fB6Q4vj6SD3oId8AUoosAvUk2mUP9XxTI4kvRRpP38nDs+DI9TuZIKFv2Z9q
         jbKTpfCxBMcjLWJBP/VMWljCmavV/ZBlchrkMrk7L4RIbme1i0wUaaQfQRopF6NA2AP2
         0jTe3IBJ8TMeNTQPrYJo3ixMzT91YdajvFpAWABM0dFSJ9G941wFiPOniSC7+qNx67VE
         LFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8EqNrvwkdxIVET2zGHel+i15pcUppE3BUHuAXOCRu9A=;
        b=Pm6GgbsbEv+9tWdkT+Z8FoI4bMITLkdlf8TAk6L44k+/c3q4CH84KYtyzpLfdqxmCt
         WHDhZgkYRtwjOb0Fnsjw+z0CRbXGdEA4W8qZGxqerFAp5P/ycPWX1TFUFj8UxOlJ1SGu
         8uFbzWp3MorAI8A4eHOkcb3v3/bpzT/TsqQ4whgz0IAliLbwbTd+/Z+vXoWug+FYB4H4
         HX/2gSAmu7A27F6Qrrhf/aYzmkBhStgfCUUOZmeRw/KWqW9ZNRMZ/Kzc4POpFJXu1CCo
         ALhTxD51DXLLhop3UkygZmvXvTWjGAl4rGBw3IfEa4K0trGDnUURqHqki3JxTjGZbG/K
         +AHw==
X-Gm-Message-State: AOAM530RzfC7l1eOvGoIoDsD/6ONevio9DNvYyAP0Aq/v+i2kMe41DkI
        af1y/0ZH0ay4lKIhEBfMPF5ags7GzSMxLOXk6ZjIinshhXgYa5D3nUjyxMKjZbrhcMJbcDKib6G
        WUWDyNiJcr548n3kLnzFr/kXftlzYLUpkceg56FMfygaboenvN3eVRq9NvIA=
X-Google-Smtp-Source: ABdhPJzv6pUJAM1EvVFH9AyPIDLN6lypS/UIImyb9PlYOkeWqcLO+sJsppTr9aihegOi+LWwuRSDuHoClw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:90a:24b:: with SMTP id
 t11mr174540pje.0.1617656588949; Mon, 05 Apr 2021 14:03:08 -0700 (PDT)
Date:   Mon,  5 Apr 2021 21:02:28 +0000
In-Reply-To: <20210405210230.1707074-1-jxgao@google.com>
Message-Id: <20210405210230.1707074-7-jxgao@google.com>
Mime-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v5.10 6/8] swiotlb: don't modify orig_addr in  swiotlb_tbl_sync_single
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
index a3c0ccc53b8d..d1349971f099 100644
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

