Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0834345143D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349133AbhKOUDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:03:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344333AbhKOTYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A590E63481;
        Mon, 15 Nov 2021 18:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002554;
        bh=ewkzPD2hAfFBgRvXg5mqobSR12O4QDdvx+F7+uJP1g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZmOl2upYLGZRFlrxgpzHnH0Z6BYJuhyM3GDd5LITOqNJ7jsqfKZSrEdL40XjnOIk
         uJkwuDvfvPXH1sEHCJ22h2NfvNC7wP3Y3F3p7xyDU3M+K/LePys66h+CjWaiBOzLSx
         1+fHW7LXf8J9Bw1V3suatqJMakJ1GWlDcJwM2jTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changyuan Lyu <changyuanl@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 611/917] scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()
Date:   Mon, 15 Nov 2021 18:01:46 +0100
Message-Id: <20211115165449.517547566@linuxfoundation.org>
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
index 63690508313b7..639b7e38a1947 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3169,7 +3169,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
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



