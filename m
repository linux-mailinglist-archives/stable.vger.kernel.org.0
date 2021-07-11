Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E693C3BC2
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhGKLYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhGKLYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:24:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5606121E;
        Sun, 11 Jul 2021 11:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626002475;
        bh=38+kG//QRw05sVpgCFDQQ3FuzHmUP37uVnZEBD2104A=;
        h=From:To:Cc:Subject:Date:From;
        b=wquyc7gYhDL4mMHsygmXctIaMEPbvmfVEn10Z+MrR4M6btfg5jzCANrtC1DbNbF0X
         LtWSXfqmXuvghy2u2SZbeTbQoOMWANJ0H1/EvldgkmwSRu+NUrWc9fOnLs5Gta2eTF
         BWp0/RD60dzFaAelsG40W7+Aw+5yi+9pZv8S4o5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.197
Date:   Sun, 11 Jul 2021 13:21:11 +0200
Message-Id: <162600247113716@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.197 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 
 arch/arm/boot/dts/dra7.dtsi            |   11 ++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi |    4 
 arch/arm/mach-omap1/pm.c               |   13 +-
 arch/arm/mach-omap1/time.c             |   10 -
 arch/arm/mach-omap1/timer32k.c         |   10 -
 arch/arm/mach-omap2/board-generic.c    |    4 
 arch/arm/mach-omap2/timer.c            |  181 ++++++++++++++++++++++-----------
 arch/x86/kvm/svm.c                     |   33 ++++--
 drivers/clk/ti/clk-7xx.c               |    1 
 drivers/gpu/drm/nouveau/nouveau_bo.c   |    4 
 drivers/scsi/sr.c                      |    2 
 drivers/xen/events/events_base.c       |   23 +++-
 fs/ext4/block_validity.c               |    4 
 include/linux/cpuhotplug.h             |    1 
 include/linux/huge_mm.h                |    8 +
 include/linux/hugetlb.h                |   16 --
 include/linux/mm.h                     |    3 
 include/linux/mmdebug.h                |   13 ++
 include/linux/pagemap.h                |   13 +-
 include/linux/rmap.h                   |    3 
 kernel/futex.c                         |    2 
 kernel/kthread.c                       |   77 +++++++++-----
 mm/huge_memory.c                       |   56 +++++-----
 mm/hugetlb.c                           |    5 
 mm/internal.h                          |   53 +++++++--
 mm/memory.c                            |   41 +++++++
 mm/page_vma_mapped.c                   |  160 ++++++++++++++++++-----------
 mm/pgtable-generic.c                   |    4 
 mm/rmap.c                              |   48 +++++---
 mm/truncate.c                          |   43 +++----
 31 files changed, 545 insertions(+), 303 deletions(-)

Alex Shi (1):
      mm: add VM_WARN_ON_ONCE_PAGE() macro

Alper Gun (1):
      KVM: SVM: Call SEV Guest Decommission if ASID binding fails

Anson Huang (1):
      ARM: dts: imx6qdl-sabresd: Remove incorrect power supply assignment

Christian König (1):
      drm/nouveau: fix dma_address check for CPU/GPU sync

David Rientjes (1):
      KVM: SVM: Periodically schedule when unregistering regions on destroy

Greg Kroah-Hartman (1):
      Linux 4.19.197

Hugh Dickins (16):
      mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
      mm/thp: make is_huge_zero_pmd() safe and quicker
      mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
      mm/thp: fix vma_address() if virtual address below file offset
      mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
      mm: page_vma_mapped_walk(): use page for pvmw->page
      mm: page_vma_mapped_walk(): settle PageHuge on entry
      mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
      mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
      mm: page_vma_mapped_walk(): crossing page table boundary
      mm: page_vma_mapped_walk(): add a level of indentation
      mm: page_vma_mapped_walk(): use goto instead of while (1)
      mm: page_vma_mapped_walk(): get vma_address_end() earlier
      mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
      mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
      mm, futex: fix shared futex pgoff on shmem huge page

Jue Wang (1):
      mm/thp: fix page_address_in_vma() on file THP tails

Juergen Gross (1):
      xen/events: reset active flag for lateeoi events later

ManYi Li (1):
      scsi: sr: Return appropriate error code when disk is ejected

Miaohe Lin (2):
      mm/rmap: remove unneeded semicolon in page_not_mapped()
      mm/rmap: use page_not_mapped in try_to_unmap()

Petr Mladek (2):
      kthread_worker: split code for canceling the delayed work timer
      kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

Tahsin Erdogan (1):
      ext4: eliminate bogus error in ext4_data_block_valid_rcu()

Tony Lindgren (3):
      clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support
      clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue
      clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940

Yang Shi (1):
      mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

afzal mohammed (1):
      ARM: OMAP: replace setup_irq() by request_irq()

