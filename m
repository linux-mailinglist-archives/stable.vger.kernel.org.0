Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2865450E37
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240771AbhKOSN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240135AbhKOSFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A056328E;
        Mon, 15 Nov 2021 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998168;
        bh=UtjqxZWRze2aYZLRYH3XCMkx7eZPNuLAn9ROZRLXKIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+dFs1RKqVWPtR4Fwj3UdlV0WL4xogRVb3BVn6QvA1EqZSgoP8rdQ+hUbzveQPtui
         OIbEuxYM32nqXZXyg17fs5wNy8RGs6b0XQOUDQ13JW20QB8cnuiCnUIRxueqD8sHPE
         Wu05otGm5vtvS3MtxXvixNtIvV2ekAO/CQQio2iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changyuan Lyu <changyuanl@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/575] scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()
Date:   Mon, 15 Nov 2021 18:02:17 +0100
Message-Id: <20211115165358.005877103@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 4084a7235d38311a77c86ba69ba849bd787db87b ]

pm8001_mpi_get_nvmd_resp() handles a GET_NVMD_DATA response, not a
SET_NVMD_DATA response, as the log statement implies.

Fixes: 1f889b58716a ("scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp() race condition")
Link: https://lore.kernel.org/r/20210929025847.646999-1-ipylypiv@google.com
Reviewed-by: Changyuan Lyu <changyuanl@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2114d2dd3501a..5d751628a6340 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3107,7 +3107,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	 * fw_control_context->usrAddr
 	 */
 	complete(pm8001_ha->nvmd_completion);
-	pm8001_dbg(pm8001_ha, MSG, "Set nvm data complete!\n");
+	pm8001_dbg(pm8001_ha, MSG, "Get nvmd data complete!\n");
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	pm8001_tag_free(pm8001_ha, tag);
-- 
2.33.0



