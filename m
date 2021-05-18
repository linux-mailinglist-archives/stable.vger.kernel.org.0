Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6374A3882AD
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352717AbhERWU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352714AbhERWU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:20:56 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCBDC061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:37 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id n12-20020a0c8c0c0000b02901edb8963d4dso8566044qvb.18
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LkBP3Oe7cNXJj8AydHU0EMcAt6uvYCSQauqm1b3Xu2E=;
        b=UDZwJ+M94yIfdDfe6oe+s06Ck2YsOO4l42V76gBnbZoOEhz3utz0DWDWTin8qhOKyg
         6zV/kJaVNKv6rzHLCEZ0nXSZsoyGKpnCtfz59pa1SA7aLkevpOk1tF7Q8+apWwKegyjh
         fmAsjLad29wPVUfME9hbUZAy3SfS4C6DgL+HslklxM5EaByBOeaZ9nOD5fNBl8XFwETP
         W5HBTDa3rdrIKZMc3pviGca2OjxEXX6XfjOj3pVvmMZa1DN+x2AO4Yd6V5gKlsGuELkX
         HwwFEVKj8KSjiHl9MemFdYpqYv/nmw2Y5snB2qqLHWg265RmmR3OdxcjOY+1ZWz9vECN
         pTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LkBP3Oe7cNXJj8AydHU0EMcAt6uvYCSQauqm1b3Xu2E=;
        b=Rr8n9fJV4j13ljoUo6kOhLKQo4TTQUgI0gCUvKXhnwMUg8lvj3GSIp3BP/5CYy9m9M
         Cw33rEsZ8vIUwSAPlsH9ZRuqC4ZNg1lcZDKu3qC53j588w2uPM3IYJDKEITErmfZL8R1
         bXG+gNh/DNa71QWNOnnZNk5pb9xX4bCZ1jTeFMGrpDl4i1CB46n8v0eH4uNKK2RpKDaW
         K5RNeJm7qpTExlNvX/3fo/oyJj04AjweiHqamHPXbrnSxhRdrae0c2pqvv30oWeLPBCT
         bbYEaAeVc3lsdW9DVLaoKKxg5jgj/ROIDJzdQGUjzqt8QCQOZkogYerTlmdLSAtq0H67
         eG/Q==
X-Gm-Message-State: AOAM5331j78wS1lJuLiEIa/3IYFHpIhbipnpbPciKYbRTDaIcshvXRXk
        mhlHSFCXsRuuVpSXo5pi5pFzfCvEO5SqDaFYRr6m2DUTWTq9S6N92zFk2rU/lueU7yQfPRxzGCW
        JrJnxxrMTTjeWfz11rhZ2vik+z6qm3Jc4C/UiSalUCTRy/AHmhZLwUcmB4Ho=
X-Google-Smtp-Source: ABdhPJzMT6MVemqME51PDU6T3DvfGUWw35FBFyhAE11IDAr/0qObV2zkQDoerJcBbHnWqU3oPclf7VtHYg==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a0c:a483:: with SMTP id x3mr8929862qvx.28.1621376376728;
 Tue, 18 May 2021 15:19:36 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:15 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-6-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 5/9] swiotlb: clean up swiotlb_tbl_unmap_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove a layer of pointless indentation, replace a hard to follow
ternary expression with a plain if/else.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Upstream: ca10d0f8e530600ec63c603dbace2c30927d70b7
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index b57e0741ce2f..af22c3c5e488 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -614,28 +614,29 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 	 * with slots below and above the pool being returned.
 	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
-	{
-		count = ((index + nslots) < ALIGN(index + 1, IO_TLB_SEGSIZE) ?
-			 io_tlb_list[index + nslots] : 0);
-		/*
-		 * Step 1: return the slots to the free list, merging the
-		 * slots with superceeding slots
-		 */
-		for (i = index + nslots - 1; i >= index; i--) {
-			io_tlb_list[i] = ++count;
-			io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
-		}
-		/*
-		 * Step 2: merge the returned slots with the preceding slots,
-		 * if available (non zero)
-		 */
-		for (i = index - 1;
-		     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 &&
-		     io_tlb_list[i]; i--)
-			io_tlb_list[i] = ++count;
+	if (index + nslots < ALIGN(index + 1, IO_TLB_SEGSIZE))
+		count = io_tlb_list[index + nslots];
+	else
+		count = 0;
 
-		io_tlb_used -= nslots;
+	/*
+	 * Step 1: return the slots to the free list, merging the slots with
+	 * superceeding slots
+	 */
+	for (i = index + nslots - 1; i >= index; i--) {
+		io_tlb_list[i] = ++count;
+		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
+
+	/*
+	 * Step 2: merge the returned slots with the preceding slots, if
+	 * available (non zero)
+	 */
+	for (i = index - 1;
+	     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 && io_tlb_list[i];
+	     i--)
+		io_tlb_list[i] = ++count;
+	io_tlb_used -= nslots;
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
 
-- 
2.31.1.751.gd2f1c929bd-goog

