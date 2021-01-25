Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320C2302A95
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbhAYSoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbhAYSoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:44:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A46632063A;
        Mon, 25 Jan 2021 18:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600229;
        bh=xDE0dAhIQ4jlC1YtwX2KtMFo4eSXiu4lsr8g5L3KfC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWNUSUdax8FpD31Z2nZQp1hm8pN3KNgiYRTPfq4aOPnr0mXI0dFU3X16Adb1ZC+8K
         SEHrIRYLm5k+P2t7Xv0xh/wjQz2yYwC5sEOpnORoU4+1ZPT4B4HLSDTj9jqrGk9VRD
         FW6uxR3b9O8p/JBplmfnARZ+XEFPXjtyi+1B1m/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/86] scsi: qedi: Correct max length of CHAP secret
Date:   Mon, 25 Jan 2021 19:39:04 +0100
Message-Id: <20210125183201.985957041@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit d50c7986fbf0e2167279e110a2ed5bd8e811c660 ]

The CHAP secret displayed garbage characters causing iSCSI login
authentication failure. Correct the CHAP password max length.

Link: https://lore.kernel.org/r/20201217105144.8055-1-njavali@marvell.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 35c96ea2653be..fdd966fea7f6a 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2175,7 +2175,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     chap_name);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_SECRET:
-		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
 			     chap_secret);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
@@ -2183,7 +2183,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     mchap_name);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
-		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
 			     mchap_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-- 
2.27.0



