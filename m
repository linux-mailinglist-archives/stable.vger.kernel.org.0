Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394B9462598
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhK2WlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbhK2WkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:40:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E25C0800C3;
        Mon, 29 Nov 2021 10:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD0FAB815CF;
        Mon, 29 Nov 2021 18:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C74C53FC7;
        Mon, 29 Nov 2021 18:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211122;
        bh=onSWDIkiDhLnFuVPAEBleXNyLnBEeLn/Bz6gkiYKqR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOiXq0rNJKQXdUCMsgcohyhfZfzogB/a2jI9tpuCY/Mm3I0c+qXl+zef+7q9QExqt
         8RDp0yue4iXKHsMp0c9HwwUbbBe0phrnYo7HgQC2wX08H5p7wHTiXdWQUPi4Snx5un
         /BYbg4N1/SyOmY7Q3Mxg4Fm8Fkh0q74gUX4B+WR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/179] scsi: mpt3sas: Fix incorrect system timestamp
Date:   Mon, 29 Nov 2021 19:18:04 +0100
Message-Id: <20211129181721.899391359@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 5ecae9f8c705fae85fe4d2ed9f1b9cddf91e88e9 ]

For updating the IOC firmware's timestamp with system timestamp, the driver
issues the Mpi26IoUnitControlRequest message. While framing the
Mpi26IoUnitControlRequest, the driver should copy the lower 32 bits of the
current timestamp into IOCParameterValue field and the higher 32 bits into
Reserved7 field.

Link: https://lore.kernel.org/r/20211117123215.25487-1-sreekanth.reddy@broadcom.com
Fixes: f98790c00375 ("scsi: mpt3sas: Sync time periodically between driver and firmware")
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 27eb652b564f5..81dab9b82f79f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -639,8 +639,8 @@ static void _base_sync_drv_fw_timestamp(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request->IOCParameter = MPI26_SET_IOC_PARAMETER_SYNC_TIMESTAMP;
 	current_time = ktime_get_real();
 	TimeStamp = ktime_to_ms(current_time);
-	mpi_request->Reserved7 = cpu_to_le32(TimeStamp & 0xFFFFFFFF);
-	mpi_request->IOCParameterValue = cpu_to_le32(TimeStamp >> 32);
+	mpi_request->Reserved7 = cpu_to_le32(TimeStamp >> 32);
+	mpi_request->IOCParameterValue = cpu_to_le32(TimeStamp & 0xFFFFFFFF);
 	init_completion(&ioc->scsih_cmds.done);
 	ioc->put_smid_default(ioc, smid);
 	dinitprintk(ioc, ioc_info(ioc,
-- 
2.33.0



