Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4764936EEF8
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhD2Rfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhD2Rfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:33 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002B9C06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id h8-20020a17090a7108b029015020b35657so170124pjk.5
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sVoQxSp0O/jg17euvb7RqUbOFP+TIto1W0UV5QhxAso=;
        b=t0KgdrI3KeA7y77vkRQ6Wg5PRtchan2x7RzQsiOd43z4ie9jEhhgv8URR3ipzP1451
         9KTbje6NmyuzSY/Fxp+KJjC5OhjgnUoI8arotKIucQlwTOsXrLRwPmfTt94EHLyshMgr
         yIUYGrPdAqrY0Set1K1qCm1iubiaD2sJrj8YiwUTVGM5EXS0lt0V3rwU5GXJEkDVb+Jh
         tfQ7ClTIAY+HTLfrF+xSMuYanYxgpAekSxOYshljEHX0XaKOTvZmgs1zvyetwT67jz5i
         otrqx4Tj+PZbbOmLYFYTkbN5BfP5Zt3MyrinqNcwoaBX2HCJ4IqifBtwnrvlZeg8I3z5
         CrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sVoQxSp0O/jg17euvb7RqUbOFP+TIto1W0UV5QhxAso=;
        b=B/IQGb5UeepY0UaIRvlz8IIj1k6u1d8CP2BYZht7Ojb5rH2Y+dITh6MRSXlWVwMeu9
         3dLOwgGu29V2adTAYUqftPWCb5/GZkCuA1w5wfzLtluGRL9lAPotb61pH58xJmeWloGQ
         dSELmaOrWZkkfHYMWJjUx16axEPvxBxLxez4bnn13kyh2cr+OByl5bhzEWRKyT7oPYiP
         HYjKTSB1vgLFCoqZtx9gadPM1KoWpbDzmVroXp5R9+S6IL9FuUFjbukTZqByCI4b5BeQ
         CCAtkIXTs99utJbIPSl1ZIBtKH3fMlAJ8YG+UDSNGOqbKx9qUXvLWFM4XH1jXXv0Ofg9
         MMIQ==
X-Gm-Message-State: AOAM533HEkHMr6FuJN+z7N9jqhQ6S1CygojQSpBnbLhhbMUpQB/bXo6y
        WrJCIBqXu5z3A5hxxO1qW2JVno8Wyjq0CBBPytZ+IlGkLe2MsiwfVgFeoYgAeZtBmLVU4h8NY7E
        H1CNW/dwU3qJBwT34A/CfwrAWK3l2jQ0OAsDhQ6L9C0BEy0IJmyFjzoxc8Os=
X-Google-Smtp-Source: ABdhPJwWdR/1xJoiCz0ByKGcXpjCrnTxY544v6uOnud20axy5ShkyI8mkGWvlWfHStRHIhxJDoqSNdxXTQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:aa7:82ce:0:b029:242:deb4:9442 with SMTP id
 f14-20020aa782ce0000b0290242deb49442mr784661pfn.73.1619717686431; Thu, 29 Apr
 2021 10:34:46 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:11 +0000
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Message-Id: <20210429173315.1252465-6-jxgao@google.com>
Mime-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 5/9] swiotlb: clean up swiotlb_tbl_unmap_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit: ca10d0f8e530600ec63c603dbace2c30927d70b7

swiotlb: clean up swiotlb_tbl_unmap_single

Remove a layer of pointless indentation, replace a hard to follow
ternary expression with a plain if/else.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index f0be199da527..f5530336d7ca 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -610,28 +610,29 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
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
2.31.1.498.g6c1eba8ee3d-goog

