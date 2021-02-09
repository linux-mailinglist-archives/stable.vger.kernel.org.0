Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443C9314879
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 07:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhBIGK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 01:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhBIGKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 01:10:19 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5BBC06178A
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 22:09:38 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id b16so5122360lji.13
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 22:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=EN0Mzb6s8Tl+sO9KcM8dEOwC7FeQgGNzUGgSeuHZRDo=;
        b=QiOwygcdrjYgf/3lDY8pI7Ji34qvamUJReMpjfXTUuvpzEcBEFrIOOiUI8xr04NjZU
         tpwH6Mnld5gW5qUqlcT9yclH/H8vFgE74ftvEsxScW/+eNUafP6SF28PnC/FqJsK0wXw
         UALR75hzAWTlMJczQAzJgq1zobcY00uLi654VtOoTCD5qOkMlYDcrFKxsW8nOAxEPNxw
         WOL5S79DTZlWQCi0Re6jfrDqg034CDDoVLCPh75gl2R1gKqxXAIoqFdBXAS+juaAqs/D
         U1bhIwdWGgY5hgvpirFgjr7we1NAuDFcJnrmXzAdj0ahBNHgu2U4sqd3h7/I3c4UQTYx
         DnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=EN0Mzb6s8Tl+sO9KcM8dEOwC7FeQgGNzUGgSeuHZRDo=;
        b=ATnVVV7mIltqtGyEJI1WKqqb2xKKja2W8zMtb36O3PqBugM4gVr7DJUvMkMMiD+cFl
         z8ATqzmuk5W43aE40nwW8fwEQUpDVnmxh7kQDdf/gBWkm1GYU3Ew7fWp/QBPvcd+X+uG
         LZfwlukFRhcZC4/LjYYGa/W7jw73qyRAk7zx70Qw16+fcQG/Ytcvv2ESgWDUOqzNE3AJ
         EgXXTN6ewCFrtxReL52+PG2tYTD8laBirHm7U6usM0DlKfTCwm9EN18gwGphyeLaosSz
         Km7jlyylGOp5AqR8lALw5LGkubvI7jKDgfcbZt+X8UQsTLGr4FDd3udhXhLzdgsPwOar
         Dk+A==
X-Gm-Message-State: AOAM533+j0yfvw4lvVjVoI2hwXuYCWVJ6vFFxpZHrdCleeFB8ogZswwN
        OpeYF4pRV51eCxQgb9JnDX5FDygSWNocgDucQ5GGfQ==
X-Google-Smtp-Source: ABdhPJzg+OLmID5j3R8uwBU7Ya6jUJbEGbdW5wxF4lUjHYE+P58BfiZAah3eC7aYCYxA/+068IMOyaRZUMqwz3AR+s0=
X-Received: by 2002:a05:651c:c5:: with SMTP id 5mr2207729ljr.480.1612850976581;
 Mon, 08 Feb 2021 22:09:36 -0800 (PST)
MIME-Version: 1.0
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 9 Feb 2021 11:39:25 +0530
Message-ID: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com>
Subject: DMA direct mapping fix for 5.4 and earlier stable branches
To:     hch@lst.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     m.szyprowski@samsung.com, robin.murphy@arm.com,
        iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        obayashi.yoshimasa@socionext.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christoph, Greg,

Currently we are observing an incorrect address translation
corresponding to DMA direct mapping methods on 5.4 stable kernel while
sharing dmabuf from one device to another where both devices have
their own coherent DMA memory pools.

I am able to root cause this issue which is caused by incorrect virt
to phys translation for addresses belonging to vmalloc space using
virt_to_page(). But while looking at the mainline kernel, this patch
[1] changes address translation from virt->to->phys to dma->to->phys
which fixes the issue observed on 5.4 stable kernel as well (minimal
fix [2]).

So I would like to seek your suggestion for backport to stable kernels
(5.4 or earlier) as to whether we should backport the complete
mainline commit [1] or we should just apply the minimal fix [2]?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=34dc0ea6bc960f1f57b2148f01a3f4da23f87013
[2] minimal fix required for 5.4 stable kernel:

commit bb0b3ff6e54d78370b6b0c04426f0d9192f31795
Author: Sumit Garg <sumit.garg@linaro.org>
Date:   Wed Feb 3 13:08:37 2021 +0530

    dma-mapping: Fix common get_sgtable and mmap methods

    Currently common get_sgtable and mmap methods can only handle normal
    kernel addresses leading to incorrect handling of vmalloc addresses which
    is common means for DMA coherent memory mapping.

    So instead of cpu_addr, directly decode the physical address from
dma_addr and
    hence decode corresponding page and pfn values. In this way we can handle
    normal kernel addresses as well as vmalloc addresses.

    This fix is inspired from following mainline commit:

    34dc0ea6bc96 ("dma-direct: provide mmap and get_sgtable method overrides")

    This fixes an issue observed during dmabuf sharing from one device to
    another where both devices have their own coherent DMA memory pools.

    Signed-off-by: Sumit Garg <sumit.garg@linaro.org>

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 8682a53..034bbae 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -127,7 +127,7 @@ int dma_common_get_sgtable(struct device *dev,
struct sg_table *sgt,
                        return -ENXIO;
                page = pfn_to_page(pfn);
        } else {
-               page = virt_to_page(cpu_addr);
+               page = pfn_to_page(PHYS_PFN(dma_to_phys(dev, dma_addr)));
        }

        ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
@@ -214,7 +214,7 @@ int dma_common_mmap(struct device *dev, struct
vm_area_struct *vma,
                if (!pfn_valid(pfn))
                        return -ENXIO;
        } else {
-               pfn = page_to_pfn(virt_to_page(cpu_addr));
+               pfn = PHYS_PFN(dma_to_phys(dev, dma_addr));
        }

        return remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
