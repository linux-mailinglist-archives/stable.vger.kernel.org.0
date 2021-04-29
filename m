Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9FB36EEF3
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhD2Rf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhD2Rf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:26 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C25C06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:38 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id p196-20020a37a6cd0000b02902e41c0c90bbso20936149qke.5
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QAVNMweXGt8q8BHuJEXcz4R5TurZqYKgs9A3HuDurK4=;
        b=Db8hMjtc0cZvUpbpdZ33JXtLTsq6j22a4rD//NYgQpxlNqzJTYj++bygB78Rt+/Sp+
         N1CMNNisPMaDGtUYe6lQUoN/OHZJ7e8rrYLOWGViuulzjH75yhrKMjiXU1wMhkJ3YtHQ
         GTkzfNHOLVzgnzN/8D6R9yxCd6b2fM5+d014B6sSGHghysgUcJkWP9uEILG0C/AYAfpj
         cc/Cl6SQpM1PlTWfSVUvSZecnnaoZbPFmCNq4TiF2p2WNrE+sTUoeTpVRpLe4ef2T0UL
         cWo6eybpw2JgV0U36aI7MRlsL3B0VB0hBAZlKO+CRNhUH8D5jvfn3ZiJ+9TU+WR8FVIE
         Msgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QAVNMweXGt8q8BHuJEXcz4R5TurZqYKgs9A3HuDurK4=;
        b=YcDW/jZgy1FFQtHjEEwa9hBIhRrpcT1t5bgsX95X3kdFyk7xllPoy2RUYd0bQuWKxa
         EfNCVz+z5ga95V/rV6WKyPSsFu7TPApsz+flmh2RL5KQ+bx/G3xBK6adhuIsXfOVNm/T
         5tzCOpxm+P/UjK6u7Zd2SGgTWJgNpZUmwpci5Bqv9vWRxa+5pWgaOomUr5UowhXSa7Xd
         Rbi0JMhJleOeDly1fN7GXqweyDjzMdorbCsr3SKzfPcCc02wblYXnv3jP6fD9yvwXfMw
         oLN9J6scS4lM9uCam9qDz+yhAaMywNlgt3+obiT6NZy6TFcM66y/I8KcZewDymGFVufN
         mpXA==
X-Gm-Message-State: AOAM533fJpqT1UWxP11DIcE8HWV80K6ocjLfHgwkw9SgYw+eQ2NREUiA
        0VwWykoWcgEoFvjzXEeaWb21swNoYbEVfGjFri+pJ3xNOiVj7x2VbH71AVZZw7EHlSYwqfKWfjV
        cAiu/YMzQZvO0Ratcvi1khU7azvGXf4OapAilwhgEZMedf3NfekpGL6dBkx4=
X-Google-Smtp-Source: ABdhPJz3FMhEzGb4Qc1OVvXa+fmJ+KGA9hUyCz0Q8onWwUt7wqP7bKD0bOPhyjbTUkbOMrpfCVBjcZvrPw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a0c:8027:: with SMTP id 36mr870324qva.3.1619717677717;
 Thu, 29 Apr 2021 10:34:37 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:06 +0000
Message-Id: <20210429173315.1252465-1-jxgao@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 0/9] preserve DMA offsets when using swiotlb
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We observed several NVMe failures when running with SWIOTLB. The root
cause of the issue is that when data is mapped via SWIOTLB, the address
offset is not preserved. Several device drivers including the NVMe
driver relies on this offset to function correctly.

Even though we discovered the error when running using AMD SEV, we have
reproduced the same error in Rhel 8 without SEV. By adding swiotlb=force
option to the boot command line parameter, NVMe funcionality is
impacted. For example formatting a disk into xfs format returns an
error.


----
Changes in v2:
Rebased patches to 5.10.33
Updated patch description to correct format.

Jianxiong Gao (9):
  driver core: add a min_align_mask field to struct
    device_dma_parameters
  swiotlb: add a IO_TLB_SIZE define
  swiotlb: factor out an io_tlb_offset helper
  swiotlb: factor out a nr_slots helper
  swiotlb: clean up swiotlb_tbl_unmap_single
  swiotlb: refactor swiotlb_tbl_map_single
  swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
  swiotlb: respect min_align_mask
  nvme-pci: set min_align_mask

 drivers/nvme/host/pci.c     |   1 +
 include/linux/device.h      |   1 +
 include/linux/dma-mapping.h |  16 +++
 include/linux/swiotlb.h     |   1 +
 kernel/dma/swiotlb.c        | 259 ++++++++++++++++++++----------------
 5 files changed, 164 insertions(+), 114 deletions(-)

-- 
2.31.1.498.g6c1eba8ee3d-goog

