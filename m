Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D70130096
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 04:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgADDgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 22:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgADDgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 22:36:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC562465A;
        Sat,  4 Jan 2020 03:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578109008;
        bh=McUFwkqgq1B3keNDLMTz9JF50vJdyj1xjoKR7hsJxRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxelU5rlt0cSlbt3a0XOMiE6raa0Nm8ZQ8gS+wohRjLs/OmREJAo0yH4NUX628417
         3nK1FOekUS7fjBgcJPegIklrSFOIT7I24vDOGytqEjBEsZM4RWX4W5VAl72jz19hTM
         pUlvfgWx3HC7/gbHwwULG4d00wS/iL3jFgCnwTVI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Varun Prakash <varun@chelsio.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/5] scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()
Date:   Fri,  3 Jan 2020 22:36:42 -0500
Message-Id: <20200104033644.11121-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200104033644.11121-1-sashal@kernel.org>
References: <20200104033644.11121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 71482fde704efdd8c3abe0faf34d922c61e8d76b ]

If cxgb4i_ddp_init() fails then cdev->cdev2ppm will be NULL, so add a check
for NULL pointer before dereferencing it.

Link: https://lore.kernel.org/r/1576676731-3068-1-git-send-email-varun@chelsio.com
Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/cxgbi/libcxgbi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index cd2c247d6d0c..559d8bda4cca 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -121,7 +121,8 @@ static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
 		"cdev 0x%p, p# %u.\n", cdev, cdev->nports);
 	cxgbi_hbas_remove(cdev);
 	cxgbi_device_portmap_cleanup(cdev);
-	cxgbi_ppm_release(cdev->cdev2ppm(cdev));
+	if (cdev->cdev2ppm)
+		cxgbi_ppm_release(cdev->cdev2ppm(cdev));
 	if (cdev->pmap.max_connect)
 		cxgbi_free_big_mem(cdev->pmap.port_csk);
 	kfree(cdev);
-- 
2.20.1

