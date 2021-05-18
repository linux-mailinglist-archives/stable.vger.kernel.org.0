Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3371A3882A3
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhERWTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236372AbhERWTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:19:55 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B077C061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:18:36 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a8-20020a62d4080000b029028db7db58adso6852848pfh.22
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NafLFsvwsIveyGgcKliZ/udqg19MbSkJE5LsWy1DxvI=;
        b=UjWvhiRYskyEPIWwfnF3MRlU/CztnyP0VOxHZf1Ao/xPzPmg2s8eAnrd0Kf1GTKSFf
         taKtBDw0ZH1Bmr0tl9Hc1pCcqcfexD2XYppe+o0HwGoY0GGn6SvNJFivR/c5xhiMyp94
         BNRMxnLTcEXxjKZwWPNsNNq4rfw05uNadaoh0R5pVGl6HVEGA4snvh+PkIjcUvK92x2C
         Qtjk8MlWuN3tszhBYUIGS67D8t/qTkKY1yVXPwKaB/LMuqAoq1rVhgK9bJcvBgikw9mT
         N2RXTscQZ9+2IVXPWCOaIO1h1TBYK5akESBzBHaXGa4zXfXG9QOHYYBo3u6/7cTpa+Oa
         0rDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NafLFsvwsIveyGgcKliZ/udqg19MbSkJE5LsWy1DxvI=;
        b=si8SSx5ZFCdOlBxj/ds4sIFJPmYOYJ0I5QHHtHRKEiAq+KbCGWPKIwphePqaWNNSVu
         W87aPvJhgXkFKEdGaGSNZUjz5yqCQ+rZtcuJJPTNbO2vdcxLP4y5eZa/2zzT2lEgJtVC
         UIlUGI1RC2uvqV3F1SJGLA0MY11r3aFoySOh3fI1oODxaz9N3hRU9NsS+zUqxfoSi7WG
         U5+KGvxJs5IO1YceJ7Ph9PmwbGTcHUvMT1Nbip6KmoDs6pxy90MWbkNITuFrhEuahNBH
         4FyJXCa0EsiSXXQcipz0Wub6V20hp2L7AuuLMdOJ6/DnUgagW4C5yBxLuVN7/va4inRZ
         zUjw==
X-Gm-Message-State: AOAM5336vbLP9sRI/jXB/hUhr5YGP1n0WtdmEZEJcTCuirgMNkoaNyg9
        Q2843NnJcI6pl5sKU6JEuENe08rQMHpJvaRepUGOMsCL57mjgxP+mqTWlkrcHSPAPkyuq2ga1SF
        7m3HpnPz53zskjKKZV0B3ErgairHjA3ckCaJ0nMqj3jrINUKBliY3vq7aETw=
X-Google-Smtp-Source: ABdhPJyvNZGQ070xX+ZXPlBUEUo/aU2QAx5QpWl3omBA8/b85aClGncyF3La7n0ttB/rb425tMUzaNmDIg==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:bd94:b029:ef:2953:918e with SMTP id
 q20-20020a170902bd94b02900ef2953918emr7048180pls.63.1621376315770; Tue, 18
 May 2021 15:18:35 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:09 +0000
Message-Id: <20210518221818.2963918-1-jxgao@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 0/9] preserve DMA offsets when using swiotlb
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
Rebased patches to 5.4.115
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
 kernel/dma/swiotlb.c        | 269 ++++++++++++++++++++----------------
 5 files changed, 169 insertions(+), 119 deletions(-)

-- 
2.31.1.751.gd2f1c929bd-goog

