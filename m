Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CC75950E9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbiHPErQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiHPEqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D85AF0F9;
        Mon, 15 Aug 2022 13:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 222A261234;
        Mon, 15 Aug 2022 20:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDCFC433D7;
        Mon, 15 Aug 2022 20:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596182;
        bh=t8+OKYEpZiL7sn8D1gWVgX+z5A0ortSwMLKz+gHOD5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpRMNeLEsrzc0N9qCURVjpZNE9stKdsF5BTenJvtqJAJZB6DFtZF6vcNst0BGwgU6
         HVnXUI3byGbUea9mJqLIoDTfYIK6G1xPdtlFufSIooX84s2OMBIzpQIXnUHzvgAsct
         ztr/EDw6yW0GQKuu2WL5Q01BUup6DWk4x4mTUgy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0998/1157] powerpc/iommu: Fix iommu_table_in_use for a small default DMA window case
Date:   Mon, 15 Aug 2022 20:05:54 +0200
Message-Id: <20220815180519.688633465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 7e56ddb3e0b9..caebe1431596 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -775,6 +775,11 @@ bool iommu_table_in_use(struct iommu_table *tbl)
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



