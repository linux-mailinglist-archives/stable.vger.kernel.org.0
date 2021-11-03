Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476A44449DB
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhKCVAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 17:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhKCU75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 16:59:57 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12CCC061714;
        Wed,  3 Nov 2021 13:57:20 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n8so3619432plf.4;
        Wed, 03 Nov 2021 13:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KgkJjFPSZ0RIiVDPTncldaM4JyePze+OY2e9ObDrx7w=;
        b=fhZKtKStcdupgiOxcNB95yd9Vzfj7Wn5bRHFRNaH41aSZXHw/MYS8vuFYdDSVjGm4K
         Vk9elSX27N4++k6VjEXfy2sIVKLOxMxyB6oZKk3s9tV6tV4W5vnlyNkwQh8tLs+DepJr
         kfiJxkG++oyS7MlANxu+lvPLpZ4m3PKexHbnKEBpncSvuKt/7z0IXrdLVXNiaT9CXsWk
         kG+L0bmKvi8tAwUj7vnT2ysLIq5XuorFEASFx40pKnz1z2YG015WrdXWJpBoqgBBnz6z
         y3r88+9sR4bR58ymsxwC8ERtvqTmJ34BmFAo9Lxvk5u1EwU+Vj1hwuHgqoFhrXqlTWm0
         FUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KgkJjFPSZ0RIiVDPTncldaM4JyePze+OY2e9ObDrx7w=;
        b=0NSl0q7r4k46xdZ4SBoaPT6NUu1bakuZK489irn5AzVK9FMraTIX7fdHmdnC3YZLJi
         MRB+8SGQGnZ7g+DGKXf/It7FaQP7Q2yVzpNLBxjY2LbczKofNyPUq8Mk9HZoV530JNCy
         HXUxdH6oNyEZsb/LNBgZWOJLacQKxQRp8cP2QwHe+4+DZbQklWpZl8Nfi4xVJTwLKiaD
         hZc/YvmEWqL51Ihrc29en1TT/qkTX0liordieJTfwS3tBBB3KvUOXdjVMdUsu0KN/wlJ
         ZemglQcTi85VXTddoEGH3n7RBZhSjlagp9mO7vSBNCBvwZ5ovct4OWmZTKgmxzJfT0Ie
         KL/g==
X-Gm-Message-State: AOAM532v2bknhe/PXQ0s8s1d+YQqbwGRNkUoeTMEaSKsLU95/8W3+otY
        slTWMSWL29/+2tSxW2rBJ8Haz5OocQ0=
X-Google-Smtp-Source: ABdhPJycXucVgZmu6nLmid4Wm8D7owELy7xzF4D/w2z6jkZdhxTfGUfl//WngJBDuQUwCAYMBVYNdA==
X-Received: by 2002:a17:90b:3144:: with SMTP id ip4mr17617348pjb.153.1635973039942;
        Wed, 03 Nov 2021 13:57:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n14sm2512073pgd.68.2021.11.03.13.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:57:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Arnd Bergmann <arnd@arndb.de>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Stefan Agner <stefan@agner.ch>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-snps-arc@lists.infradead.org (open list:SYNOPSYS ARC ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-mips@linux-mips.org (open list:MIPS),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC (32-BIT AND
        64-BIT)),
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES),
        linux-mm@kvack.org (open list:ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR)
Subject: [PATCH stable 4.9 0/2] zsmalloc MAX_POSSIBLE_PHYSMEM_BITS
Date:   Wed,  3 Nov 2021 13:57:12 -0700
Message-Id: <20211103205714.374801-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is a back port necessary to address the problem
reported by Stefan Agner:

https://lore.kernel.org/linux-mm/bdfa44bf1c570b05d6c70898e2bbb0acf234ecdf.1604762181.git.stefan@agner.ch/

but which ended up being addressed by Arnd in a slightly different way
from Stefan's submission.

The first patch from Kirill is back ported in order to have
MAX_POSSIBLE_PHYSMEM_BITS be acted on my the zsmalloc.c code.

Arnd Bergmann (1):
  arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Kirill A. Shutemov (1):
  mm/zsmalloc: Prepare to variable MAX_PHYSMEM_BITS

 arch/arc/include/asm/pgtable.h              |  2 ++
 arch/arm/include/asm/pgtable-2level.h       |  2 ++
 arch/arm/include/asm/pgtable-3level.h       |  2 ++
 arch/mips/include/asm/pgtable-32.h          |  3 +++
 arch/powerpc/include/asm/pte-common.h       |  2 ++
 arch/x86/include/asm/pgtable-3level_types.h |  1 +
 include/asm-generic/pgtable.h               | 13 +++++++++++++
 mm/zsmalloc.c                               | 13 +++++++------
 8 files changed, 32 insertions(+), 6 deletions(-)

-- 
2.25.1

