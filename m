Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896AB5B8472
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiINJMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiINJLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:11:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C8B79A54;
        Wed, 14 Sep 2022 02:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F3DACE1394;
        Wed, 14 Sep 2022 09:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C058C433D6;
        Wed, 14 Sep 2022 09:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146277;
        bh=4fLLnP+6/BmoPVk5R3BLsIefW/lAMr7c6Boio7sXQPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jf7Fb+EF1j2X4hsJx5nD0bdIiWrVV98zHRV7tF1aeoQtvs14Eqh+nXGk4vG/H2MSH
         9pifh1nRQRXavuOcrp+2WIykJBKaiVtkVPHgeNEJjrzyvtQSyL0FJOUWR1dCDLmT3m
         OEyKhvIRr/c2TfPZkv5D9CrmbqtNb+thWwTTIy5Z72nnh6WGQnJjIbwi2I5wcXt7KQ
         IDSSOIstI4e5EtycbekA98uUkjKi8uQzsj3E8FpTW8kgVuF6rr+2qyLuV57wkpEmzY
         7YjMlQPV7M04jvfchaTiYcemT5ubqsVDPXpHI7fU7QndYNISWgoMTA4uOdxIlXcqkE
         t2iTOeJf4TSrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/12] scsi: mpt3sas: Fix use-after-free warning
Date:   Wed, 14 Sep 2022 05:04:03 -0400
Message-Id: <20220914090407.471328-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090407.471328-1-sashal@kernel.org>
References: <20220914090407.471328-1-sashal@kernel.org>
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
index 97c1f242ef0a3..044a00edb5459 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3238,6 +3238,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
+		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
@@ -3272,7 +3273,6 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
-		fw_event_work_put(fw_event);
 	}
 }
 
-- 
2.35.1

