Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE95B717F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbiIMOjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbiIMOiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:38:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998571A06C;
        Tue, 13 Sep 2022 07:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32995B80F97;
        Tue, 13 Sep 2022 14:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7077C433C1;
        Tue, 13 Sep 2022 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078509;
        bh=Z0bdRwJRx2hRph/ehR3joONAbjxa+dBUIaXZ3nA3/24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ8iN8Rc16isRM6vCLkpRluabZXRxGSw6hMPd0pwKsZgTlAEnkE/yjOslUpdYsKrK
         yL/eiQQLlFJeCJwxD4oTI1BT27hW3m27QuC3kJpGMH011BHxUIOVGzKHU3ezeQlfOL
         4Sd++twvnjgASHVWA/CnC08/Nu5VWrXYKpUEJHJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 168/192] swiotlb: avoid potential left shift overflow
Date:   Tue, 13 Sep 2022 16:04:34 +0200
Message-Id: <20220913140418.402401555@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Chao Gao <chao.gao@intel.com>

[ Upstream commit 3f0461613ebcdc8c4073e235053d06d5aa58750f ]

The second operand passed to slot_addr() is declared as int or unsigned int
in all call sites. The left-shift to get the offset of a slot can overflow
if swiotlb size is larger than 4G.

Convert the macro to an inline function and declare the second argument as
phys_addr_t to avoid the potential overflow.

Fixes: 26a7e094783d ("swiotlb: refactor swiotlb_tbl_map_single")
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 5830dce6081b3..ce34d50f7a9bb 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -464,7 +464,10 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	}
 }
 
-#define slot_addr(start, idx)	((start) + ((idx) << IO_TLB_SHIFT))
+static inline phys_addr_t slot_addr(phys_addr_t start, phys_addr_t idx)
+{
+	return start + (idx << IO_TLB_SHIFT);
+}
 
 /*
  * Carefully handle integer overflow which can occur when boundary_mask == ~0UL.
-- 
2.35.1



