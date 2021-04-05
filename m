Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45223547CC
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhDEUve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhDEUvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:51:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59825C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:51:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w7so18291022ybq.4
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HHMYy3gMMJeP2SodWln73WD+vzU1bAzdoHq+A9oBRnM=;
        b=iHJVieOmGNQcc4H++g4LDCtzngU6aNaIP5gYc7o1lb4bUHG9NA7di9FpC4Xgb8BqCI
         WGRRgNEiS/BYDRRmUihdFopC0yejrTvrMwJ45S9SzfRt0LoGft9nuCLhA4iXjt+2gX2S
         xvVejhdZEvbmbGZVidRdBQUeu2rYraTkzvZGqgtjKW1QC3yYO9hEp3BylSs1hoCxiVav
         iYrThgCId3zdHdzrqfA3FdOW2gfQu6nGVXCqsY+XmT9ssnty7SS2rlewGq0Bh0XNdgMy
         bLr2L4cuhOco6VCvH3105uTsWMqejSa/Bqv1JYPrds9fe0WMrWyi7wmmURQE/9C3vwZj
         53og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HHMYy3gMMJeP2SodWln73WD+vzU1bAzdoHq+A9oBRnM=;
        b=k/+UuuJIrGmhBWgxhmGo6aCpU1JMk/Hp2Fu00Pa6MVhZqmFVBTE/DIPYipI33y7fpY
         tB99j1ljUhjPHfyFaB/LyLl7768ZoHlmd3Z5NohZlXPhS8RivMmTHIvnIU2lqRoKpZUr
         hmmFZ/ewQjuVsEV2u4CS1O61VeWwfq7oCAVz2/yeG5aFSGebsdeFdB8dDEXBC7PGZrb3
         +1KL0hQf1JtW8XZeWA+AYNwtf3Wu6hNsaRMNdhjRr4g+7I7LlwTL+xwou4yFt/WH+D3z
         l/c62wg1WKJ7IBSa9LWUuh1xbnjuNtqWNa6uPcsoKSa/RjPafgIY9/uOanZn/bXVsGsm
         TaJQ==
X-Gm-Message-State: AOAM5333aFTZqdGC26r8xj1ypARey875pXj2qjTez9Ne0D7LOtGZnA0M
        qK6kS7gaBa3M4K3vGpwy6FpmjAsMoqKibEnd8B8FT0vKtD3L2qtIVrOnvjMQQVOVLvhRkQMbSfP
        DfE93rWDNK46NVO+DqwXdoKGLHeoM/e0RjWgwIgYM2CoBobwZumMgMTevDUM=
X-Google-Smtp-Source: ABdhPJw60vS2Fp68RQdINbivNjUoUG2fIozzd5h1MFt5+MwBTZ+lYTyBN7nOucEbqak+y2JP0akp0pQYfQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a25:2605:: with SMTP id m5mr37383472ybm.130.1617655886508;
 Mon, 05 Apr 2021 13:51:26 -0700 (PDT)
Date:   Mon,  5 Apr 2021 20:51:01 +0000
Message-Id: <20210405205109.1700468-1-jxgao@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 5.4 0/8] preserve DMA offsets when using swiotlb
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

Jianxiong Gao (7):
  driver core: add a min_align_mask field to struct
    device_dma_parameters
  swiotlb: add a io_tlb_offset helper
  swiotlb: factor out a nr_slots helper
  swiotlb: clean up swiotlb_tbl_unmap_single
  swiotlb: refactor swiotlb_tbl_map_single
  swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
  nvme-pci: set min_align_mask

Linus Torvalds (1):
  Linux 5.4

 Makefile                    |   2 +-
 drivers/nvme/host/pci.c     |   1 +
 include/linux/device.h      |   1 +
 include/linux/dma-mapping.h |  16 +++
 include/linux/swiotlb.h     |   3 +-
 kernel/dma/swiotlb.c        | 262 ++++++++++++++++++++----------------
 6 files changed, 165 insertions(+), 120 deletions(-)

-- 
2.27.0

