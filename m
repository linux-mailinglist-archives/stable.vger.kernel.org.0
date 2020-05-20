Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203101DAD8D
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 10:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgETIdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 04:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETIdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 04:33:32 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953E9C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 01:33:32 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 5so923055pjd.0
        for <stable@vger.kernel.org>; Wed, 20 May 2020 01:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NlxdBI8wiLZenSs6j2nq89RHtqfPDggo6DaziIKFMVc=;
        b=X9lGxgxEPnFHSzzaOdMDLP7ATZXnbqTUa9hrsb9Z/3TMQ80e/6CC8Cs8MftCgeSYbW
         tWcwUGqj6bE/2RDfGVmERWU7RPf0O6SdL458fXe39rOozu8D6CrQV2zNWO6a5Az7EUuA
         xQkKuJkw0+s/Ti2gwcMztT4AZXIvphgs81Qiqd0Gl+HVXPpWunOQAHYV4TBJTQFguzcb
         F88Z2xxLrTpo2V1WlcK3bJKCow6rb8gUzz3+WbB5WG+tAC3GhxCGj+Z+T1FGeENlVvu+
         xPjnBtW0wsp50C6tiPwC2CPQ8bKKmknPnKSgWiaOSFS0qWv9l19AinL1O8Ne7B17uMzi
         WnUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NlxdBI8wiLZenSs6j2nq89RHtqfPDggo6DaziIKFMVc=;
        b=aL8CA0SdaGQYycVEmRac04v8oHaUqQDRrb72JN2vqQurhsTGk4Jbhpw2ok0yoOJj4h
         oiTcGxcL1vrTzrjzo81XeoxYovyHWF0SwnMuQtwtatwizmV1xfZ8vADzvLht+pXiX0GY
         NTfTsk+gU+8Vq2aIsmvYr2M2kxdpY64eKNdKbI74w9sbN9fkzMg5MU0KX3hTTDtfTQE7
         cusS1Uk2rmB/372VbTMHCx/i2+aw8xj+nlLNg7ULarihvNy2QrjOBfjWYDtrl07MM3MX
         8twDzGMFa0g+dQfqLSJA2/3WvgsjN2u8ox9RhAZsnyVs1mct9sL0N3LL/X4F4T8JhUIa
         wp4Q==
X-Gm-Message-State: AOAM530bcJdFwR9UbuFRblT6A0ZQ6FKzJLOFlQGDKtGhJxu4A0kkOHoa
        yeaLFHpV7ebPrEjycQryfp6M1XvmukA=
X-Google-Smtp-Source: ABdhPJwEQgWQuk6x5EevptElzwnttM1fzDUykzVF8QoxGjOlm29ZKZuBRwmc+SfC8yz5Pv/hFbgtbg==
X-Received: by 2002:a17:90a:1303:: with SMTP id h3mr3819470pja.44.1589963611955;
        Wed, 20 May 2020 01:33:31 -0700 (PDT)
Received: from santosiv.in.ibm.com.com ([223.181.246.139])
        by smtp.gmail.com with ESMTPSA id 2sm1553980pfz.39.2020.05.20.01.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 01:33:31 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH v4 6/6] asm-generic/tlb: avoid potential double flush
Date:   Wed, 20 May 2020 14:00:25 +0530
Message-Id: <20200520083025.229011-7-santosh@fossix.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200520083025.229011-1-santosh@fossix.org>
References: <20200520083025.229011-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 0758cd8304942292e95a0f750c374533db378b32 upstream

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
2.25.4

