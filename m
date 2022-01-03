Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA6F483251
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiACO0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:26:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56694 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiACO0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 089AC61122;
        Mon,  3 Jan 2022 14:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2240C36AED;
        Mon,  3 Jan 2022 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219965;
        bh=bJOL+w84li+liL67SCn/kBsXUfI2qsu+dvvTOac/xEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaJSI6wRJ5377+2HKd0B1WGa9OzQ0opHzzS3t5a+soioa8B+bgaAI2EcNgCvpr+B+
         C+EzQoiTgM0c4J9zfJu6q9mUz+GQscTFbsgRgl5P8XcJzqPbXv4UK6SYVk0Dn+x1qR
         2D1AzsgXtGMWC5kkymVoyho2R/bd7Lq6Ac7484fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/27] scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()
Date:   Mon,  3 Jan 2022 15:23:48 +0100
Message-Id: <20220103142052.463553673@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
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
index 2c70e311943ac..0a908d1cc494a 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2267,8 +2267,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > 63)
+		nbytes = 63;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
-- 
2.34.1



