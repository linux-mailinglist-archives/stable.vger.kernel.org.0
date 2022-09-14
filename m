Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EDD5B84B4
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiINJPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiINJNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:13:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3E17757D;
        Wed, 14 Sep 2022 02:06:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C218619F2;
        Wed, 14 Sep 2022 09:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986CCC43470;
        Wed, 14 Sep 2022 09:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146333;
        bh=Fq7QLKzXRestzZdZD/SIqT351m/CrTnNJl4U9TAnQs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWqsLO8h+czC+0gxohiJ8O75lvFR+h1N4F1kPnFmQ4DFA5UitC2OIChOlXaXfPZdc
         DJkSCVmnHWQaoMsiW3IPM5cE79epxyQfJDyqamrqiNQlVxXsYgs/qgg4PpurldEYMO
         0NO4sLLq687EtpUWx7Ify2jdSSx3j3WbYNZxycAXU+mApxHS693E6RsJRQ6yNekPQQ
         KpMUeFApElTcIuhYuYD7xoi9OvcJ6YlUHmYbf+eu9lUVAveWkLM49yoQ8BQWhm+DgG
         0Vf34tgNRJfQ6CIyFXm0BIqMK26Pl+vAH4PbcZWi1qpqZvpj0/K1IQn5OCozuC7cAy
         AIItox9TDmRkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/8] scsi: mpt3sas: Fix use-after-free warning
Date:   Wed, 14 Sep 2022 05:05:10 -0400
Message-Id: <20220914090514.471614-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090514.471614-1-sashal@kernel.org>
References: <20220914090514.471614-1-sashal@kernel.org>
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
index 79c5a193308f4..8fb7491c5bc02 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2804,6 +2804,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
+		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
@@ -2840,7 +2841,6 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
-		fw_event_work_put(fw_event);
 	}
 }
 
-- 
2.35.1

