Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A804449D2
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhKCU7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 16:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhKCU7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 16:59:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEC0C061203;
        Wed,  3 Nov 2021 13:57:11 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t7so3437094pgl.9;
        Wed, 03 Nov 2021 13:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mECX+oRSHRb92wE0BJLiQDT7bINXd0Mx3xvZ2TAianQ=;
        b=a3zMJ0D8bBR20rg7rsxGuyOTYnQN37yYwmBwC3S+6aAW0QlVa7vPvgFG2bSlRyE3ix
         elmBQuwD0+9OLU0FRPq2i/CH/8YN2GJvZv6yjPKSu4EpZFIjAld18VXACn6B+kBBvgnf
         2L9uKL5q6wZ81IJaEa6Sg531mllVK78U7wuYbjyLf5w/rlGG2yhVn16rhFEv7kyt/pD2
         fsTMFuRsbWhqrWapbCNukGsQNb2+CLWZzoK6GQFF24Q5lQ5S+2TNQGz+7lLX5FyHvoN6
         DnOOuScPioxgv2oj9Q0+yZ8xc52rZqxKJ5eEKPVTkTXUcvFyMXnuk3rBZEBDCXfWKjZt
         W/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mECX+oRSHRb92wE0BJLiQDT7bINXd0Mx3xvZ2TAianQ=;
        b=lW16Z95gz/7El5z4UtzoP59CD2Gb++G85pEZw7iozUchpAJVSyjf0hhf6XiAStF/aj
         cjica8YG5pPcyZRWcInMb/ff+LDbcuKN9OJ9MMAyOxLTDsRYiL/MzaSyTUMH1Fqk6VeU
         Pvqr77yh4SSmaJLg3hDego7ME2ffSnStDhMJ3QLRaDVhfxQii8vyhAwRAJMiqY+S6Y2p
         c/aqxopkZhhrgAg+Tht3V8GrgDq6gILEEXMVCYZqDeNUJ2OEwZCaCVWaguVvUveXkuKg
         ahVLMnqdIwFwxB4UB47LbbFZ4sdEtLlkm5z0oSVVbGuMZ8yFsTlbT3bL4XWwcZUk+JFP
         mYWw==
X-Gm-Message-State: AOAM5316KjoLQ2FW+TPqzNf78hhEs6CCt0FpVQ6UvwwafIHq+ahgU3pc
        EcGNZZZwqLssDdOwm5/o1WiZhB84Cjk=
X-Google-Smtp-Source: ABdhPJzj2664dHG+guPVVL2qUxpAjbN+Z5lTYlwZpUGV816hc1G3rRsEFzjX162YsDh52mFdzCX7zQ==
X-Received: by 2002:a63:311:: with SMTP id 17mr24881549pgd.367.1635973030309;
        Wed, 03 Nov 2021 13:57:10 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b18sm2554859pjo.31.2021.11.03.13.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:57:09 -0700 (PDT)
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
        Stefan Agner <stefan@agner.ch>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-snps-arc@lists.infradead.org (open list:SYNOPSYS ARC ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-mips@linux-mips.org (open list:MIPS),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC (32-BIT AND
        64-BIT)),
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES),
        linux-mm@kvack.org (open list:ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR)
Subject: [PATCH stable 4.14 0/2] zsmalloc MAX_POSSIBLE_PHYSMEM_BITS
Date:   Wed,  3 Nov 2021 13:57:02 -0700
Message-Id: <20211103205704.374734-1-f.fainelli@gmail.com>
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
 arch/x86/include/asm/pgtable_64_types.h     |  2 ++
 include/asm-generic/pgtable.h               | 13 +++++++++++++
 mm/zsmalloc.c                               | 13 +++++++------
 9 files changed, 34 insertions(+), 6 deletions(-)

-- 
2.25.1

