Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6095D658022
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiL1QOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiL1QN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:13:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B4C1AF02
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D525B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B621C433D2;
        Wed, 28 Dec 2022 16:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243911;
        bh=rSXw+o7PokGyUsrmdiOZbpbWq8o6GdD83cEdnEMK+JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4txP2p9WREAowTIrCGzXoZ+9eYS9/1IvovA7146Gd2KB2I05SWqVqCOPDW9TtgTX
         JYfV1qWhToSnbAF+Lw5mcqFFBejRk1OXiNEY0lJbCvAGwHB/XfPaa9XaBq2fM8p1Sc
         7qVF+UPde71wa71UKraFkJztlt4q6+bZfoR3JUS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0614/1073] scsi: hpsa: Fix possible memory leak in hpsa_init_one()
Date:   Wed, 28 Dec 2022 15:36:42 +0100
Message-Id: <20221228144344.720846604@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 9c9ff300e0de07475796495d86f449340d454a0c ]

The hpda_alloc_ctlr_info() allocates h and its field reply_map. However, in
hpsa_init_one(), if alloc_percpu() failed, the hpsa_init_one() jumps to
clean1 directly, which frees h and leaks the h->reply_map.

Fix by calling hpda_free_ctlr_info() to release h->replay_map and h instead
free h directly.

Fixes: 8b834bff1b73 ("scsi: hpsa: fix selection of reply queue")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221122015751.87284-1-yuancan@huawei.com
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a47bcce3c9c7..99dbb48fc94f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8929,7 +8929,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		destroy_workqueue(h->monitor_ctlr_wq);
 		h->monitor_ctlr_wq = NULL;
 	}
-	kfree(h);
+	hpda_free_ctlr_info(h);
 	return rc;
 }
 
-- 
2.35.1



