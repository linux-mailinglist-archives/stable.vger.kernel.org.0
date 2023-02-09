Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11886906A5
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBILTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjBILST (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:18:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9555FCE;
        Thu,  9 Feb 2023 03:16:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A201B82105;
        Thu,  9 Feb 2023 11:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A36C433EF;
        Thu,  9 Feb 2023 11:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941405;
        bh=Rq4n8uSGL6HKdp05k/r4meCtbqJ+11BI6aGjnZHod8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaFT2laTsXTXrtPVxVJCIV09ua7kHT4HU2oaNDUGnPjB5BeNUDYJgRSDsNCE3om3Y
         rM80GyW6VLe4Jkx53Qcx5wmgux2r7Bl+XCsd2Qz/S9OwNyrr3bWt03gyRB5uwz4WCf
         37UX67FZ5FKHmkIFPWpYrplN+2abgdAMY4h+vt461rCrbaTkkl29T/b0tN3b0K2i5l
         BmCAljedzKsP2k36dNpXilZl88MOeR1xuDxX5PE9XUBiV0iQJcVqRoNxkv9T/fFa5K
         LsdYxvSyIugkf3ULwvCZJlCtnyrbjSwpL6sMdiz0ipUL0YjGv3gb8E+IIvqqLy2zeU
         Ub8pPdRZJt1zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 28/38] nvme: clear the request_queue pointers on failure in nvme_alloc_io_tag_set
Date:   Thu,  9 Feb 2023 06:14:47 -0500
Message-Id: <20230209111459.1891941-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 6fbf13c0e24fd86ab2e4477cd8484a485b687421 ]

In nvme_alloc_io_tag_set(), the connect_q pointer should be set to NULL
in case of error to avoid potential invalid pointer dereferences.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e189ce17deb3e..5acc9ae225df3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4933,6 +4933,7 @@ int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 
 out_free_tag_set:
 	blk_mq_free_tag_set(set);
+	ctrl->connect_q = NULL;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_alloc_io_tag_set);
-- 
2.39.0

