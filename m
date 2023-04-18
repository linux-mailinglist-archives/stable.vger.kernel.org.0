Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536DE6E6491
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjDRMuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjDRMuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3F9167FF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E4846340C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8A9C433D2;
        Tue, 18 Apr 2023 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822214;
        bh=fm62TvR7NPEE5/Hxdew0cOtJUmQncyfx90ZN00e6dm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEB+tx7QHJDdGSBOOjVKcAFSUyvMdjSvvqqRgEYwOmik3KpIknhliyHWT8z51OHgR
         tZ7KU7GZTeZZuRKfMCvElZirP7uFMy/6GWnvyR4jJ0fj0KwWZU3cJi88AFhbhkZ8c4
         IbGn8kwVHCoYlVDr7JzJrEuNSwtn3Z6HxyO+AYeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cheng Xu <chengyou@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 038/139] RDMA/erdma: Inline mtt entries into WQE if supported
Date:   Tue, 18 Apr 2023 14:21:43 +0200
Message-Id: <20230418120315.085857589@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 0dd83a4d7756713f81990d6c5547500f212a1190 ]

The max inline mtt count supported is ERDMA_MAX_INLINE_MTT_ENTRIES.
When mr->mem.mtt_nents == ERDMA_MAX_INLINE_MTT_ENTRIES, inline mtt
is also supported, fix it.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230320084652.16807-4-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_qp.c b/drivers/infiniband/hw/erdma/erdma_qp.c
index ff473b208acfb..44923c51a01b4 100644
--- a/drivers/infiniband/hw/erdma/erdma_qp.c
+++ b/drivers/infiniband/hw/erdma/erdma_qp.c
@@ -405,7 +405,7 @@ static int erdma_push_one_sqe(struct erdma_qp *qp, u16 *pi,
 			FIELD_PREP(ERDMA_SQE_MR_MTT_CNT_MASK,
 				   mr->mem.mtt_nents);
 
-		if (mr->mem.mtt_nents < ERDMA_MAX_INLINE_MTT_ENTRIES) {
+		if (mr->mem.mtt_nents <= ERDMA_MAX_INLINE_MTT_ENTRIES) {
 			attrs |= FIELD_PREP(ERDMA_SQE_MR_MTT_TYPE_MASK, 0);
 			/* Copy SGLs to SQE content to accelerate */
 			memcpy(get_queue_entry(qp->kern_qp.sq_buf, idx + 1,
-- 
2.39.2



