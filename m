Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F1F483323
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiACOdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbiACOby (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:31:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1AEC061191;
        Mon,  3 Jan 2022 06:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B8361073;
        Mon,  3 Jan 2022 14:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCE0C36AED;
        Mon,  3 Jan 2022 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220268;
        bh=dWFiXWuT8Fs5pOOi3ytTsbEma3qMU8GwaHVWrXT0vEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF3Q8UoFSKHoIehkGmqATX4MNHT1sWvVVdAPIPrjHAy/Pv0155JPO0UaahXdwKn1Y
         y6LmUxwYeB+5WFK2Y4I9d/hk47ZXZEo4iWtShV/uTBA3h5cBWNcouyW45+2si3Kuo7
         qwCLcnOedXX+JhJ99NTtspd2C+rCYPVqAeLH5rNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/73] scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()
Date:   Mon,  3 Jan 2022 15:23:37 +0100
Message-Id: <20220103142057.444584128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9020be114a47bf7ff33e179b3bb0016b91a098e6 ]

The "mybuf" string comes from the user, so we need to ensure that it is NUL
terminated.

Link: https://lore.kernel.org/r/20211214070527.GA27934@kili
Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index bd6d459afce54..08b2e85dcd7d8 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2954,8 +2954,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > 63)
+		nbytes = 63;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
-- 
2.34.1



