Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AE3593AEE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344171AbiHOTik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244340AbiHOTg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD3F31235;
        Mon, 15 Aug 2022 11:46:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E3CF611DD;
        Mon, 15 Aug 2022 18:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFA3C433C1;
        Mon, 15 Aug 2022 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589174;
        bh=CM7F2rOUBmfcXUgNZhY9n4+a8WWv8wo3ROGfc/dqlQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjI7B6GtJBSDb2QKNois5N9NfLoAxFd1hZ1jfUHOCf2pcqANjc0j+pApBP9/W5Xoy
         nfZfS9RUQ5Hwt93xJnkVn+WFGoxEXjtCsBGPLSGPkY+WaffFHDCXMrrL6O2HtEp6Qc
         voK50F0rVuzHcZaHFdaRvNcKnf8zZNla1c/AP8DM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 637/779] powerpc/iommu: Fix iommu_table_in_use for a small default DMA window case
Date:   Mon, 15 Aug 2022 20:04:41 +0200
Message-Id: <20220815180404.569679022@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit d80f6de9d601c30b53c17f00cb7cfe3169f2ddad ]

The existing iommu_table_in_use() helper checks if the kernel is using
any of TCEs. There are some reserved TCEs:
1) the very first one if DMA window starts from 0 to avoid having a zero
but still valid DMA handle;
2) it_reserved_start..it_reserved_end to exclude MMIO32 window in case
the default window spans across that - this is the default for the first
DMA window on PowerNV.

When 1) is the case and 2) is not the helper does not skip 1) and returns
wrong status.

This only seems occurring when passing through a PCI device to a nested
guest (not something we support really well) so it has not been seen
before.

This fixes the bug by adding a special case for no MMIO32 reservation.

Fixes: 3c33066a2190 ("powerpc/kernel/iommu: Add new iommu_table_in_use() helper")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220714081119.3714605-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/iommu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 07093b7cdcb9..a67fd54ccc57 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -776,6 +776,11 @@ bool iommu_table_in_use(struct iommu_table *tbl)
 	/* ignore reserved bit0 */
 	if (tbl->it_offset == 0)
 		start = 1;
+
+	/* Simple case with no reserved MMIO32 region */
+	if (!tbl->it_reserved_start && !tbl->it_reserved_end)
+		return find_next_bit(tbl->it_map, tbl->it_size, start) != tbl->it_size;
+
 	end = tbl->it_reserved_start - tbl->it_offset;
 	if (find_next_bit(tbl->it_map, end, start) != end)
 		return true;
-- 
2.35.1



