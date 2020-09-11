Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD1E2660D4
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgIKOAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgIKNVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:21:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CCC92244C;
        Fri, 11 Sep 2020 12:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829165;
        bh=VhHZzxYJ8nkNA9SGFQ+ilawWcnvt8a/KgqfCYjaOi7o=;
        h=From:To:Cc:Subject:Date:From;
        b=aHgsZ+4rOP2B7N6zHS3k2OtVWXaHvvBxrg2H8/Xko6nVXH7qvXObS+7Mj+htdCulZ
         9g7T0JQHIJcPKUbyo826+qyzOsoSb900puOAmuyT8vBs1L90u2wv1NPSMr0kiUK5Ft
         S5Bv4zD/9rRkLuyoBNTiSfqn/M/K99fp7zbOSWXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/12] 4.14.198-rc1 review
Date:   Fri, 11 Sep 2020 14:46:54 +0200
Message-Id: <20200911122458.413137406@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.198-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.198-rc1
X-KernelTest-Deadline: 2020-09-13T12:24+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.198 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.198-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.198-rc1

Jakub Kicinski <kuba@kernel.org>
    net: disable netpoll on fresh napis

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tipc: fix shutdown() of connectionless socket

Xin Long <lucien.xin@gmail.com>
    sctp: not disable bh in the whole sctp_get_port_local()

Kamil Lorenc <kamil@re-ws.pl>
    net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Paul Moore <paul@paul-moore.com>
    netlabel: fix problems with mapping removal

Jakub Kicinski <kuba@kernel.org>
    bnxt: don't enable NAPI until rings are ready

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Fix SR-IOV VF handling with MMIO blocking

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Invalidate mmaps and block MMIO access on disabled memory

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Fault mmaps to enable vma tracking

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Support faulting PFNMAP vmas

Jens Axboe <axboe@kernel.dk>
    block: ensure bdi->io_pages is always initialized

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA; firewire-tascam: exclude Tascam FE-8 from detection


-------------

Diffstat:

 Makefile                                  |   4 +-
 block/blk-core.c                          |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   9 +-
 drivers/net/usb/dm9601.c                  |   4 +
 drivers/vfio/pci/vfio_pci.c               | 352 +++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_config.c        |  51 ++++-
 drivers/vfio/pci/vfio_pci_intrs.c         |  14 ++
 drivers/vfio/pci/vfio_pci_private.h       |  16 ++
 drivers/vfio/pci/vfio_pci_rdwr.c          |  29 ++-
 drivers/vfio/vfio_iommu_type1.c           |  36 ++-
 net/core/dev.c                            |   3 +-
 net/core/netpoll.c                        |   2 +-
 net/netlabel/netlabel_domainhash.c        |  59 ++---
 net/sctp/socket.c                         |  16 +-
 net/tipc/socket.c                         |   9 +-
 sound/firewire/tascam/tascam.c            |  30 ++-
 16 files changed, 539 insertions(+), 97 deletions(-)


