Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92358272DBD
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgIUQmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729066AbgIUQmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:42:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 759EA238E6;
        Mon, 21 Sep 2020 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706569;
        bh=TKedLSS7DQWIizRWMXwSuTi5i+cLls7C2mBLvjUlNbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWm7Zc0lYpmfkCmgl4qkufVJGugP2VMjxQRn3qqZLqqt+JFocFkby9Uvm1/PaJHur
         SvvHf7gwKAbCbXtMDonxF31INfaQovVwoES7elPUXdLyFI1FPTFu//kFPeGtXtoAHy
         cb4sTyHHfY59EIUetTR5SJf+U03A2hcu8n2uKZK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 48/49] powerpc/dma: Fix dma_map_ops::get_required_mask
Date:   Mon, 21 Sep 2020 18:28:32 +0200
Message-Id: <20200921162036.776250199@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit 437ef802e0adc9f162a95213a3488e8646e5fc03 upstream.

There are 2 problems with it:
  1. "<" vs expected "<<"
  2. the shift number is an IOMMU page number mask, not an address
  mask as the IOMMU page shift is missing.

This did not hit us before f1565c24b596 ("powerpc: use the generic
dma_ops_bypass mode") because we had additional code to handle bypass
mask so this chunk (almost?) never executed.However there were
reports that aacraid does not work with "iommu=nobypass".

After f1565c24b596, aacraid (and probably others which call
dma_get_required_mask() before setting the mask) was unable to enable
64bit DMA and fall back to using IOMMU which was known not to work,
one of the problems is double free of an IOMMU page.

This fixes DMA for aacraid, both with and without "iommu=nobypass" in
the kernel command line. Verified with "stress-ng -d 4".

Fixes: 6a5c7be5e484 ("powerpc: Override dma_get_required_mask by platform hook and ops")
Cc: stable@vger.kernel.org # v3.2+
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200908015106.79661-1-aik@ozlabs.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/dma-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -100,7 +100,8 @@ static u64 dma_iommu_get_required_mask(s
 	if (!tbl)
 		return 0;
 
-	mask = 1ULL < (fls_long(tbl->it_offset + tbl->it_size) - 1);
+	mask = 1ULL << (fls_long(tbl->it_offset + tbl->it_size) +
+			tbl->it_page_shift - 1);
 	mask += mask - 1;
 
 	return mask;


