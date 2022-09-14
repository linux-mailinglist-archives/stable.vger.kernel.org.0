Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB665B8484
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiINJNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiINJMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:12:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98C87B794;
        Wed, 14 Sep 2022 02:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51CED619BF;
        Wed, 14 Sep 2022 09:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E735C43140;
        Wed, 14 Sep 2022 09:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146305;
        bh=hFLVpwtabUKVtVTADCpcFltI/BeaZikvrAsHRjCcEDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+0GywOjuJo1D3zflVNW+asFCcnLuTrYxthtwrHcUXqo3fh+JhJ64TZvTdUQEHxrb
         4X+Bkjwd72IaQ6BloyrJyM7tmM2X7SexsB9WrlQPsi9EYcjyntk2wbWbXq1kd6GOLi
         P9XGESzwmGMEbiTmOsrrlrLwSUfyZDP839F08K51pAosvW3R4RL2KAXWYI0VUE5Xtx
         weT8y8qXQt6/TwonWFPsr9sZI4p2txih66XzHGSRtPpoZBU4YL0T9LxXg68qBWAj/J
         rMXIo8X2MjAEaJ5Zdx9eHZyIk+/mACcGdSdHqYC+vrBRErt2y5aS7ClHMTlGypQn5E
         ceO41mpsBRxyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 7/9] scsi: mpt3sas: Fix use-after-free warning
Date:   Wed, 14 Sep 2022 05:04:41 -0400
Message-Id: <20220914090445.471489-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090445.471489-1-sashal@kernel.org>
References: <20220914090445.471489-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 991df3dd5144f2e6b1c38b8d20ed3d4d21e20b34 ]

Fix the following use-after-free warning which is observed during
controller reset:

refcount_t: underflow; use-after-free.
WARNING: CPU: 23 PID: 5399 at lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0

Link: https://lore.kernel.org/r/20220906134908.1039-2-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d899f216245e5..c8d97dc2ca63d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3215,6 +3215,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
+		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
@@ -3249,7 +3250,6 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
-		fw_event_work_put(fw_event);
 	}
 }
 
-- 
2.35.1

