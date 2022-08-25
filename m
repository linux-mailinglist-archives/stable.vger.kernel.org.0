Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEE05A0C97
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbiHYJ2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240238AbiHYJ2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:28:40 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99CA7AA4C4;
        Thu, 25 Aug 2022 02:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=6kRKP
        EDJzd7uCW3vEmzwA/9148JjbxPPxtaTCIkn/Jk=; b=UB1taWoipwDCWnApJL0+y
        1Gtp8t3PTwNHHK2BhtQyHjO/zj/B+qiBHJW2aN9VVcfz7labkc8CBC6rWk2rntWm
        ZWh2Cvvcoc372k1zOO9Idqg8a39I8YQR9q4VSRpeR6vEvhN2WW5Ag23XxyiNUtQx
        NRrAnD4QGtJ/oL++LAlN1g=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp4 (Coremail) with SMTP id HNxpCgCXduOUQAdjbzILXg--.6127S2;
        Thu, 25 Aug 2022 17:27:49 +0800 (CST)
From:   huhai <15815827059@163.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, huhai <huhai@kylinos.cn>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>
Subject: [PATCH] scsi: mpt3sas: Fix NULL pointer crash due to missing check device hostdata
Date:   Thu, 25 Aug 2022 17:26:45 +0800
Message-Id: <20220825092645.326953-1-15815827059@163.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgCXduOUQAdjbzILXg--.6127S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxur1UtFWrCFy8GryDCFWDCFg_yoW5KrWUpr
        98C34Fkr4kGr42g3W7Wa1UZr15Ja13AF10gF4Iv34kWF1Uu34qqry8tr4jyF18GrW5X3WU
        tF4qqrn5KFWDJaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UEsj8UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/1tbiRRVohWDuxhOu4QAAsp
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_DIGITS,FROM_LOCAL_HEX,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: huhai <huhai@kylinos.cn>

If _scsih_io_done() is called with scmd->device->hostdata=NULL, it can lead
to the following panic:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
  PGD 4547a4067 P4D 4547a4067 PUD 0
  Oops: 0002 [#1] SMP NOPTI
  CPU: 62 PID: 0 Comm: swapper/62 Kdump: loaded Not tainted 4.19.90-24.4.v2101.ky10.x86_64 #1
  Hardware name: Storage Server/65N32-US, BIOS SQL1041217 05/30/2022
  RIP: 0010:_scsih_set_satl_pending+0x2d/0x50 [mpt3sas]
  Code: 00 00 48 8b 87 60 01 00 00 0f b6 10 80 fa a1 74 09 31 c0 80 fa 85 74 02 f3 c3 48 8b 47 38 40 84 f6 48 8b 80 98 00 00 00 75 08 <f0> 80 60 18 fe 31 c0 c3 f0 48 0f ba 68 18 00 0f 92 c0 0f b6 c0 c3
  RSP: 0018:ffff8ec22fc03e00 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: ffff8eba1b072518 RCX: 0000000000000001
  RDX: 0000000000000085 RSI: 0000000000000000 RDI: ffff8eba1b072518
  RBP: 0000000000000dbd R08: 0000000000000000 R09: 0000000000029700
  R10: ffff8ec22fc03f80 R11: 0000000000000000 R12: ffff8ebe2d3609e8
  R13: ffff8ebe2a72b600 R14: ffff8eca472707e0 R15: 0000000000000020
  FS:  0000000000000000(0000) GS:ffff8ec22fc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000018 CR3: 000000046e5f6000 CR4: 00000000003406e0
  Call Trace:
   <IRQ>
   _scsih_io_done+0x4a/0x9f0 [mpt3sas]
   _base_interrupt+0x23f/0xe10 [mpt3sas]
   __handle_irq_event_percpu+0x40/0x190
   handle_irq_event_percpu+0x30/0x70
   handle_irq_event+0x36/0x60
   handle_edge_irq+0x7e/0x190
   handle_irq+0xa8/0x110
   do_IRQ+0x49/0xe0

Fix it by move scmd->device->hostdata check before _scsih_set_satl_pending
called.

Other changes:
- It looks clear to move get mpi_reply to near its check.

Fixes: ffb584565894 ("scsi: mpt3sas: fix hang on ata passthrough commands")
Cc: <stable@vger.kernel.org> # v4.9+
Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: huhai <huhai@kylinos.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index def37a7e5980..85f5749a0421 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5704,27 +5704,26 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
 
-	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
-
 	scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 	if (scmd == NULL)
 		return 1;
 
+	sas_device_priv_data = scmd->device->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	     sas_device_priv_data->sas_target->deleted) {
+		scmd->result = DID_NO_CONNECT << 16;
+		goto out;
+	}
 	_scsih_set_satl_pending(scmd, false);
 
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
+	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply == NULL) {
 		scmd->result = DID_OK << 16;
 		goto out;
 	}
 
-	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
-	     sas_device_priv_data->sas_target->deleted) {
-		scmd->result = DID_NO_CONNECT << 16;
-		goto out;
-	}
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
 
 	/*
-- 
2.27.0


No virus found
		Checked by Hillstone Network AntiVirus

