Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C90A18315A
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 14:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgCLN2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 09:28:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46279 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgCLN2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 09:28:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id y30so3070749pga.13
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 06:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4VdmTlclfqBiP5LOajS/XPffvzKnb6GJIIt3I40wSSs=;
        b=WFCwvHblrJSKQIDlt/hX02LJlwQAq677cdprHXNImlMFLDZdkO6G45TwtzyC2CRhql
         +CGJDYID2ASbqNRAoaAQ4cXnoTm0MIXziOiSXlaJXHGd5mYSzIRdGiqeBIw3Gs+IzzTR
         HV8YwVSF+yNFk0kPmTCaPNRzjwKq5bkduW2IdNycoB+77uzWfiizFswht23+mybAJX6W
         ip76UALSdYKLeKL/cZlqjYkIu5KtmxedegXqVMkX1/vY1WGfO6ADyC9sXOu+oMitmEG/
         7U+8sP7yTXCwxaftPS6IBRVSMONGQLQde3zssOKWScNxijsRHhKCrL3jpZ7WkHuhaP9N
         r9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4VdmTlclfqBiP5LOajS/XPffvzKnb6GJIIt3I40wSSs=;
        b=QfVPCcJ2LOG7ZFYuZUh/LiSeq96/s40hEo/FuglKiEJ+FZQZwuxHSCpDjsSJ/bTu34
         B40EYIcjuza7ShD3K5Txw3OjGO3spFtvcncUpp10M0074rC7lC4NK3HPWvqiKz5mPD5t
         Z06b52sMqiBaYRzLgBkPxnA4PoF5hHGbBOOTsNzt0v5h5hqXokDWlMqn/9J53xTUVxoH
         DVvl7isBAbK/k0qN7d58YuOuY+qUscZrcyqGUoqeNXv5VY5/JGjbyZpUBgKefHlN6smk
         wHJM6xzh+dxHm6T4Yd5a/eL8YSvw5AH3mtFrT6+d6AeBZSx1qPo2BIQwUvaVkSEMwXYd
         m4DQ==
X-Gm-Message-State: ANhLgQ2gpvpYGEKhAEhsan5dC0CauVfcpN9YN0XJJB3xWRq92n9nAvz3
        3HAzE8iTFlrXxGjjn+c5GhxCZO7T77Y=
X-Google-Smtp-Source: ADFU+vs+dkfC8kvX6zcvX/2C+oWzwklyfMbqTvUZyYGRexQtGI4PyoTbHCCB7KVCz9ZSJsxgBl5B6g==
X-Received: by 2002:a63:cc0d:: with SMTP id x13mr7482346pgf.388.1584019686536;
        Thu, 12 Mar 2020 06:28:06 -0700 (PDT)
Received: from santosiv.in.ibm.com ([111.125.206.208])
        by smtp.gmail.com with ESMTPSA id w206sm13007435pfc.54.2020.03.12.06.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 06:28:04 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH v3 0/6] Memory corruption may occur due to incorrent tlb flush
Date:   Thu, 12 Mar 2020 18:57:34 +0530
Message-Id: <20200312132740.225241-1-santosh@fossix.org>
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
Changelog:
v2: Send the patches with the correct format (commit sha1 upstream) for stable
v3: Fix compilation issue on ppc40x_defconfig and ppc44x_defconfig

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
 arch/powerpc/include/asm/nohash/64/pgalloc.h |   9 +-
 arch/powerpc/include/asm/tlb.h               |  11 ++
 arch/powerpc/mm/pgtable-book3s64.c           |   7 --
 arch/sparc/include/asm/tlb_64.h              |   9 ++
 arch/x86/Kconfig                             |   1 -
 include/asm-generic/tlb.h                    | 103 ++++++++++++++++---
 mm/memory.c                                  |  20 ++--
 12 files changed, 123 insertions(+), 60 deletions(-)

-- 
2.24.1

