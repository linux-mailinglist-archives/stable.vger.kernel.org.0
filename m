Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C583183162
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 14:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgCLN2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 09:28:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39933 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgCLN2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 09:28:30 -0400
Received: by mail-pg1-f195.google.com with SMTP id s2so3087925pgv.6
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 06:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ceobO9udD14LrQZbpBJ6o1PQGbHK97VsLgC6qxhMQAM=;
        b=CClqHLwq/2JiI5Z8INqms9RzXBNoQKXNgFe5NSeNFs/3HbKL/gkSJn9AnIUGBSagnm
         6G6AZ9qyWwQTx56eX9A2hizNqDE3fTdSSrEnG5KXkmwhoM/LHeitleT4237iSpEaVMli
         R8JHuBnDG0a5ffIHDOPi412aHkkPkMERdKR3N2wlb0SFhXuIaDO47mWOM+snwniuRIEg
         Fcoi+KQlyqXIyPXGM5tjumwI+FHNKL9nNC8489rl0bcgcHm1OT54lBa6XLuAGSzoQiOI
         obLUcPT8gNbRq+eD7+9lYaAGmMuMr47lR7EvyQqTB8mHOHIxS8GQUwnJmSNnCD/TC8xf
         QupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ceobO9udD14LrQZbpBJ6o1PQGbHK97VsLgC6qxhMQAM=;
        b=uJpSpW6Y/deQJQJPNafDdNX+yqaDQqnh/jGhY3XGqrl8HJiY/RE6zpF++waOJjUbYE
         17lykgC68l5YjDAw9bO2ONyA9raKayDB3utvKcEmQ47BYrMDLiS0O80iTQsY7JNx2pxS
         HzWy5koYWwKFpllx+yQ68ndEY5aiUAn2k6aPTQI2BrIGTn4QDthI/15mOXR6cuh+V48z
         E1G1Yt9t+DEy+RBGHF0Y1aLLTQIOW5yXOHXjjM7DXVsHOAtwa79ZG4RJIn9M9AyHVhET
         vu+Jz8I6lIeRTuVwT5MYGbM5iUXsx/1Vk59FwdO2MV8Jo13hqn6dqZ/ixXj0A7iXpdAy
         p1+Q==
X-Gm-Message-State: ANhLgQ2+XTsaHqiX+1jSpYvcAfYpx97CIJ1Ni1rARhMmCFAhRC9qfLMu
        DVu2wqeTjsAYHwOr/fLRJHg5qe7aFiU=
X-Google-Smtp-Source: ADFU+vsUCc8IglJOZc1JplgZ66GG8uaBvrcHlGnViNOlSTYDkiUPzaaN1tMozhOpYCNGdSM3kEcqvg==
X-Received: by 2002:a63:cb4a:: with SMTP id m10mr7779986pgi.259.1584019708733;
        Thu, 12 Mar 2020 06:28:28 -0700 (PDT)
Received: from santosiv.in.ibm.com ([111.125.206.208])
        by smtp.gmail.com with ESMTPSA id w206sm13007435pfc.54.2020.03.12.06.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 06:28:26 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 6/6] asm-generic/tlb: avoid potential double flush
Date:   Thu, 12 Mar 2020 18:57:40 +0530
Message-Id: <20200312132740.225241-7-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312132740.225241-1-santosh@fossix.org>
References: <20200312132740.225241-1-santosh@fossix.org>
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

