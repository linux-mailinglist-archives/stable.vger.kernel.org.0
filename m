Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D10B4165975
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 09:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgBTInI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 03:43:08 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44223 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgBTInH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 03:43:07 -0500
Received: by mail-pl1-f193.google.com with SMTP id d9so1270867plo.11
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 00:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SJRnSTuI/8zzV3f8/u1V+qMXPVhPYkwWrGGc/VKLtP0=;
        b=YP6DVlHEhvPNKpxsQeQrzyBc9RO9nidiyP7Dl5hj/Ch80VkDp1H1/TIDcZDfeBDErY
         W5gs7Xnx7ukwpH3p8ljjfeBjZGuCV6DeyNxDIfPw0H3XK7CD5dEquEGrH4vZu9hM+lcH
         SwnVI7KG/TCubvZIbLa2SKfBRYu1G8Upy/QczOyohf5ZEgnCZ+JOdsJknudkKF8eY6Xb
         iL7Qi27cpbSz6CxzigM9Tvg0Nz4uBZN424lmOcRFL2yt51BjFeEmb+mieUWWh+FWwxfF
         gnmW+/wvBsXU5vPyBpEQbdqcTc0PCHZkSIxx+QzEGFuwYCdwOIdWtU4YL6BavyPY6JRb
         +PrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SJRnSTuI/8zzV3f8/u1V+qMXPVhPYkwWrGGc/VKLtP0=;
        b=YUHaOdhz7J4z9f3uf2qjKHqXV8Ppj0s7KJaNYDrApPJV5XKhAaq+8Dxnfvc+o54nkz
         Z7wjhXoezKzrRqXWICOs/8GxPs6OY6LDa4jktjULPM+JAkTOjHy6F2Y4QS+UanT9+4ki
         qaiLg2s5/lN/GcsNjwxSTqZZaz3Kh9z9EUnNZZml+xM+RmuLrovYc6SHAXV6cXQ+1S+w
         CdMTdR9XjXSaRTTxijG2COahYgE1fuqjwCgqIerIOcF9Ngv5uW936K8+WdikRqdzjGCL
         qBuS5cyRcwh/As9ZA3NW2MsKOHUJyK0AzWcZ1W5eOtDgly1kAGRVTnyhLbjclJ0nPvyC
         FOlw==
X-Gm-Message-State: APjAAAW6H2HYZV+UcjJHq58xxkLbp3BWYXly0CPZq2nbTNAwiDc0uet2
        tUJjoBqXAEMvlID8zCMS0EdtCDRHRoc=
X-Google-Smtp-Source: APXvYqwDnRcG/lr4R5iDfPif3Db22kcoDa6X/w7akzniEc0hf35zQvVnVlYTjqHTUyFAOB08cy306g==
X-Received: by 2002:a17:90a:f012:: with SMTP id bt18mr2370624pjb.8.1582188187138;
        Thu, 20 Feb 2020 00:43:07 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.72])
        by smtp.gmail.com with ESMTPSA id r145sm2512381pfr.5.2020.02.20.00.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 00:43:06 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com, gregkh@linuxfoundation.org
Subject: [PATCH 6/6] asm-generic/tlb: avoid potential double flush
Date:   Thu, 20 Feb 2020 14:12:29 +0530
Message-Id: <20200220084229.1278137-7-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220084229.1278137-1-santosh@fossix.org>
References: <20200220084229.1278137-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Aneesh reported that:

	tlb_flush_mmu()
	  tlb_flush_mmu_tlbonly()
	    tlb_flush()			<-- #1
	  tlb_flush_mmu_free()
	    tlb_table_flush()
	      tlb_table_invalidate()
		tlb_flush_mmu_tlbonly()
		  tlb_flush()		<-- #2

does two TLBIs when tlb->fullmm, because __tlb_reset_range() will not
clear tlb->end in that case.

Observe that any caller to __tlb_adjust_range() also sets at least one of
the tlb->freed_tables || tlb->cleared_p* bits, and those are
unconditionally cleared by __tlb_reset_range().

Change the condition for actually issuing TLBI to having one of those bits
set, as opposed to having tlb->end != 0.

0758cd830494 in upstream.

Link: http://lkml.kernel.org/r/20200116064531.483522-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: <stable@vger.kernel.org>  # 4.19
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
[santosh: backported to 4.19 stable]
---
 include/asm-generic/tlb.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 19934cdd143e..427a70c56ddd 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -179,7 +179,12 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 {
-	if (!tlb->end)
+	/*
+	 * Anything calling __tlb_adjust_range() also sets at least one of
+	 * these bits.
+	 */
+	if (!(tlb->freed_tables || tlb->cleared_ptes || tlb->cleared_pmds ||
+	      tlb->cleared_puds || tlb->cleared_p4ds))
 		return;
 
 	tlb_flush(tlb);
-- 
2.24.1

