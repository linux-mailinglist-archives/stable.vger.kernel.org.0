Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20BC1656F9
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 06:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgBTFfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 00:35:07 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36318 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgBTFfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 00:35:07 -0500
Received: by mail-pf1-f193.google.com with SMTP id 185so1336224pfv.3
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 21:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKm1MlIEqICiKl98BAwahnWrPOiQX0P3G2oQRircgsw=;
        b=LiGpsSJwILX3x1TKtOk/SWkE5PqYzjYz/HztQvxKIryNvRRtPJjg/T9i0J+AYg7Tpy
         1PmfPb037cZZVu3DojOYSZVhVWeW86Wz47YRR/RtqiWIBlpPW6qFHFpux6UB0zR1SVHz
         S1NuwBUumoQzgs/BN39mCEogaqAdT9oBbuFI8yD5+10nq0i8m9tJURtjMBeGTASnQqPF
         U/WI8Nw4bQ7CjEfjSnmH8Iz0VWYLM1QFXedk2lafFjh1kr1j8pEo6FoIH2I7w8mbtt4y
         Ot/32mfDt+QGsTpgqcssXHV1YGMyj/EUTUqX/FM9K22OaxEGAn72lxNnrCX5c5OIdZFm
         dM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKm1MlIEqICiKl98BAwahnWrPOiQX0P3G2oQRircgsw=;
        b=f7HekrnrNNaxjf0HbmPB5ibmgXK2qyruWn/gnsBUarc9apejoNWp2A06s2p3uKWU90
         ML2ihZ6PwYaOnTHmJs+bbKKiJTNDVk4HkwSphb3Kqedjz6LfD8bOJt0lbqjyIBon9RGq
         ywoM2bH5wqrJiRdPKUOHCia3IQNOxNAW+Hy63AyEfxJRWdJPnc2umVte9+moOYxKDDaz
         NfgNF3y2GCPrLjOT+G3we7zwyzUUOBuU2cFC8lqxlkIaJ5ygqY+40o7EW60O/+SzrwJJ
         7tpMf4ta7+mPPznpd7V3cuPwpDGUZknF5ZIYK5P5drbZqkU/Ftyxko3tPdd+AEHgSFSt
         hJnQ==
X-Gm-Message-State: APjAAAVHzD5WOGDhe/0ek2NN9DVamHWq+NIME5PPF9/YWf1qcjzKPxKP
        WZsNfk+aLMXFLwwZ5GFOolsEpw==
X-Google-Smtp-Source: APXvYqwsLC75ue0/RjU/zYa6DFXsUaBkkmJb0okKfCSO8U9YZFIgVVg1vqpuT6zDnmq1RZ3r45NA5Q==
X-Received: by 2002:a62:7a8a:: with SMTP id v132mr31783219pfc.111.1582176906864;
        Wed, 19 Feb 2020 21:35:06 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.71])
        by smtp.gmail.com with ESMTPSA id r11sm1664262pgi.9.2020.02.19.21.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 21:35:06 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com
Subject: [PATCH 0/6] Memory corruption may occur due to incorrent tlb flush
Date:   Thu, 20 Feb 2020 11:04:51 +0530
Message-Id: <20200220053457.930231-1-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The TLB flush optimisation (a46cc7a90f: powerpc/mm/radix: Improve TLB/PWC
flushes) may result in random memory corruption. Any concurrent page-table walk
could end up with a Use-after-Free. Even on UP this might give issues, since
mmu_gather is preemptible these days. An interrupt or preempted task accessing
user pages might stumble into the free page if the hardware caches page
directories.

The series is a backport of the fix sent by Peter [1].

The first three patches are dependencies for the last patch (avoid potential
double flush). If the performance impact due to double flush is considered
trivial then the first three patches and last patch may be dropped.

[1] https://patchwork.kernel.org/cover/11284843/
--
Aneesh Kumar K.V (1):
  powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case

Peter Zijlstra (4):
  asm-generic/tlb: Track freeing of page-table directories in struct
    mmu_gather
  asm-generic/tlb, arch: Invert CONFIG_HAVE_RCU_TABLE_INVALIDATE
  mm/mmu_gather: invalidate TLB correctly on batch allocation failure
    and flush
  asm-generic/tlb: avoid potential double flush

Will Deacon (1):
  asm-generic/tlb: Track which levels of the page tables have been
    cleared

 arch/Kconfig                                 |   3 -
 arch/powerpc/Kconfig                         |   2 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h |   8 --
 arch/powerpc/include/asm/book3s/64/pgalloc.h |   2 -
 arch/powerpc/include/asm/tlb.h               |  11 ++
 arch/powerpc/mm/pgtable-book3s64.c           |   7 --
 arch/sparc/include/asm/tlb_64.h              |   9 ++
 arch/x86/Kconfig                             |   1 -
 include/asm-generic/tlb.h                    | 103 ++++++++++++++++---
 mm/memory.c                                  |  20 ++--
 10 files changed, 122 insertions(+), 44 deletions(-)

-- 
2.24.1

