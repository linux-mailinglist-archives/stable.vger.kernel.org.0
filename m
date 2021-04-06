Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40D9355D11
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347211AbhDFUoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245587AbhDFUoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD82EC061756
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e12so8306563plh.7
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=P3P9lr1iVS3KUMTytwAf56LSsIDD0F1+oGbUaACPQmM=;
        b=rDH+oyj6bB7TrFXkLN7cwb18FxqszXFvxGSnIFn6TqLV6+PCR/oeibXWN22NxlOC5T
         EXT2a5+jGkWJ+nk6WNTVbG0nlAUsBqMPnhxsG5NJ5vzAEM5BU1lbColGyStDENjlI4IR
         5Ac50EppkUvqD0OIe6Z8/a75MFgmr/ExYO1bBhU8yngqQ7rnCuEPYExwCDy69upAmlLO
         zDSmFOcTensaXP6sqjNr0qz6MokjOX2PD6PVhITr1PqyV/jy250m4yUjMOxhm6zojlI/
         00JwO1g41jjUDp4SE5Ob64uTNND8CVDnz5U/CHKLM4CgNGMD9oxZdOdyapo8zCchZmoj
         t6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=P3P9lr1iVS3KUMTytwAf56LSsIDD0F1+oGbUaACPQmM=;
        b=LLbSFbbgCXUU7LhibJc1zovzyvpeXILE2zqn+v3itOS/UZ0FR/DCL8O7jK8a/zV95+
         j5cqPjG61j7nNdUKMR5a7+EgKsbrG/vm3FHdO9SmUTxQDxm9lHQvjrN2QpkrZAHcXB1q
         JqIxKrjiANxWVoJw30+ShvLgZhXeeeJ6hAS7rdWdzcP/S/l3MSOfkHXYjTDH1DHuKHj/
         MMeaK+NqeA+B6gTGwCvgdDfR3xfTbaDhHABJR/50xv8r3PLHthqXwgeDHcEdaI2wP5fp
         QZm2kRVaq4V5NboRBYG2Rf1LHNYeDm4jKfujZete4PKnBoARzQSVQ1EuLMGybaLUQu+k
         QzQw==
X-Gm-Message-State: AOAM531WympmXnJ55vgcVuZecZKqyW96cO3lewjJNX4i5jYrkRr6/3mV
        cfAGendaVyvesMvdNaTSU5LWhpyAjQJPOI5n7q7keo1i2x9Unpw+UXPgk/0e/ia7diXfdo/Cifq
        nWY3KC5878UzA11JwOpVIQ5DqMsPAm8bmlnW7EFRHGPgSORTT3D60CgcBtMM=
X-Google-Smtp-Source: ABdhPJwVuZKgKqNqhqSzZesnLxwhAHOqtYFlRraVzVc2+6+12CN4ZcJAZzVUbciVqkKQqvHzv9r7ZOsU4Q==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a63:5d22:: with SMTP id r34mr40977pgb.102.1617741853126;
 Tue, 06 Apr 2021 13:44:13 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:19 +0000
Message-Id: <20210406204326.1932888-1-jxgao@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 0/8] preserve DMA offsets when using swiotlb
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

This series of backports fixes the SWIOTLB library to maintain the
page offset when mapping a DMA address. The bug that motivated this
patch series manifested when running a 5.4 kernel as a SEV guest with
an NVMe device. However, any device that infers information from the
page offset and is accessed through the SWIOTLB will benefit from this
bug fix.

change log:
From V1 to V2:
	Updated comments to match sign-offs from original patch.
	Updated patch 5 and 7 to make sure they apply cleanly.

Jianxiong Gao (8):
  driver core: add a min_align_mask field to struct 
    device_dma_parameters
  swiotlb: factor out an io_tlb_offset helper
  swiotlb: factor out a nr_slots helper
  swiotlb: clean up swiotlb_tbl_unmap_single
  swiotlb: refactor swiotlb_tbl_map_single
  swiotlb: don't modify orig_addr in  swiotlb_tbl_sync_single
  swiotlb: respect min_align_mask
  nvme-pci: set min_align_mask

 drivers/nvme/host/pci.c     |   1 +
 include/linux/device.h      |   1 +
 include/linux/dma-mapping.h |  16 +++
 include/linux/swiotlb.h     |   1 +
 kernel/dma/swiotlb.c        | 260 ++++++++++++++++++++----------------
 5 files changed, 162 insertions(+), 117 deletions(-)

-- 
2.27.0

