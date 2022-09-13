Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CD45B7267
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiIMOzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiIMOxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:53:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E8672B77;
        Tue, 13 Sep 2022 07:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABDFD614CD;
        Tue, 13 Sep 2022 14:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91CAC433D7;
        Tue, 13 Sep 2022 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079072;
        bh=6GQrQaD4Ndg1ownpVmQw1dAi1L9syEgoCYQ/CVGoKu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuvcuEDeUKmDTWNR6RSrfL4Sp2UVZf0YU3MIEx/+8hLe5GP/FkiQRVbtg6f5LQrYH
         RtMTJsPhz26s6I5oOtwMeWxM/nGtNV0l0gsOWV7zqbcbDg77ErtfrA8iO8pezhc+DC
         dxrdEtNKKlZ+5mCUCdDGKf6XuPq0wXObxoFPwJ6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 72/79] swiotlb: avoid potential left shift overflow
Date:   Tue, 13 Sep 2022 16:05:17 +0200
Message-Id: <20220913140353.642694052@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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
index 274587a57717f..4a9831d01f0ea 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -452,7 +452,10 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 	}
 }
 
-#define slot_addr(start, idx)	((start) + ((idx) << IO_TLB_SHIFT))
+static inline phys_addr_t slot_addr(phys_addr_t start, phys_addr_t idx)
+{
+	return start + (idx << IO_TLB_SHIFT);
+}
 
 /*
  * Return the offset into a iotlb slot required to keep the device happy.
-- 
2.35.1



