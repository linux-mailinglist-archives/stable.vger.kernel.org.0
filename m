Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596E645BC57
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244959AbhKXM1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244187AbhKXMZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:25:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19406124F;
        Wed, 24 Nov 2021 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756168;
        bh=AUBpS3ubOHiAhI5sJh5pGe9SIkaMFAgSqepsC0LcDGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHO5+KxCudv3gAgw/Azm7DPSmg+Al02CU/ZSoolu00wczHlVQ1HYY/b3pBG4ujaG0
         sV2N1ZC6gQT2raDIBWkvgyhI6Li4pYIhywCjTgB/8p2adqYu4XyhNCGTx8LwDjmvNa
         Ebz2MbiZOXrN//oZdKiXCvMhRhVHoLhDtrDmgXxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 165/207] scsi: advansys: Fix kernel pointer leak
Date:   Wed, 24 Nov 2021 12:57:16 +0100
Message-Id: <20211124115709.340782045@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Zhi <qtxuning1999@sjtu.edu.cn>

[ Upstream commit d4996c6eac4c81b8872043e9391563f67f13e406 ]

Pointers should be printed with %p or %px rather than cast to 'unsigned
long' and printed with %lx.

Change %lx to %p to print the hashed pointer.

Link: https://lore.kernel.org/r/20210929122538.1158235-1-qtxuning1999@sjtu.edu.cn
Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 24e57e770432b..6efd17692a55a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3370,8 +3370,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		   shost->host_no);
 
 	seq_printf(m,
-		   " iop_base 0x%lx, cable_detect: %X, err_code %u\n",
-		   (unsigned long)v->iop_base,
+		   " iop_base 0x%p, cable_detect: %X, err_code %u\n",
+		   v->iop_base,
 		   AdvReadWordRegister(iop_base,IOPW_SCSI_CFG1) & CABLE_DETECT,
 		   v->err_code);
 
-- 
2.33.0



