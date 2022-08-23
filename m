Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380E359E2CE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354715AbiHWMSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359621AbiHWMQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:16:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4997A53B;
        Tue, 23 Aug 2022 02:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CF7B61464;
        Tue, 23 Aug 2022 09:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E026C433C1;
        Tue, 23 Aug 2022 09:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247692;
        bh=kVlUXOCqSVxVL6zHBfQjFoxbj12/c/D87XseBODHvrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuN+oKLkeh7oHO07a4MNXAne1ttkl+uHfLzRX6CojhRJ8dfG28g2xZkHN+mRJANlZ
         LBJwVayyD7XpcMQ6EBdcb2T4EpfIH7t8WnVyoRLSqhxB0+s6LhzFxNHfgYboIA8SO9
         vLDDt0Pp/q7X0FzrRV2FBn+S3q7WqAvIH0MyD33o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/158] scsi: lpfc: Prevent buffer overflow crashes in debugfs with malformed user input
Date:   Tue, 23 Aug 2022 10:27:29 +0200
Message-Id: <20220823080050.662243394@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit f8191d40aa612981ce897e66cda6a88db8df17bb ]

Malformed user input to debugfs results in buffer overflow crashes.  Adapt
input string lengths to fit within internal buffers, leaving space for NULL
terminators.

Link: https://lore.kernel.org/r/20220701211425.2708-3-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index beaf3a8d206f..fbc76d69ea0b 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2609,8 +2609,8 @@ lpfc_debugfs_multixripools_write(struct file *file, const char __user *buf,
 	struct lpfc_sli4_hdw_queue *qp;
 	struct lpfc_multixri_pool *multixri_pool;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2690,8 +2690,8 @@ lpfc_debugfs_nvmestat_write(struct file *file, const char __user *buf,
 	if (!phba->targetport)
 		return -ENXIO;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2828,8 +2828,8 @@ lpfc_debugfs_ioktime_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2956,8 +2956,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 63)
-		nbytes = 63;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -3062,8 +3062,8 @@ lpfc_debugfs_hdwqstat_write(struct file *file, const char __user *buf,
 	char *pbuf;
 	int i;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
-- 
2.35.1



