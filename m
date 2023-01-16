Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2166CCFC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbjAPRcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbjAPRbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:31:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97217442F5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:08:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6662CB8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27AAC433EF;
        Mon, 16 Jan 2023 17:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888896;
        bh=w9Jg58jOa6QYvrlg97O2pMo4K536aTrzmEEQG7Vc7H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PC3C4ZR8xl80INqb1Ppokty8SCnBtYttvoCLFdAZ49LYUI1nRWhNv22GTFnyDCMn
         L5nSNiS+ngTZXt4gUpLhzJ8IoBQwItjPwQjc1oSjVxVf2CKsCSl4geWdphvHdH+urA
         KFFYbU73ZMWJa/KwidNycIp4gVthTbBh2kL+lmGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Narsimhulu Musini <nmusini@cisco.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 150/338] scsi: snic: Fix possible UAF in snic_tgt_create()
Date:   Mon, 16 Jan 2023 16:50:23 +0100
Message-Id: <20230116154827.390885765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit e118df492320176af94deec000ae034cc92be754 ]

Smatch reports a warning as follows:

drivers/scsi/snic/snic_disc.c:307 snic_tgt_create() warn:
  '&tgt->list' not removed from list

If device_add() fails in snic_tgt_create(), tgt will be freed, but
tgt->list will not be removed from snic->disc.tgt_list, then list traversal
may cause UAF.

Remove from snic->disc.tgt_list before free().

Fixes: c8806b6c9e82 ("snic: driver for Cisco SCSI HBA")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221117035100.2944812-1-cuigaosheng1@huawei.com
Acked-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/snic/snic_disc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index b106596cc0cf..69c5e26a9d5b 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -317,6 +317,9 @@ snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
 			      ret);
 
 		put_device(&snic->shost->shost_gendev);
+		spin_lock_irqsave(snic->shost->host_lock, flags);
+		list_del(&tgt->list);
+		spin_unlock_irqrestore(snic->shost->host_lock, flags);
 		kfree(tgt);
 		tgt = NULL;
 
-- 
2.35.1



