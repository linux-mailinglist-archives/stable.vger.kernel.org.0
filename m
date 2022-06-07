Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EF7541C5A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382917AbiFGV6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383149AbiFGVwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8F82428E4;
        Tue,  7 Jun 2022 12:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC6B2617D0;
        Tue,  7 Jun 2022 19:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE8CC385A5;
        Tue,  7 Jun 2022 19:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629036;
        bh=mCQHmNsaRFd+gnI4Oto6NcCrMml2VebXVqV8yAX6psg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heYNGFK/iz1CBgyQKWlxXCoQ3nSvyn1Ab9i6CwlBA1LawyKJ+VgM/wfPCw1VXm9Iu
         UxSNRRQQaYHurQ3mPc7x+JEaGFz470V6wVKppYhxZs7IJJ3cyT0lRPOtXqCUi77beR
         miobiP8k1hrnEA5vF+lKM5g1wf63Y2IUXontGBAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yihang Li <liyihang6@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 505/879] scsi: hisi_sas: Fix memory ordering in hisi_sas_task_deliver()
Date:   Tue,  7 Jun 2022 19:00:23 +0200
Message-Id: <20220607165017.534549158@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 6c6ac8b7773f05f93dc4e4044686e059d1f78dea ]

The memories for the slot should be observed to be written prior to
observing the slot as ready.

Prior to commit 26fc0ea74fcb ("scsi: libsas: Drop SAS_TASK_AT_INITIATOR"),
we had a spin_lock() + spin_unlock() immediately before marking the slot as
ready. The spin_unlock() - with release semantics - caused the slot memory
to be observed to be written.

Now that the spin_lock() + spin_unlock() is gone, use a smp_wmb().

Link: https://lore.kernel.org/r/1652774661-12935-1-git-send-email-john.garry@huawei.com
Fixes: 26fc0ea74fcb ("scsi: libsas: Drop SAS_TASK_AT_INITIATOR")
Reported-by: Yihang Li <liyihang6@hisilicon.com>
Tested-by: Yihang Li <liyihang6@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 86cbfab78dfe..849cc5fc86af 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -446,6 +446,8 @@ void hisi_sas_task_deliver(struct hisi_hba *hisi_hba,
 		return;
 	}
 
+	/* Make slot memories observable before marking as ready */
+	smp_wmb();
 	WRITE_ONCE(slot->ready, 1);
 
 	spin_lock(&dq->lock);
-- 
2.35.1



