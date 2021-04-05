Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1B23547F4
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbhDEVCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbhDEVCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:02:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99689C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:02:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q4so3001384plr.11
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uEn/zQniiDhohv66WDjksnSG5JiSVhPmvWt79UkOhJQ=;
        b=qrNZSv1aZ2r6E2AUG+lqKBeRcGMBYWk8fG5P58Dejp85KMXfk6Fa5xFOS4srZF21PQ
         rTd+FI2r9p3l9VTvOswSuug51MJ2D6oxxW9nftMIuhK+qsr4fNRD0e7sF6mBLrtpaQVB
         cakvWqwH/kEMrofi/MiIEmJqK2lNkTQRs/WWmcAVXiBXNR3MMvFrDuGMqQVcaWiz/tjH
         whH8tpp3whZm0ezpetzP4grM2V6IkEr2h1DTjZM4Qw+UziEOH70VPUrS5bP6c2jYDlDF
         eItuDYGZnWR4tmzi6V2bHoIdVvZJFcg3TSgnT3ZzHvAPNowPyDxuarYsQ8fIgkIcFHID
         XEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uEn/zQniiDhohv66WDjksnSG5JiSVhPmvWt79UkOhJQ=;
        b=mfXe3z319PBu/1Mc61599vvoOof8JUaYPGyCcH00PFVzANvFTw0wntqTdbir0Zb1a1
         DBO75oZa4LWmXVHXBbZX5InWTEesGtcvNrhLOpwVklgq7TmJ/1cTK/JHDObTXQjdqp6G
         0vUZ3QRovtkXEkE5i4LI9vqrWwGIk7FtIoXY76nauvpur5rZ0Sq5uKCmJmZlmv3rgs1w
         1O9cVptuqJC8DOQeM1dFrUuYwy+9QpYIwEJm29qQFX6k/IIU4dZL1537vUn+B0JWcX65
         w2owSTYWfTp+X+lS/dv2R7z0rZxtwfLsnMburh2iNW/XOyoHWJKGJukba+3tGOP8SCpv
         Lm4A==
X-Gm-Message-State: AOAM533zBiW462BM4Fyz29V/Sq5vhyW2KaWehXZD/e5b66meGQFOouk4
        vPip/gnafgbbdpzPdSkDs4dRKgUt9+FiUdZWbiejG39e2U6Pwa1xGFL8q6mhIwJK0zBOIZbOqQz
        ZTjyRQDAxVQcUcS9luw0U/c/3zjtxUKdM4IiKBOF28xaIXa7aq3dbqDPSP18=
X-Google-Smtp-Source: ABdhPJz5QLSh149pYQfQMwAMkgdRS1y+nMCVvjWLgmPWJ6Mx3u61iMS787wAS18Dm11OgiN7IRqQeFmDbw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:6ac3:b029:e6:c6a3:a697 with SMTP id
 i3-20020a1709026ac3b02900e6c6a3a697mr26353340plt.2.1617656564034; Mon, 05 Apr
 2021 14:02:44 -0700 (PDT)
Date:   Mon,  5 Apr 2021 21:02:22 +0000
Message-Id: <20210405210230.1707074-1-jxgao@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
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
 kernel/dma/swiotlb.c        | 256 ++++++++++++++++++++----------------
 5 files changed, 160 insertions(+), 115 deletions(-)

-- 
2.27.0

