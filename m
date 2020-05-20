Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CAF1DAD83
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 10:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgETIc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 04:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgETIcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 04:32:54 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99A4C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 01:32:53 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t7so1039450plr.0
        for <stable@vger.kernel.org>; Wed, 20 May 2020 01:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uRm0inOSA1wLGYru+EKiLEAH9ZxFBx8He5GrcjTmYus=;
        b=WO/OCEZIeElldrwdIFdxzh908eQBMlf6SmXSXuIfbLwu0S7nFkhTkEgstqatXlhiRg
         1OZI5xPAWZPQCp/gFf6XKAAjEfKf9Eg1g+1pJOETOUlLtV5gEFl8+jkHxvK6JVTPAQOi
         3qxU/G/DvxGnumfVjtCJG0eSywHv2+fz/ZqX5QXV+NpLDMKm2h/9X1V26zVXFjfM3wTf
         p/vDVYu6Q+OKv3AXCG18QpCePkL5ImYlo0luE6KUMtqOzt4hFR3tlym/4srFfBjDQ5BD
         Gfx1zOiaj/sEl9a22iFKCbR4wH42V9rtTYn0usEpJ53ZOgEr8bgSzkECpjrnsh9UkNHT
         JfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uRm0inOSA1wLGYru+EKiLEAH9ZxFBx8He5GrcjTmYus=;
        b=bamKXxVYCulvxwHJXk0pNe+5fpWqWox9C/re1+FM+aAYu/cNzoG7ZglzZXQuD2MXcn
         NoNQU+AtjTWYJEBS9Um5HH9kyOz9y1ZiTw6MHdDp8g2tnXr+SOl8TNcN34ALKrUB+ZJK
         dOj+OIVShu8fGm/CUWqc0arQInb5EA5oUfVFm91CB5bpwQza3g1zx++PUwzCAvP3QSuu
         NOWNFZ/u5Psusg5D7y/Zryc4B1Dp/fzYY2GQulqJsRvTBByfa3lmPeZTIOGKg83lslSx
         H1ajQTO2HMp7Wu1HUfLUQR9NnJPSFz9X6951RrmlJkxJjaNXqnkTKYOzNKHCgdsPltii
         VAQw==
X-Gm-Message-State: AOAM5320j4SyFHx00Vs8bE8q8ZvseYYsOuPVocERR+8I4ILBqRnFqmU7
        p+5ubNl6beLaCPU3MHNreVlLG2TVQU8=
X-Google-Smtp-Source: ABdhPJzgcCjz7zz8c2cxioxRyVBVr9+N8S0eez6HpqMHxLFb5u5xJNRkDGfYVqT/uZaIpWt9cSD1xg==
X-Received: by 2002:a17:90a:648c:: with SMTP id h12mr4123185pjj.229.1589963573220;
        Wed, 20 May 2020 01:32:53 -0700 (PDT)
Received: from santosiv.in.ibm.com.com ([223.181.246.139])
        by smtp.gmail.com with ESMTPSA id 2sm1553980pfz.39.2020.05.20.01.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 01:32:52 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH v4 0/6] Memory corruption may occur due to incorrent tlb flush
Date:   Wed, 20 May 2020 14:00:19 +0530
Message-Id: <20200520083025.229011-1-santosh@fossix.org>
X-Mailer: git-send-email 2.25.4
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
--
Changelog:
 v2: Send the patches with the correct format (commit sha1 upstream) for stable
 v3: Fix compilation for ppc44x_defconfig and mpc885_ads_defconfig
 v4: No change, Resend.

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
 arch/powerpc/include/asm/nohash/32/pgalloc.h |   8 --
 arch/powerpc/include/asm/tlb.h               |  11 ++
 arch/powerpc/mm/pgtable-book3s64.c           |   7 --
 arch/sparc/include/asm/tlb_64.h              |   9 ++
 arch/x86/Kconfig                             |   1 -
 include/asm-generic/tlb.h                    | 103 ++++++++++++++++---
 mm/memory.c                                  |  20 ++--
 11 files changed, 122 insertions(+), 52 deletions(-)

-- 
2.25.4

