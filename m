Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792C865C34C
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbjACPux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbjACPul (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:50:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BA312633
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 07:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672760994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WC94+qRtcsQoAZV6EJBwTDdUsyIqcyvTkPy2eHYVDF8=;
        b=Dsw+a1skJrczJSjugB4GFPkVku1KQU+pKKtHoH8KoPlUobI7sRzGiWLORGW//f1JBwGbGh
        2j0ZsbqAF1iwbQCnVmDi7Z3YdwBIex4InD+PZsovaqcenjusr+JQKmr4rRA8n03XTSEnXO
        D5mJlX7dtfLNXRc7IhLo+gPf1Lib6Jo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-376-37VsZtozNn6Oaw2n9c2t2Q-1; Tue, 03 Jan 2023 10:49:53 -0500
X-MC-Unique: 37VsZtozNn6Oaw2n9c2t2Q-1
Received: by mail-wm1-f70.google.com with SMTP id bd6-20020a05600c1f0600b003d96f7f2396so17185966wmb.3
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 07:49:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WC94+qRtcsQoAZV6EJBwTDdUsyIqcyvTkPy2eHYVDF8=;
        b=d4U7ZOYvkP6dslfNjh4/W2EDz4mOohAf1KtqND9nqxtDhCEzHXrow5RfPyiBT5rlA/
         ejsl4S44AXjxUtIIx5msvKtMx1kxa52M5AHeiya72tJU1Ds+7+RiRRkthzNog6onHyeF
         z8kV+V3qQSWw1bypk44IQwTd2rcM6sUopNuD2Hzs2hhTWT7zyyuxTJxXao/QkW/uk6vh
         KS2GGAIps1qdGQ9aLn7embrC8Uk/1C03zDiPlk08cmnWgH6WG68FB1r40lO42zFE+bR/
         MBLAJqaZxKJA2kXcdlfmKX5OxR+FyUcNyU+zoWetQP+8rGdqdX4tzTApCbOrDwDhNHb5
         5iSA==
X-Gm-Message-State: AFqh2kpwtGb1YMJwMms3b/q1utENUHBn9T33ZATmmIsdQaPE3D3vxWkL
        aqsrhFWd3ok5qt0C5qy0lXzn80aqiCBW5p2/hAFn1K6UZvm1mHXir0zBXFwzFjwEVHjnyKkmrI3
        wuyCOHP/x1UXKahia
X-Received: by 2002:a05:600c:4fcf:b0:3d1:d396:1ade with SMTP id o15-20020a05600c4fcf00b003d1d3961ademr31416059wmq.9.1672760992124;
        Tue, 03 Jan 2023 07:49:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvBokw4ntbihohzRlAT/7Kd2Eqgl7eiuIEN+Pul08FB9XjA5yr3GOYK70ZuUvwnVXP0KlLXRw==
X-Received: by 2002:a05:600c:4fcf:b0:3d1:d396:1ade with SMTP id o15-20020a05600c4fcf00b003d1d3961ademr31416049wmq.9.1672760991925;
        Tue, 03 Jan 2023 07:49:51 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c458a00b003d9a86a13bfsm15382532wmo.28.2023.01.03.07.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 07:49:51 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:49:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        angus.chen@jaguarmicro.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        lulu@redhat.com, mst@redhat.com, pizhenwei@bytedance.com,
        rafaelmendsr@gmail.com, ricardo.canuelo@collabora.com,
        ruanjinjie@huawei.com, set_pte_at@outlook.com, sgarzare@redhat.com,
        shaoqin.huang@intel.com, si-wei.liu@oracle.com,
        stable@vger.kernel.org, sunnanyong@huawei.com,
        wangjianli@cdjrlc.com, wangrong68@huawei.com,
        weiyongjun1@huawei.com, yuancan@huawei.com
Subject: [GIT PULL v2] virtio,vhost,vdpa: fixes, cleanups
Message-ID: <20230103104946-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These fixes have been in next, though not as these commits.

I'd like to apologize again to contributors for missing the merge
window with new features. These by necessity have been pushed out
to the next merge window. This pull only has bugfixes.

I put automation in place to help prevent missing merge window
in the future.

The following changes since commit 1b929c02afd37871d5afb9d498426f83432e71c2:

  Linux 6.2-rc1 (2022-12-25 13:41:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to a26116c1e74028914f281851488546c91cbae57d:

  virtio_blk: Fix signedness bug in virtblk_prep_rq() (2022-12-28 05:28:11 -0500)

----------------------------------------------------------------
virtio,vhost,vdpa: fixes, cleanups

mostly fixes all over the place, a couple of cleanups.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Angus Chen (2):
      virtio_pci: modify ENOENT to EINVAL
      virtio_blk: use UINT_MAX instead of -1U

Cindy Lu (2):
      vhost_vdpa: fix the crash in unmap a large memory
      vdpa_sim_net: should not drop the multicast/broadcast packet

Colin Ian King (1):
      RDMA/mlx5: remove variable i

Davidlohr Bueso (2):
      tools/virtio: remove stray characters
      tools/virtio: remove smp_read_barrier_depends()

Dawei Li (1):
      virtio: Implementing attribute show with sysfs_emit

Dmitry Fomichev (1):
      virtio-blk: use a helper to handle request queuing errors

Eli Cohen (5):
      vdpa/mlx5: Fix rule forwarding VLAN to TIR
      vdpa/mlx5: Return error on vlan ctrl commands if not supported
      vdpa/mlx5: Fix wrong mac address deletion
      vdpa/mlx5: Avoid using reslock in event_handler
      vdpa/mlx5: Avoid overwriting CVQ iotlb

Harshit Mogalapalli (1):
      vduse: Validate vq_num in vduse_validate_config()

Jason Wang (2):
      vdpa: conditionally fill max max queue pair for stats
      vdpasim: fix memory leak when freeing IOTLBs

Rafael Mendonca (1):
      virtio_blk: Fix signedness bug in virtblk_prep_rq()

Ricardo Cañuelo (1):
      tools/virtio: initialize spinlocks in vring_test.c

Rong Wang (1):
      vdpa/vp_vdpa: fix kfree a wrong pointer in vp_vdpa_remove

Shaomin Deng (1):
      tools: Delete the unneeded semicolon after curly braces

Shaoqin Huang (2):
      virtio_pci: use helper function is_power_of_2()
      virtio_ring: use helper function is_power_of_2()

Si-Wei Liu (1):
      vdpa: merge functionally duplicated dev_features attributes

Stefano Garzarella (4):
      vringh: fix range used in iotlb_translate()
      vhost: fix range used in translate_desc()
      vhost-vdpa: fix an iotlb memory leak
      vdpa_sim: fix vringh initialization in vdpasim_queue_ready()

Wei Yongjun (1):
      virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()

Yuan Can (1):
      vhost/vsock: Fix error handling in vhost_vsock_init()

ruanjinjie (1):
      vdpa_sim: fix possible memory leak in vdpasim_net_init() and vdpasim_blk_init()

wangjianli (1):
      tools/virtio: Variable type completion

 drivers/block/virtio_blk.c                         | 35 +++++-----
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |  3 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |  5 +-
 drivers/vdpa/mlx5/core/mr.c                        | 46 +++++++------
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 78 +++++++---------------
 drivers/vdpa/vdpa.c                                | 11 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  7 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |  4 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |  7 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  3 +
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |  2 +-
 drivers/vhost/vdpa.c                               | 52 +++++++++------
 drivers/vhost/vhost.c                              |  4 +-
 drivers/vhost/vringh.c                             |  5 +-
 drivers/vhost/vsock.c                              |  9 ++-
 drivers/virtio/virtio.c                            | 12 ++--
 drivers/virtio/virtio_pci_modern.c                 |  4 +-
 drivers/virtio/virtio_ring.c                       |  2 +-
 include/uapi/linux/vdpa.h                          |  4 +-
 tools/virtio/ringtest/main.h                       | 37 +++++-----
 tools/virtio/virtio-trace/trace-agent-ctl.c        |  2 +-
 tools/virtio/virtio_test.c                         |  2 +-
 tools/virtio/vringh_test.c                         |  2 +
 23 files changed, 173 insertions(+), 163 deletions(-)

