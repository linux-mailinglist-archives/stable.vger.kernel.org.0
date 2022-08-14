Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB7A592320
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242126AbiHNPxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241847AbiHNPuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:50:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739721CB25;
        Sun, 14 Aug 2022 08:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B16DC60C8C;
        Sun, 14 Aug 2022 15:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE81C43470;
        Sun, 14 Aug 2022 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491348;
        bh=vn8sRngeekKj5Hiwjb/2YEw2w2BCxvYLhU5ASInCkPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AN1RpwqB4DPvfIBtxhegWuv1xHsIKS5Mt+oyMdj/3XSzPfVpc6N0ZF4mf6lthVXDx
         P3paCWCeDbUwyCLT2gHMdzztAl6hfqPLCSl4q8UJODH1DSqz9y0mORNpmTIZivCYtq
         LGhHoKuPOsDmBiXx8xBLHgbTSDUe5RDHpbtDC1SkK9Umuq88TCL72pNZhYyXaKMZse
         bn4gTprx4yYkVIr16qS9NGt1Q1898MiNub4dFZ9ft7D3izTwLNtis6gaYj/tLrQ4Q3
         ZXkoIMOz7+73YM+CMFxasQsngBdriJtGj2AIoyIHUS1zheZLWXeVCkHfyC3DH/M6c8
         4b1C+tV57O4ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/21] scsi: lpfc: Prevent buffer overflow crashes in debugfs with malformed user input
Date:   Sun, 14 Aug 2022 11:35:20 -0400
Message-Id: <20220814153531.2379705-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153531.2379705-1-sashal@kernel.org>
References: <20220814153531.2379705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index e15bb3dfe995..69551132f304 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2402,8 +2402,8 @@ lpfc_debugfs_multixripools_write(struct file *file, const char __user *buf,
 	struct lpfc_sli4_hdw_queue *qp;
 	struct lpfc_multixri_pool *multixri_pool;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	/* Protect copy from user */
 	if (!access_ok(buf, nbytes))
@@ -2487,8 +2487,8 @@ lpfc_debugfs_nvmestat_write(struct file *file, const char __user *buf,
 	if (!phba->targetport)
 		return -ENXIO;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2629,8 +2629,8 @@ lpfc_debugfs_nvmektime_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2757,8 +2757,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 63)
-		nbytes = 63;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2863,8 +2863,8 @@ lpfc_debugfs_cpucheck_write(struct file *file, const char __user *buf,
 	char *pbuf;
 	int i, j;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
-- 
2.35.1

