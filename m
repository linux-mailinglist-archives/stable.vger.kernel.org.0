Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B2259BA3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgIARFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbgIAPTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:19:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D6A2166E;
        Tue,  1 Sep 2020 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973580;
        bh=qoIcGKi5ZyQMg++5W6ElCy7HbYP19dh1pRbOId8yrIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJyHrtyAXyNZylhn/xQAb1Q8d9BIzMwGIQ17jdoiFq8/bMZqP9HkU1b4FHDVCnGcN
         JER4Q7CnR7LMI5zb8E0mFJZUzT0zwsc4yKFDVph76O2cL6pzwfaAk3m/8iaLaQSwSI
         Lkt1nv1rVOWdjfFJ+JqH8zCG3NPqL6ZIKgUW/JsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 55/91] scsi: ufs: Clean up completed request without interrupt notification
Date:   Tue,  1 Sep 2020 17:10:29 +0200
Message-Id: <20200901150930.844941375@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit b10178ee7fa88b68a9e8adc06534d2605cb0ec23 ]

If somehow no interrupt notification is raised for a completed request and
its doorbell bit is cleared by host, UFS driver needs to cleanup its
outstanding bit in ufshcd_abort(). Otherwise, system may behave abnormally
in the following scenario:

After ufshcd_abort() returns, this request will be requeued by SCSI layer
with its outstanding bit set. Any future completed request will trigger
ufshcd_transfer_req_compl() to handle all "completed outstanding bits". At
this time the "abnormal outstanding bit" will be detected and the "requeued
request" will be chosen to execute request post-processing flow. This is
wrong because this request is still "alive".

Link: https://lore.kernel.org/r/20200811141859.27399-2-huobean@gmail.com
Reviewed-by: Can Guo <cang@codeaurora.org>
Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 619fe46fcc5f0..c1792f271ac5d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5694,7 +5694,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 			/* command completed already */
 			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n",
 				__func__, tag);
-			goto out;
+			goto cleanup;
 		} else {
 			dev_err(hba->dev,
 				"%s: no response from device. tag = %d, err %d\n",
@@ -5728,6 +5728,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+cleanup:
 	scsi_dma_unmap(cmd);
 
 	spin_lock_irqsave(host->host_lock, flags);
-- 
2.25.1



