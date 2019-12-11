Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5527C11B1C3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbfLKPcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387732AbfLKP2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:28:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22FAC2467F;
        Wed, 11 Dec 2019 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078131;
        bh=DwHgBaGQm+Eee8sSNHVvcjHdoYw8XkP65HCi5+x8xYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRqcHdcebQAyUGZ/zwYup0wuYVhkr+zhIwvfodsBCqYxgeAaA87ZGQYzFJSTIkYgb
         ykEtZMsBPlN/pknwWsYFuv57GJU8cWqC1eufcZAvyJg2nSR8YmkgDi36hAANpRiS62
         dbgQbmSkX1e+gelIdLO+51yKoeZYcshUR++tIf4g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/58] scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow
Date:   Wed, 11 Dec 2019 10:27:52 -0500
Message-Id: <20191211152831.23507-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 7cfd5639d99bec0d27af089d0c8c114330e43a72 ]

If the driver receives a login that is later then LOGO'd by the remote port
(aka ndlp), the driver, upon the completion of the LOGO ACC transmission,
will logout the node and unregister the rpi that is being used for the
node.  As part of the unreg, the node's rpi value is replaced by the
LPFC_RPI_ALLOC_ERROR value.  If the port is subsequently offlined, the
offline walks the nodes and ensures they are logged out, which possibly
entails unreg'ing their rpi values.  This path does not validate the node's
rpi value, thus doesn't detect that it has been unreg'd already.  The
replaced rpi value is then used when accessing the rpi bitmask array which
tracks active rpi values.  As the LPFC_RPI_ALLOC_ERROR value is not a valid
index for the bitmask, it may fault the system.

Revise the rpi release code to detect when the rpi value is the replaced
RPI_ALLOC_ERROR value and ignore further release steps.

Link: https://lore.kernel.org/r/20191105005708.7399-2-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5603c08f96843..07895ca2db30e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17500,6 +17500,13 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
 static void
 __lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
 {
+	/*
+	 * if the rpi value indicates a prior unreg has already
+	 * been done, skip the unreg.
+	 */
+	if (rpi == LPFC_RPI_ALLOC_ERROR)
+		return;
+
 	if (test_and_clear_bit(rpi, phba->sli4_hba.rpi_bmask)) {
 		phba->sli4_hba.rpi_count--;
 		phba->sli4_hba.max_cfg_param.rpi_used--;
-- 
2.20.1

