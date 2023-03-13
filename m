Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97D06B6F7E
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 07:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCMGc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 02:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCMGc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 02:32:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5094A1CF
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 23:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678689105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uP6OPkCE+3XV/LM8KCZyJuOxYGuLRyW9hCJ+ior5xWo=;
        b=cuhXfW1TvjgJ+Tp1kEqGeasMdbcT0EI+OSChNuTAO9mToMezh5y9dSxkNQ7CnZOfgyF8kM
        0ZPZn0zkwhZx54I440D4iPZEKv3cVdizjpEkcpTmgo6TykZwG7CEQKtMjd0jHrw+v99F1Q
        uNLCgPlBCY9CqahOmsrxYppaag33EQM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-JZ04ZSOqOVGhNkn-ZjFBpQ-1; Mon, 13 Mar 2023 02:31:43 -0400
X-MC-Unique: JZ04ZSOqOVGhNkn-ZjFBpQ-1
Received: by mail-wm1-f72.google.com with SMTP id l20-20020a05600c1d1400b003e10d3e1c23so7320879wms.1
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 23:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678689102;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uP6OPkCE+3XV/LM8KCZyJuOxYGuLRyW9hCJ+ior5xWo=;
        b=QCxMU8ilWKdLlEpKV+a3NesTGc/CcevpSq6XrKKq6JfchMJ8YKX/qLzRaczNqO8xDK
         zmrsJCBdV0WeYzmLThfCaQ5S1m1MShCjX0KkxGjNIJcCELQC1+o1QkB2JQ6iAp9roPOm
         JVzcBMl7+WcD8k5Kq4KBO6VcEftRb5Fnyf8OkLqSl/QVmz2H6329DsUtHL5yuj5pH9Pr
         eVo5CqSvAZmH11EWG3P9mO3Q3Hpz1ljwigEt0K4mfIEzpwlGKoFhEdtdag8NN0STXaDD
         Ns8bmuaV10kb9vv6wQcZjdDX28jEEp2wVJ+t+5EfWmCiRdslY/unFxjnrr2ams/MBcaR
         92PQ==
X-Gm-Message-State: AO0yUKVjOsPZDbcac2oJmPVd26+luCQgX6NhLvkNl15P1tyhho8dA1u2
        39tIEFWXLJZb5UgrQB3bLhHbQE/2+RqvQJeDnIXHtqlvVhmndC7IJHRbHT+umRcmO/rVliNJ8Bo
        Kk3Vgl6MHGFGz66cp
X-Received: by 2002:a05:600c:a4c:b0:3e2:d3:b2b6 with SMTP id c12-20020a05600c0a4c00b003e200d3b2b6mr7122728wmq.14.1678689102683;
        Sun, 12 Mar 2023 23:31:42 -0700 (PDT)
X-Google-Smtp-Source: AK7set/m0d39bBRh2a53avY9wpGXBQ5w6WVRLPsP4dfir1NMRR7vQctreaympSD9w7L/W8ZMq9gTgQ==
X-Received: by 2002:a05:600c:a4c:b0:3e2:d3:b2b6 with SMTP id c12-20020a05600c0a4c00b003e200d3b2b6mr7122711wmq.14.1678689102415;
        Sun, 12 Mar 2023 23:31:42 -0700 (PDT)
Received: from redhat.com ([2.52.26.7])
        by smtp.gmail.com with ESMTPSA id f25-20020a7bc8d9000000b003ed24653333sm1899615wml.33.2023.03.12.23.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 23:31:41 -0700 (PDT)
Date:   Mon, 13 Mar 2023 02:31:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@amd.com,
        jasowang@redhat.com, leiyang@redhat.com, lulu@redhat.com,
        mst@redhat.com, rongtao@cestc.cn, si-wei.liu@oracle.com,
        stable@vger.kernel.org
Subject: [GIT PULL] virtio,vhost,vdpa: bugfixes
Message-ID: <20230313023139-mutt-send-email-mst@kernel.org>
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

The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4cc6:

  Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to ae43c20da2a77c508715a9c77845b4e87e6a1e25:

  tools/virtio: Ignore virtio-trace/trace-agent (2023-03-13 02:29:12 -0400)

----------------------------------------------------------------
virtio,vhost,vdpa: bugfixes

Some fixes accumulated so far.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Cindy Lu (1):
      vp_vdpa: fix the crash in hot unplug with vp_vdpa

Eugenio Pérez (1):
      vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready

Gautam Dawar (1):
      vhost-vdpa: free iommu domain after last use during cleanup

Rong Tao (1):
      tools/virtio: Ignore virtio-trace/trace-agent

Si-Wei Liu (1):
      vdpa/mlx5: should not activate virtq object when suspended

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  1 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  6 +++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c   | 11 +++++++++++
 drivers/vdpa/virtio_pci/vp_vdpa.c  |  2 +-
 drivers/vhost/vdpa.c               |  3 ++-
 tools/virtio/.gitignore            |  1 +
 6 files changed, 21 insertions(+), 3 deletions(-)

