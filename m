Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B833A278E0A
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgIYQTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729538AbgIYQTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:19:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD4AC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r8so3075896yba.21
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=rB1M2+jw46oJZFo3o6Bjb4bDjXfHJeCjXxp7AMatbs0=;
        b=FOK90MlZKohGf24T64kRz4sAt4jrMYho+BfCHExExLuFOBWHt3WNpvGCb3x3dCag0T
         cejzcqbO9/KKIdMVTTmXHottM09M4rGlJR+cWMy/+7fitZCwKp403yaK0JRRvzNetoVz
         tbzolL81V+iafGeGmV7RdhIhVtNKNoURIMNK8aPsfL7LuEJe7UT1IFQz4+kcDO/gGOUZ
         oTpNQz6kU8BUuO8yUaSP2qDEIktuBgHE8bsqNEUrjOiqzqNX7XqHCCNX27v31gFTiH2n
         rRnd3MLhGafiZKZ5h4/VZdZZ8sHNIZduhh8cjof/NO5qw7UWD7j+Vp8rmsH6yTKWWehU
         EsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=rB1M2+jw46oJZFo3o6Bjb4bDjXfHJeCjXxp7AMatbs0=;
        b=j+xLUzg0BYM87P7eUR3SObzDvcbl2nfw11eAFKSOMDplmrRBNVpRGYpSnYvLQRKJYH
         v7c70LmDODLYJRDOtD4CuvDQ0WW7O60ey0uX58+eoJ1kTQ0Owt7ch13z8l8VJM8zz+TM
         KUdAJRWcb1j3en0wnG1/eAue9ygKgptczrdfyCrLdLTc2LzyUzLXeQNV03WC1it9hGrG
         dNxOYiSZsCqRVm6m5ImkWteQQRqnNOevoTioqlgWVRBULZVN/SUA5JYkKYmrXBaj84j/
         pYCrIYkdFSIW08i87Wp1xa9BWXzDltlHZeKbqzuef7K7vAo6Olqu8f4ZJYcgHMuzJ2AB
         gH5w==
X-Gm-Message-State: AOAM530fBn6csTKs039HZFBzo3jJczHITe1ua1pAvqOoKDokHUytz9A0
        RF/T627W0MjHWGmuZ0F5yfBVlb0Yv8AYm7rQ2JlbOGBq7coRe2874Gas7VUUTfCgvgnlGbokroe
        SxwCDY2JoSfIgHER2iGLymckwhvYMYTHuYYpzbhN5532DP1b7HqBmUcHT+Zd9Rg==
X-Google-Smtp-Source: ABdhPJySYBdFXdZI1M2BPxF7NCmZ+yXMK9pjma63AZtP/RvcEWgqs21Wcyzu90P4uM6lyR0igeLdFZhQs34=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a25:3618:: with SMTP id d24mr6680648yba.385.1601050786748;
 Fri, 25 Sep 2020 09:19:46 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:46 -0700
Message-Id: <20200925161916.204667-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 00/30 for 5.4] Backport unencrypted non-blocking DMA allocations
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently SEV enabled guests hit might_sleep() warnings when a driver (nvme in
this case) allocates through the DMA API in a non-blockable context. Making
these unencrypted non-blocking DMA allocations come from the coherent pools
prevents this BUG.

BUG: sleeping function called from invalid context at mm/vmalloc.c:1710
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3383, name: fio
2 locks held by fio/3383:
 #0: ffff93b6a8568348 (&sb->s_type->i_mutex_key#16){+.+.}, at: ext4_file_write_iter+0xa2/0x5d0
 #1: ffffffffa52a61a0 (rcu_read_lock){....}, at: hctx_lock+0x1a/0xe0
CPU: 0 PID: 3383 Comm: fio Tainted: G        W         5.5.10 #14
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 dump_stack+0x98/0xd5
 ___might_sleep+0x175/0x260
 __might_sleep+0x4a/0x80
 _vm_unmap_aliases+0x45/0x250
 vm_unmap_aliases+0x19/0x20
 __set_memory_enc_dec+0xa4/0x130
 set_memory_decrypted+0x10/0x20
 dma_direct_alloc_pages+0x148/0x150
 dma_direct_alloc+0xe/0x10
 dma_alloc_attrs+0x86/0xc0
 dma_pool_alloc+0x16f/0x2b0
 nvme_queue_rq+0x878/0xc30 [nvme]
 __blk_mq_try_issue_directly+0x135/0x200
 blk_mq_request_issue_directly+0x4f/0x80
 blk_mq_try_issue_list_directly+0x46/0xb0
 blk_mq_sched_insert_requests+0x19b/0x2b0
 blk_mq_flush_plug_list+0x22f/0x3b0
 blk_flush_plug_list+0xd1/0x100
 blk_finish_plug+0x2c/0x40
 iomap_dio_rw+0x427/0x490
 ext4_file_write_iter+0x181/0x5d0
 aio_write+0x109/0x1b0
 io_submit_one+0x7d0/0xfa0
 __x64_sys_io_submit+0xa2/0x280
 do_syscall_64+0x5f/0x250
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Christoph Hellwig (9):
  dma-direct: remove __dma_direct_free_pages
  dma-direct: remove the dma_handle argument to __dma_direct_alloc_pages
  dma-direct: provide mmap and get_sgtable method overrides
  dma-mapping: merge the generic remapping helpers into dma-direct
  dma-direct: consolidate the error handling in dma_direct_alloc_pages
  xtensa: use the generic uncached segment support
  dma-direct: make uncached_kernel_address more general
  dma-mapping: DMA_COHERENT_POOL should select GENERIC_ALLOCATOR
  dma-pool: fix coherent pool allocations for IOMMU mappings

David Rientjes (13):
  dma-remap: separate DMA atomic pools from direct remap code
  dma-pool: add additional coherent pools to map to gfp mask
  dma-pool: dynamically expanding atomic pools
  dma-direct: atomic allocations must come from atomic coherent pools
  dma-pool: add pool sizes to debugfs
  x86/mm: unencrypted non-blocking DMA allocations use coherent pools
  dma-pool: scale the default DMA coherent pool size with memory
    capacity
  dma-pool: decouple DMA_REMAP from DMA_COHERENT_POOL
  dma-direct: always align allocation size in dma_direct_alloc_pages()
  dma-direct: re-encrypt memory if dma_direct_alloc_pages() fails
  dma-direct: check return value when encrypting or decrypting memory
  dma-direct: add missing set_memory_decrypted() for coherent mapping
  dma-mapping: warn when coherent pool is depleted

Geert Uytterhoeven (1):
  dma-pool: fix too large DMA pools on medium memory size systems

Huang Shijie (1):
  lib/genalloc.c: rename addr_in_gen_pool to gen_pool_has_addr

Nicolas Saenz Julienne (6):
  dma-direct: provide function to check physical memory area validity
  dma-pool: get rid of dma_in_atomic_pool()
  dma-pool: introduce dma_guess_pool()
  dma-pool: make sure atomic pool suits device
  dma-pool: do not allocate pool memory from CMA
  dma/direct: turn ARCH_ZONE_DMA_BITS into a variable

 Documentation/core-api/genalloc.rst    |   2 +-
 arch/Kconfig                           |   8 +-
 arch/arc/Kconfig                       |   1 -
 arch/arm/Kconfig                       |   1 -
 arch/arm/mm/dma-mapping.c              |   8 +-
 arch/arm64/Kconfig                     |   1 -
 arch/arm64/mm/init.c                   |   9 +-
 arch/ia64/Kconfig                      |   2 +-
 arch/ia64/kernel/dma-mapping.c         |   6 -
 arch/microblaze/Kconfig                |   3 +-
 arch/microblaze/mm/consistent.c        |   2 +-
 arch/mips/Kconfig                      |   7 +-
 arch/mips/mm/dma-noncoherent.c         |   8 +-
 arch/nios2/Kconfig                     |   3 +-
 arch/nios2/mm/dma-mapping.c            |   2 +-
 arch/powerpc/include/asm/page.h        |   9 -
 arch/powerpc/mm/mem.c                  |  20 +-
 arch/powerpc/platforms/Kconfig.cputype |   1 -
 arch/s390/include/asm/page.h           |   2 -
 arch/s390/mm/init.c                    |   1 +
 arch/x86/Kconfig                       |   1 +
 arch/xtensa/Kconfig                    |   6 +-
 arch/xtensa/include/asm/platform.h     |  27 ---
 arch/xtensa/kernel/Makefile            |   3 +-
 arch/xtensa/kernel/pci-dma.c           | 121 ++---------
 drivers/iommu/dma-iommu.c              |   5 +-
 drivers/misc/sram-exec.c               |   2 +-
 include/linux/dma-direct.h             |  12 +-
 include/linux/dma-mapping.h            |   7 +-
 include/linux/dma-noncoherent.h        |   4 +-
 include/linux/genalloc.h               |   2 +-
 kernel/dma/Kconfig                     |  20 +-
 kernel/dma/Makefile                    |   1 +
 kernel/dma/direct.c                    | 224 ++++++++++++++++----
 kernel/dma/mapping.c                   |  45 +----
 kernel/dma/pool.c                      | 270 +++++++++++++++++++++++++
 kernel/dma/remap.c                     | 176 +---------------
 lib/genalloc.c                         |   5 +-
 38 files changed, 564 insertions(+), 463 deletions(-)
 create mode 100644 kernel/dma/pool.c

-- 
2.28.0.618.gf4bc123cb7-goog

