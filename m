Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A055712167E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbfLPSNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731109AbfLPSNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A888D207FF;
        Mon, 16 Dec 2019 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520023;
        bh=ZRk387PotmoBi8hh6QyD2phChBhzAMte6NFC0bi5/DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cad3hahEaDAIpwV4t9oUOe720T/f8TMpwg3+lsKuyYZaWa0EL4r9V6owxejp+yoVK
         HbcOfljxSuK6tWjP7epQSwchUEoWxcW2LtHdMtluCmYFSIS+UVzEvM0/Hxdh9RvsQv
         FiERqjsPbE7IFawkyaarT8yiGE2P+IEu6fJdmuso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 158/180] Revert "scsi: qla2xxx: Fix memory leak when sending I/O fails"
Date:   Mon, 16 Dec 2019 18:49:58 +0100
Message-Id: <20191216174845.614595027@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

[ Upstream commit 5a993e507ee65a28eca6690ee11868555c4ca46b ]

This reverts commit 2f856d4e8c23f5ad5221f8da4a2f22d090627f19.

This patch was found to introduce a double free regression. The issue
it originally attempted to address was fixed in patch
f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort path").

Link: https://lore.kernel.org/r/4BDE2B95-835F-43BE-A32C-2629D7E03E0A@marvell.com
Requested-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6be453985a12d..484045e4d194f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -947,8 +947,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 qc24_host_busy_free_sp:
 	sp->free(sp);
-	CMD_SP(cmd) = NULL;
-	qla2x00_rel_sp(sp);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -1038,8 +1036,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 
 qc24_host_busy_free_sp:
 	sp->free(sp);
-	CMD_SP(cmd) = NULL;
-	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
-- 
2.20.1



