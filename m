Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1817898D
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 05:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCDEao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 23:30:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38985 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCDEao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 23:30:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id l7so288964pff.6
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 20:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LO7nEFTUA11enrlntZOqIslob1jC9EHnhi7KR1pGwtY=;
        b=wcFCoJnnA2XtoVhD5Y5icVKPTz7htJ2GXxIes8arYMKdbS8tsEyYQ+Ymf2ZqTA3oJz
         Mz6PSL/wN7eDqtnKlkptvPppB3Fix8+nPQZcJ8UtqZL/dkaoVYBhtsgGP79uENFYMsjs
         O01NfWX8r3jFIvtoimoL0zQ5lQMhcW7YyZbxjpWKGqgyF3yKOcn/qlLtyk/WiNdPO1+a
         15wAAPaUMhJxMrdyXK+CXOP2vQaULrn2MdK8EpkQznX9HChG0rREEqx78qwTClgpjfij
         91dRrxNq/d8yL2vmJ4KJ31rkcBWEpbLLvJGH+WZ+SUnzwM8OCGukhWO6KDF25NonAXOU
         nliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LO7nEFTUA11enrlntZOqIslob1jC9EHnhi7KR1pGwtY=;
        b=foCZEZhbEhOFT+1xRFylUgU38O/YkHwRVf9ZOKPz/8NfOIwnSQzLuiR0xeKTFdPQpY
         DHUJR6RARz6OZZ2RixjxJ/281YoPrzacCasWjq0rQaalnDyTltcVM7TAFcMZ078oh/lY
         kNwFtiBZQoiVOwIU/gIfDFKTkiarqj+9gWtxZmaYxJ7d0qIWlo3O7EJAOJ0avSGW4/VR
         ThPdvKrlOb5QSsOx3TO9kuVFrx/rYMKXjXN8xx+T2Y54v5AEJ3qzO5Ww19O48soLf0GP
         bw8HpjksJtGNQ/Mxp1t8J4zxLT3673s4HsW9HE7iI2eEpKfhAzR7CdhNXWAhubJOWBmO
         2uSA==
X-Gm-Message-State: ANhLgQ3kO4pKRDeBfaCiBeLf7qgOn/dehh6NUjEb3CYx9Qyo2uojbODX
        hD5LcV062EVYvL6irbjGCcuWbND08LI=
X-Google-Smtp-Source: ADFU+vsBAJqV5WyoQ0vbapI19L2vafQ6MJFe9Ca1ajez6r2ZxVZ9BV+rH9xoXoQl24p6gfcPO9wuHg==
X-Received: by 2002:a63:5826:: with SMTP id m38mr847545pgb.191.1583296243516;
        Tue, 03 Mar 2020 20:30:43 -0800 (PST)
Received: from santosiv.in.ibm.com ([2401:4900:16ee:7b5f:eac:4364:ff14:3aaa])
        by smtp.gmail.com with ESMTPSA id y193sm10775723pfg.162.2020.03.03.20.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 20:30:42 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH v2 0/6] Memory corruption may occur due to incorrent tlb flush
Date:   Wed,  4 Mar 2020 10:00:22 +0530
Message-Id: <20200304043028.280136-1-santosh@fossix.org>
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

Changelog:
* Send the patches with the correct format (commit sha1 upstream) for stable

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

