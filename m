Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452D03256CE
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhBYTgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234913AbhBYTfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 14:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614281625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=J8XckA0wuy/u0dP7Chp3yO58HxOiKtqQRaFNCMmqR6E=;
        b=OcHT2Bk4AT05myZmeUIywWwmJdsXEKJorUVt3Vr995IeGbrVkKPnUGKTNqLUtbQQ31KSNZ
        cu5QJnF7lPSLc+h1tyby/m4IiOTA0DTz9B98bDfNM4hqFNmoD7o3M0DKwkYDfCDpLjQyBl
        rW8XGRnKnjBeHthYcUwbDfIb7WW7Rlg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-vRB41dlCMeuWiGkWyfPvuQ-1; Thu, 25 Feb 2021 14:33:43 -0500
X-MC-Unique: vRB41dlCMeuWiGkWyfPvuQ-1
Received: by mail-ed1-f70.google.com with SMTP id y90so3395778ede.8
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 11:33:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=J8XckA0wuy/u0dP7Chp3yO58HxOiKtqQRaFNCMmqR6E=;
        b=tu7OZsqPAcnORGJoVN9NVQ9Cj6lhffPKE8v8EWkKDwgMTTnFg5GlTCloRVFrjs87Lw
         nbeO+Qc/HNjmaDs2BBLpMjxbSWoVnTE5SHKcqcFkLjUnwzDCB2E5a8eoLnwu+Fj5Vgo2
         FRn7Gmz8kyx21K0sNJyzeq/gIN5HzHPAeV2aqDN4z9tAKP9AtDN2ixUG3PzX40VXelqb
         KIqxFkcEhs73zSkzzFfBoYSE5TtXLxJlR09xqnZupZ32TiSeKyg67hMfsEaNFLd5vquL
         GBHc03Sa3evfuWl/VedljUfWjpOj1HW6UyXaL9dMwe2NIy5ksyGPCJwzNlkN8Nb1EPg6
         XMZQ==
X-Gm-Message-State: AOAM532RlHDyOzIOIRpBwqQiX+g0qnW8wU/sTjxoFIt+fYmchY4AE/lK
        EL9xVktPGDXLeLN3fo9QFdjawTyd1AuTy8GTjznzb4K4h6qqPUZ1DL7j5TvZyuou42oZ8psLCce
        yGu/W7n8Rs8YnkwpB
X-Received: by 2002:a17:907:2113:: with SMTP id qn19mr4214702ejb.98.1614281619064;
        Thu, 25 Feb 2021 11:33:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2dN9ZzfgwQ9M65gsI//PlQJrl1Zvqctla4lD8bDjF0K4fbGkjn6jK5ahnGYupXSe2W6FPQw==
X-Received: by 2002:a17:907:2113:: with SMTP id qn19mr4214672ejb.98.1614281618920;
        Thu, 25 Feb 2021 11:33:38 -0800 (PST)
Received: from redhat.com (212.116.168.114.static.012.net.il. [212.116.168.114])
        by smtp.gmail.com with ESMTPSA id ca26sm4215205edb.4.2021.02.25.11.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:33:38 -0800 (PST)
Date:   Thu, 25 Feb 2021 14:33:33 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        anders.roxell@linaro.org, arnd@arndb.de,
        aruna.ramakrishna@oracle.com, colin.xu@intel.com, david@redhat.com,
        dongli.zhang@oracle.com, edumazet@google.com, elic@nvidia.com,
        gustavoars@kernel.org, jasowang@redhat.com, joe.jin@oracle.com,
        joseph.qi@linux.alibaba.com, linux@roeck-us.net,
        mathias.crombez@faurecia.com, mst@redhat.com,
        naresh.kamboju@linaro.org, parav@nvidia.com, sgarzare@redhat.com,
        stable@vger.kernel.org, syzkaller@googlegroups.com,
        tiantao6@hisilicon.com, vasyl.vavrychuk@opensynergy.com,
        xianting_tian@126.com
Subject: [GIT PULL] virtio: features, fixes
Message-ID: <20210225143333-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are a couple new drivers and support for the new management
interface for mlx under review now. I figured I'll send them separately
if review is done in time, lots of people are waiting for the vdpa tool
patches to I want to make sure they make this release.

The following changes since commit f40ddce88593482919761f74910f42f4b84c004b:

  Linux 5.11 (2021-02-14 14:32:24 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 16c10bede8b3d8594279752bf53153491f3f944f:

  virtio-input: add multi-touch support (2021-02-23 07:52:59 -0500)

----------------------------------------------------------------
virtio: features, fixes

new vdpa features to allow creation and deletion of new devices
virtio-blk support per-device queue depth
fixes, cleanups all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Colin Xu (1):
      virtio_input: Prevent EV_MSC/MSC_TIMESTAMP loop storm for MT.

Dongli Zhang (1):
      vhost scsi: alloc vhost_scsi with kvzalloc() to avoid delay

Gustavo A. R. Silva (1):
      virtio_net: Fix fall-through warnings for Clang

Jason Wang (17):
      virtio-pci: do not access iomem via struct virtio_pci_device directly
      virtio-pci: split out modern device
      virtio-pci-modern: factor out modern device initialization logic
      virtio-pci-modern: introduce vp_modern_remove()
      virtio-pci-modern: introduce helper to set config vector
      virtio-pci-modern: introduce helpers for setting and getting status
      virtio-pci-modern: introduce helpers for setting and getting features
      virtio-pci-modern: introduce vp_modern_generation()
      virtio-pci-modern: introduce vp_modern_set_queue_vector()
      virtio-pci-modern: introduce vp_modern_queue_address()
      virtio-pci-modern: introduce helper to set/get queue_enable
      virtio-pci-modern: introduce helper for setting/geting queue size
      virtio-pci-modern: introduce helper for getting queue nums
      virtio-pci-modern: introduce helper to get notification offset
      virito-pci-modern: rename map_capability() to vp_modern_map_capability()
      virtio-pci: introduce modern device module
      virtio_vdpa: don't warn when fail to disable vq

Jiapeng Zhong (1):
      virtio-mem: Assign boolean values to a bool variable

Joseph Qi (1):
      virtio-blk: support per-device queue depth

Mathias Crombez (1):
      virtio-input: add multi-touch support

Parav Pandit (6):
      vdpa_sim_net: Make mac address array static
      vdpa: Extend routine to accept vdpa device name
      vdpa: Define vdpa mgmt device, ops and a netlink interface
      vdpa: Enable a user to add and delete a vdpa device
      vdpa: Enable user to query vdpa device info
      vdpa_sim_net: Add support for user supported devices

Stefano Garzarella (1):
      vdpa/mlx5: fix param validation in mlx5_vdpa_get_config()

Xianting Tian (1):
      virtio_mmio: fix one typo

 drivers/block/virtio_blk.c             |  11 +-
 drivers/net/virtio_net.c               |   1 +
 drivers/vdpa/Kconfig                   |   1 +
 drivers/vdpa/ifcvf/ifcvf_main.c        |   2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c      |   4 +-
 drivers/vdpa/vdpa.c                    | 503 ++++++++++++++++++++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c       |   3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.h       |   2 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c   | 100 ++++--
 drivers/vhost/scsi.c                   |   9 +-
 drivers/virtio/Kconfig                 |   9 +
 drivers/virtio/Makefile                |   1 +
 drivers/virtio/virtio_input.c          |  26 +-
 drivers/virtio/virtio_mem.c            |   2 +-
 drivers/virtio/virtio_mmio.c           |   2 +-
 drivers/virtio/virtio_pci_common.h     |  22 +-
 drivers/virtio/virtio_pci_modern.c     | 504 ++++-----------------------
 drivers/virtio/virtio_pci_modern_dev.c | 599 +++++++++++++++++++++++++++++++++
 drivers/virtio/virtio_vdpa.c           |   3 +-
 include/linux/vdpa.h                   |  44 ++-
 include/linux/virtio_pci_modern.h      | 111 ++++++
 include/uapi/linux/vdpa.h              |  40 +++
 22 files changed, 1492 insertions(+), 507 deletions(-)
 create mode 100644 drivers/virtio/virtio_pci_modern_dev.c
 create mode 100644 include/linux/virtio_pci_modern.h
 create mode 100644 include/uapi/linux/vdpa.h

