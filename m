Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADF11656FF
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 06:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgBTFfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 00:35:25 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37713 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgBTFfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 00:35:25 -0500
Received: by mail-pl1-f193.google.com with SMTP id c23so1087703plz.4
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 21:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wFo1FwABypX1fZJmqy8o1UXRNXmVYvIi9tXiQKZ/G40=;
        b=KFOxwwHj3i+fjUFM6B+07HcRcIkT3AkiqgDFs7Lfz/6EiBqpLA1K/d1hOTGAwTP1Km
         L1mvbsYiOYbIPGxQhPtXz5B7O9Jn6huTgMh1wAA5RVewtzAThuhzpqS3kpArPEpioq2O
         wlehvvlD/DuFopK29iGb+CdemQdPNizH9pr+ZjACYyAWULWVCxTE7BheXwDbR7M/0yGE
         TFOar9X7Nc50VFMwrMVcwkOk3KKKhnBFo1Wrl3VNUQ8TE+Nv/z9eb6S+zeXY688nyUpM
         XaF90cfXvZCGNk1GtFwIho9lz/2H8F3fIxNz6LDeq7OYehlL4v5DF+0RY5BiueNeAUc1
         bDKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wFo1FwABypX1fZJmqy8o1UXRNXmVYvIi9tXiQKZ/G40=;
        b=CQN3U6JjyxQtUzER+qixdP5wpZWfAXcLgaAE8wbgL/0AIIxcQcj8D9rJaFUp1ygM68
         xXqp2VDtLXRZm1N/Wu+4qSllac3R1+hauqj2jiK8L6i2QRds1QSZqJ0jga5bsTsAFoqd
         h4meewh41qjmujCpgRwBiHGXVKDxzq0BIIpN9mrz/80iRBNu0FuL9kA0KbNcb2vCWOFr
         1S4cB/zfnrlZFV+KCsDXJNMs5MP+FmpICbduk5yZ9R6h3YnV97AwkcwD6+9v8P6MmsGo
         Oc9dBTVKcR1RhAXO+iV/Hw8LXtt6QzVYqlTpYSHURmFQeVGISmXZAaNiUpEvl2X779nQ
         t6aQ==
X-Gm-Message-State: APjAAAWhHMk4YcQ/CAB2QkOc+Lc4B5Wn2DptmxrV72o2E6Ky4kAkjihj
        EccfNl6AJXpWtKzVhfRagKFcqA==
X-Google-Smtp-Source: APXvYqzM+WyubxOQyxQI+mNWB+0jX/VeqlNQtrHxT5t2zx1L7bbqOjoxax5RHS8xbOS6AtJO2ebvDQ==
X-Received: by 2002:a17:90a:8d86:: with SMTP id d6mr1563331pjo.119.1582176923372;
        Wed, 19 Feb 2020 21:35:23 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.71])
        by smtp.gmail.com with ESMTPSA id r11sm1664262pgi.9.2020.02.19.21.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 21:35:22 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com
Subject: [PATCH 6/6] asm-generic/tlb: avoid potential double flush
Date:   Thu, 20 Feb 2020 11:04:57 +0530
Message-Id: <20200220053457.930231-7-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220053457.930231-1-santosh@fossix.org>
References: <20200220053457.930231-1-santosh@fossix.org>
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

