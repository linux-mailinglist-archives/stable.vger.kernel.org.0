Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803C13882AC
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352719AbhERWU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352714AbhERWU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:20:59 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C971C061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:40 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ot13-20020a17090b3b4db029015d9ead4bc5so3308014pjb.7
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GwGI7V0Cp41OE5VqtVLsLSi+of2Zs19G1tas4VFYweQ=;
        b=QYkIUCsskI56HLNZZ9Y6HLMV9WYUStepJbRcBkvlpCW/mzykXzChBSGma+tJQ9vdso
         p73ma0y7FlfQ9mAS16REZqgJ9eXdMacPyOmPDtRgN5ENQlG7O3YuHXUmtsZKSujmtoW7
         cGorIoGi2VcBr99yZJqhGm+hc4Lh81hS3yUuhyHLEayXcZF6OTQHKy32yTLfIlGWThTr
         kJJgDZgf5kVIKhCBWc9OoTtniefBvLN1yqg0rdb/ksPtOHHgqYI8VKRDEM8WLXB11Tgq
         2yi4/tyqi2QMxWOGF941BgISmnGJR2NDnG4w3QzUMqkUmtyOATGD1bDIvLJDdhTfKOQ3
         9ZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GwGI7V0Cp41OE5VqtVLsLSi+of2Zs19G1tas4VFYweQ=;
        b=cW0nzqf0I19QmVTabJfcyypRXhqHw9gg/BHrWJMMmvZTSbcR/08GRlqbVz4oK2DE5k
         jCPNFXAY1tR/4t9Q7CwY0ExqTVsuLO2LnlieXY/KF6GKcWeRLELkmW9o/Vb+J6p6wehB
         y3Kt3M35GG7jhXTZv0PM54BuQBYN2oslGkpR9/2xpcjTt1N+lwL+1ahaB/btCLaM9sX0
         r/4/w/4gnnpQCJ+VwifonHezSlLSS3cX1+Duf/zPeGN84P96gnPMqI4762DDAMYLNJJH
         s+n51ruVCkeQVNaYOxAni8Mk2s+VEEjRzdIC4TW+6pDFunoL8/SbE2/0t+btPsukrLNE
         oGLg==
X-Gm-Message-State: AOAM532i4zehlMTNw1JbPW7O9Wz/e0LQ+0huI+IcF2DrZZytl0rUC54E
        cSYbNIAwrjhNXDpvimgpfvJv8xYejyj4WRypbD29xZCAaPibJXeWH/g+dyHXbZUOh5kttrUm0UL
        WbJMCdZyzoh9bu5WgcvtNKYgjRxCxFp5UEexJQmbSYZCywRZ3LSF8rGGK6Y0=
X-Google-Smtp-Source: ABdhPJyEILyh2cQADtaIrPsaAxOQqxtDqG4jXjq5kPJqI9//7xaNkFgiviFiW8Fwjthkh1GIINxiYPsdNw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:b104:b029:ee:beb3:ef0a with SMTP id
 q4-20020a170902b104b02900eebeb3ef0amr7005556plr.80.1621376379993; Tue, 18 May
 2021 15:19:39 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:17 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-8-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 7/9] swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

swiotlb_tbl_map_single currently nevers sets a tlb_addr that is not
aligned to the tlb bucket size.  But we're going to add such a case
soon, for which this adjustment would be bogus.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Upstream: 16fc3cef33a04632ab6b31758abdd77563a20759
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index d71f05a33aa4..f4e18ae33507 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -647,7 +647,6 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
-	orig_addr += (unsigned long)tlb_addr & (IO_TLB_SIZE - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
-- 
2.31.1.751.gd2f1c929bd-goog

