Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4736EEFA
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240843AbhD2Rfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhD2Rfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:37 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A16C06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:50 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l19-20020a0ce5130000b02901b6795e3304so11535845qvm.2
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dbAxom2rQb6936aTMluWKUPn84POTBBVC0n1eM73Twc=;
        b=UWoumohzdz5eNlOHJbNfrNpbztlg5CQciTvSQor72RykdYyYqmuUzseACz59WI6UVA
         V6xyTO5vdzsbDmX/U8emKzytEaK/0mKNpDQFaJhQRgH+dO3hkUbSK3SjRNnMAm9+Dbq7
         Oj30KI9iqDWcoMzWThIP5TT+J8x1fAOYjnDccS1K6f9xbSFlOOexABURz8Rn4/Te9E5W
         jmsSo223yxoikiPE8CnBU0+3PfuBryf7JrkavYZ83zkydJNHjkOJvfUyTA7dDdgzPUOU
         EfwTAOU+5SRX1miuM/RgC03BS4QJPWIt7H2uM1BWRbTbRmNQLmGGMRMu4EbPRbI/ieUB
         DmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dbAxom2rQb6936aTMluWKUPn84POTBBVC0n1eM73Twc=;
        b=Jm5GW7oeXWHf8khgF5cvgIm33VhV4g+cXt9rmYb5uXmD4PERtzKz4J3BqKwWlCBj38
         7ev5h0utJmtxiPah2E1ZjTVyCCM+/B7QHBVHHaION+tPoThoIrGu66c9LuPkw5K8FdnJ
         w3pzvrLcwgd/G5t454lhkglaZqSxsI7UiG0Q5zsENAZTtxFStHayTmX7cy5sNqhlXzYP
         ecFj9ZBCg2QV/Nxx8OJSbC7mbpkhtcgVdiJSYuTyVhOkgvq4AdvQE8qbJa1SIthX0IVJ
         2ErJIzy8V/DJ2/lYH9zMVBG/h4tcBtsnmpeykOtaWmUFs59u265j4kPdAvJe2FauJIMG
         OC8w==
X-Gm-Message-State: AOAM5306QZ6/9inmMr/NgLB3kYB5yOXUbW8J5cpHSPiCREsjV8zxB8bo
        hwtGD/9+mClueXMKVHj9okQtr3og9RT2qrGxNgMm+rlhiwrKNIih2cTTGN8FdN8KgkeBWQXddqU
        bRIbWu03zl+Cn5tLjkVcat1evu/ApV67gz99nYam/T22d0Mpig3mEZe+alNE=
X-Google-Smtp-Source: ABdhPJzpk3Ge1y8u7qc02nH4dHiO6+OQRbutXxcQj2DG6aIREACUEfAcVv6ZjLCGfOXniMwBMb54iH7WlA==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:ad4:5747:: with SMTP id q7mr604575qvx.51.1619717689653;
 Thu, 29 Apr 2021 10:34:49 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:13 +0000
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Message-Id: <20210429173315.1252465-8-jxgao@google.com>
Mime-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 7/9] swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit: 16fc3cef33a04632ab6b31758abdd77563a20759

swiotlb_tbl_map_single currently nevers sets a tlb_addr that is not
aligned to the tlb bucket size.  But we're going to add such a case
soon, for which this adjustment would be bogus.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 243750453b3d..b8f82f96c4c2 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -644,7 +644,6 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
-	orig_addr += (unsigned long)tlb_addr & (IO_TLB_SIZE - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
-- 
2.31.1.498.g6c1eba8ee3d-goog

