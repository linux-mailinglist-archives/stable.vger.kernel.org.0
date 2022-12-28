Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7B65809F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbiL1QSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiL1QSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:18:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD81E18B21
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64F28614CF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78687C433D2;
        Wed, 28 Dec 2022 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244223;
        bh=RNcdozb89Wu/VFqzLu5hbplxrrqvkTwjb6AtRw7a/BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHf231O3GkDp29GrgS2DavRVyOgWjpxOGYPszTiPwD7cnLPm58Vxo01m+bpSqdKnl
         pp2LeNviA6XkD8h7B1KytqraZUZC27qWbjr3OFQyEdnHAQiN/QEptA0Uoj3cNTrbFl
         QSN+c5wxj+KvVw+2pTSTh0OaJ6thTs/6CtOw+YgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0631/1146] scsi: hpsa: Fix possible memory leak in hpsa_init_one()
Date:   Wed, 28 Dec 2022 15:36:10 +0100
Message-Id: <20221228144347.306938822@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index f8e832b1bc46..e5cbc97a5ea4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8925,7 +8925,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		destroy_workqueue(h->monitor_ctlr_wq);
 		h->monitor_ctlr_wq = NULL;
 	}
-	kfree(h);
+	hpda_free_ctlr_info(h);
 	return rc;
 }
 
-- 
2.35.1



