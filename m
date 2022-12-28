Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD84657B80
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiL1PXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiL1PWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C257140A4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 581ABB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF12C433EF;
        Wed, 28 Dec 2022 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240922;
        bh=xOSIsdrlsN8wvIdBL7ojX65T6doiYRzlcIhZ17Gdm40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnySp+Tn1TbzhRWlqnvrjEkILNjaaBPXElr4CvfJrvV1i8Swt7Dtitl0lACd7dSPs
         9u4o8w8hkX4YDd4qstWUyD+kook3LBuhlPSl/Ot87cQW+5ImOAKclagzQQOv4CVJcC
         QPgxoDItwS38ylniAahRp2X82z77mR0hv6SrYxf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Narsimhulu Musini <nmusini@cisco.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 417/731] scsi: snic: Fix possible UAF in snic_tgt_create()
Date:   Wed, 28 Dec 2022 15:38:44 +0100
Message-Id: <20221228144308.658771799@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index e9ccfb97773f..7cf871323b2c 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -318,6 +318,9 @@ snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
 			      ret);
 
 		put_device(&snic->shost->shost_gendev);
+		spin_lock_irqsave(snic->shost->host_lock, flags);
+		list_del(&tgt->list);
+		spin_unlock_irqrestore(snic->shost->host_lock, flags);
 		kfree(tgt);
 		tgt = NULL;
 
-- 
2.35.1



