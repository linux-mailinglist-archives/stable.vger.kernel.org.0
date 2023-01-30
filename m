Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7990681125
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbjA3OKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbjA3OKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:10:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C383C2AA
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D415B61088
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361AAC433EF;
        Mon, 30 Jan 2023 14:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087818;
        bh=2BnMRx2hM76mbgzGa/WpWCzaGpEDWmyUCApCc5hADBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssT69Rqt/uDT85b165Aap4Mn4+P2g5nYgtl+9hFVuNOyaPQPtfiMnFTuNT+Jldm4P
         WiojMMIy5y2eaSyJwQk3Sw4JrFoay9VJ8esvVWaEK6RWG0fOSiT7bbRglCD9xIudwJ
         skZiITdbZiIVWpINMYx+DkZhD5VY+98BU1SpPQEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yonatan Nachum <ynachum@amazon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/204] RDMA/core: Fix ib block iterator counter overflow
Date:   Mon, 30 Jan 2023 14:49:45 +0100
Message-Id: <20230130134317.178843105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonatan Nachum <ynachum@amazon.com>

[ Upstream commit 0afec5e9cea732cb47014655685a2a47fb180c31 ]

When registering a new DMA MR after selecting the best aligned page size
for it, we iterate over the given sglist to split each entry to smaller,
aligned to the selected page size, DMA blocks.

In given circumstances where the sg entry and page size fit certain
sizes and the sg entry is not aligned to the selected page size, the
total size of the aligned pages we need to cover the sg entry is >= 4GB.
Under this circumstances, while iterating page aligned blocks, the
counter responsible for counting how much we advanced from the start of
the sg entry is overflowed because its type is u32 and we pass 4GB in
size. This can lead to an infinite loop inside the iterator function
because the overflow prevents the counter to be larger
than the size of the sg entry.

Fix the presented problem by changing the advancement condition to
eliminate overflow.

Backtrace:
[  192.374329] efa_reg_user_mr_dmabuf
[  192.376783] efa_register_mr
[  192.382579] pgsz_bitmap 0xfffff000 rounddown 0x80000000
[  192.386423] pg_sz [0x80000000] umem_length[0xc0000000]
[  192.392657] start 0x0 length 0xc0000000 params.page_shift 31 params.page_num 3
[  192.399559] hp_cnt[3], pages_in_hp[524288]
[  192.403690] umem->sgt_append.sgt.nents[1]
[  192.407905] number entries: [1], pg_bit: [31]
[  192.411397] biter->__sg_nents [1] biter->__sg [0000000008b0c5d8]
[  192.415601] biter->__sg_advance [665837568] sg_dma_len[3221225472]
[  192.419823] biter->__sg_nents [1] biter->__sg [0000000008b0c5d8]
[  192.423976] biter->__sg_advance [2813321216] sg_dma_len[3221225472]
[  192.428243] biter->__sg_nents [1] biter->__sg [0000000008b0c5d8]
[  192.432397] biter->__sg_advance [665837568] sg_dma_len[3221225472]

Fixes: a808273a495c ("RDMA/verbs: Add a DMA iterator to return aligned contiguous memory blocks")
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
Link: https://lore.kernel.org/r/20230109133711.13678-1-ynachum@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b721085bb597..f0c07e4ba438 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2965,15 +2965,18 @@ EXPORT_SYMBOL(__rdma_block_iter_start);
 bool __rdma_block_iter_next(struct ib_block_iter *biter)
 {
 	unsigned int block_offset;
+	unsigned int sg_delta;
 
 	if (!biter->__sg_nents || !biter->__sg)
 		return false;
 
 	biter->__dma_addr = sg_dma_address(biter->__sg) + biter->__sg_advance;
 	block_offset = biter->__dma_addr & (BIT_ULL(biter->__pg_bit) - 1);
-	biter->__sg_advance += BIT_ULL(biter->__pg_bit) - block_offset;
+	sg_delta = BIT_ULL(biter->__pg_bit) - block_offset;
 
-	if (biter->__sg_advance >= sg_dma_len(biter->__sg)) {
+	if (sg_dma_len(biter->__sg) - biter->__sg_advance > sg_delta) {
+		biter->__sg_advance += sg_delta;
+	} else {
 		biter->__sg_advance = 0;
 		biter->__sg = sg_next(biter->__sg);
 		biter->__sg_nents--;
-- 
2.39.0



