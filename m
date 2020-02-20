Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3F516596F
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 09:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgBTImv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 03:42:51 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38295 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgBTImv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 03:42:51 -0500
Received: by mail-pj1-f66.google.com with SMTP id j17so586445pjz.3
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 00:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=69/MEN6neJrLZVOcMniBR+jEMvQQCzDsFJ5/OiGkBEs=;
        b=hJHLugvr5EFeG98iJbvNbllv7jxne0v7fJITPHxEGcbbif0l40t17D3thwvnIrrx3t
         zG0fM3HyxLt+MV4Er4momgpBguYXCjK5s2uqPu50480xLDetTD+Z4EF1Uocq9bSLTH3x
         KnnWv+8n7Dy8tKK/vz+j67hWtrHhh940qgxAYSvaM5AeN/6x030RnNZdlucSOYZhrg8l
         EHpi9stwZYNiymBpBEFpDTvgYjBvOv99F/uj7ezNRaB2YUS29OOSsAyZ4NfUf8X85z/7
         +2sGStvfmZmzIjW4+b448s9vyvpYH1RbCaoTDGyM8s99r/ODa8ffyH0DGuYmc2VgrHvO
         FSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=69/MEN6neJrLZVOcMniBR+jEMvQQCzDsFJ5/OiGkBEs=;
        b=juA/Tl0fA/dOiYp6ZSOnkKtn154ZfUWm23kIOrOgam8iX8N3MzJTKgSXeXqe/pj13i
         V3VuC4MDIwOqyxwV6BUMgMAhOIOOfkgvpxoctmAHH0h35dS6FJI652FiEZr/+bFIgXfQ
         MnoCUdJ1bZIKxn2DZ9a3sLsoGVxBTIFJC78FYsWE/+0nOIaUU+Xh2XjVxQbBwsAGgcpT
         VUiTrCOatcqObCF3oTndleV9KIj8lVy+yQW7Jq6YDV7ljeOyIQhfqpj24+HewGzjIA1R
         u1VI3z6tJQ/nUGESE0yvnzEJIx1z3MdIUWf+oMVCMQz51YFMHQ1yCftKGdqUExhu0/zr
         XUuQ==
X-Gm-Message-State: APjAAAUJd/J6JahMMVMKMX1//lLA/bWGd/9oTF5ARWrRntHbHftRIu3O
        clyC6DlMpAVg2P3TVjMQ+rUcJA==
X-Google-Smtp-Source: APXvYqxIywrcJiE2qVrEL0AV3O2DTy1jKzE72CSoV5+AEciC+I2Hxko/sbu3um9n9QGZEAL+B1Wytg==
X-Received: by 2002:a17:90a:af81:: with SMTP id w1mr2414350pjq.14.1582188169086;
        Thu, 20 Feb 2020 00:42:49 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.72])
        by smtp.gmail.com with ESMTPSA id r145sm2512381pfr.5.2020.02.20.00.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 00:42:48 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com, gregkh@linuxfoundation.org
Subject: [PATCH 0/6] Memory corruption may occur due to incorrent tlb flush
Date:   Thu, 20 Feb 2020 14:12:23 +0530
Message-Id: <20200220084229.1278137-1-santosh@fossix.org>
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

This is only for v4.19 stable.

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

