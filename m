Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8678E178993
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 05:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCDEbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 23:31:06 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42346 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgCDEbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 23:31:06 -0500
Received: by mail-pf1-f193.google.com with SMTP id f5so283207pfk.9
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 20:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ceobO9udD14LrQZbpBJ6o1PQGbHK97VsLgC6qxhMQAM=;
        b=0Z6NBiKRFCWjzPWR2W7+nHAwEQThe3hew9DuWu9EOYdRwCC71Xz8hZfHpO+yWB3o14
         vadUBEWiMCjKgKYVB1JxvAK2Cf6z3ncaevaA93d+ettcOFgImBZrFo03pac0lTnv+OwA
         LccRajjfj2yVFbT+HbsVgqt6MWByFq/43KzJHopPoAmmDfcnLLRANRpVgg/fTHKTuULc
         Mon39UQS0DVPVnBp3IS2RypS8+zhiQ8invKQhhHSy3MPPzjagx4fWEk6ebdcFTzkd7sH
         k1n9U/iXdQbRkhNwmur48zwOLZwAk2GMw9wHNQ50DpYFwinLRI3+6jUboxwCYkXurl7t
         /fnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ceobO9udD14LrQZbpBJ6o1PQGbHK97VsLgC6qxhMQAM=;
        b=D3Tdr30990BsDQvxaJRRhckVeYgsJhSnhON5qV2ElUgbGdRIKswmJxTFgTBB6HXH5u
         QPfWGAiVO0MTVGrAMFRoBKbTxJaHznbgd4edClmheImkQQCKv349tgenjvl/3sfULA5Z
         woAB3N2giQ27p5L/ll4Ctk8dykPF2+hFLCFjOqYRAv5wwuV21XNWb5xXgcQknYhmsF92
         DvOx92OahWjPTmhBdLSs2WNuV7sMIl3uRVdtM21k0Vt4u/K3M+Yr7hXZSN8ZWljhbQT7
         Gsd1N8fi56O7fK5Kzv3bauvtAHOCybFx8HZ8sR9/9KSEJwPLR2OBoZEA2fZGutoNzgGm
         kBSw==
X-Gm-Message-State: ANhLgQ2+vxWdoqGyVCXDVrmWfd5SwZE5H9X+wW1MCSsVAHppRHfAU9iK
        /HCxELlVNfprAUqDdq5KMCU+XA12LVI=
X-Google-Smtp-Source: ADFU+vvWsNPG7rU/DyzKJYUwznyLv6qCZXlkRFfTwmMavqC94g/If0c0AoLHv1q5XLJZ4Yh7Lo2nHQ==
X-Received: by 2002:aa7:85d9:: with SMTP id z25mr1241447pfn.223.1583296265089;
        Tue, 03 Mar 2020 20:31:05 -0800 (PST)
Received: from santosiv.in.ibm.com ([2401:4900:16ee:7b5f:eac:4364:ff14:3aaa])
        by smtp.gmail.com with ESMTPSA id y193sm10775723pfg.162.2020.03.03.20.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 20:31:04 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 6/6] asm-generic/tlb: avoid potential double flush
Date:   Wed,  4 Mar 2020 10:00:28 +0530
Message-Id: <20200304043028.280136-7-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304043028.280136-1-santosh@fossix.org>
References: <20200304043028.280136-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 0758cd8304942292e95a0f750c374533db378b32 upstream.

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

