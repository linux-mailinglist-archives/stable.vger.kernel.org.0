Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBD6451F1A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355601AbhKPAif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344437AbhKOTYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86CA363492;
        Mon, 15 Nov 2021 18:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002660;
        bh=UU1P0n2MZuxrGUHrRfKy5j7rup4560+xJAJEEg7ZDPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjlTFvbC42Ha9vocZTmcVZ3UbLMr1RjFWzEmUUYrEwgbtOsc6IhCM3+cSSmgNcifz
         hQLeIrmmxG1ZMg3j3OPLSXgf0MouBrOvVsidxvPATGzuY62vSBkMvr6YLAUvuCb53c
         phhljLsKpCf7mo5gN2eIB9El5z8hHFCO45KxWI+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 650/917] scsi: lpfc: Wait for successful restart of SLI3 adapter during host sg_reset
Date:   Mon, 15 Nov 2021 18:02:25 +0100
Message-Id: <20211115165450.906426342@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit d305c253af693e69a36cedec880aca6d0c6d789d ]

A prior patch introduced HBA_NEEDS_CFG_PORT flag logic, but in
lpfc_sli_brdrestart_s3() code path, right after HBA_NEEDS_CFG_PORT is set,
the phba->hba_flag is cleared in lpfc_sli_brdreset().

Fix by calling lpfc_sli_chipset_init() to wait for successful restart of
the HBA in lpfc_host_reset_handler() after lpfc_sli_brdrestart().

lpfc_sli_chipset_init() sets the HBA_NEEDS_CFG_PORT flag so that the
lpfc_sli_hba_setup() routine from lpfc_online() will execute
lpfc_sli_config_port() initialization step when the brdrestart is
successful.

Link: https://lore.kernel.org/r/20211020211417.88754-3-jsmart2021@gmail.com
Fixes: d2f2547efd39 ("scsi: lpfc: Fix auto sli_mode and its effect on CONFIG_PORT for SLI3")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index befdf864c43bd..364c8a9b99095 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6628,6 +6628,13 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	if (rc)
 		goto error;
 
+	/* Wait for successful restart of adapter */
+	if (phba->sli_rev < LPFC_SLI_REV4) {
+		rc = lpfc_sli_chipset_init(phba);
+		if (rc)
+			goto error;
+	}
+
 	rc = lpfc_online(phba);
 	if (rc)
 		goto error;
-- 
2.33.0



