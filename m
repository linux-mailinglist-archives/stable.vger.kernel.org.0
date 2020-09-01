Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFE3259823
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgIAQWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731010AbgIAPcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:32:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B647A20866;
        Tue,  1 Sep 2020 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974341;
        bh=p+uNYajHCNM3JrW5tTlFYkZ3P8VMd+9AAH5nA2e4Gv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Z7MWXpQ0EDBZj3Qf/LSIjIo4fPDmS2pr4bxna4jLcNem778pZEX3fXYLMBwn54Tl
         lX0Nbf+uJAcAQY6K69dCdOdI47A+LRWO8wg6JSoOvC12OxCKWAXNT69mbFx2jSVHNp
         yb/lxeW2S48Fsqwdd4i3RyKmr7a9lspkX4qrzsGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/214] scsi: ufs: Clean up completed request without interrupt notification
Date:   Tue,  1 Sep 2020 17:10:19 +0200
Message-Id: <20200901150959.642820073@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
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
index b51ccbf6cc59c..5e502e1605549 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6140,7 +6140,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 			/* command completed already */
 			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n",
 				__func__, tag);
-			goto out;
+			goto cleanup;
 		} else {
 			dev_err(hba->dev,
 				"%s: no response from device. tag = %d, err %d\n",
@@ -6174,6 +6174,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+cleanup:
 	scsi_dma_unmap(cmd);
 
 	spin_lock_irqsave(host->host_lock, flags);
-- 
2.25.1



