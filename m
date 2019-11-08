Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C737EF489D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390911AbfKHLou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:44:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390900AbfKHLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48712245A;
        Fri,  8 Nov 2019 11:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213488;
        bh=Pa2DiUzIt5+WJpajolX0XfJiLPV7WRel0zK4pP7B+9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPBr/Zfanq6dMod+o/S3rQcd4zF7vZ+uwGgR3X3K7g+3oJotpjV0QhzJ6vIn2D9eM
         EIdbcKMAUtRMy9xWLLAuZhVyKoGDPThcc8hV0HfQ3ucvrxWwKzQWY+aUHM0r8C20W8
         VTK3yFcdCIWbtHt7KEYxKiVJenSVXe+NESJiExzU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 068/103] scsi: qla2xxx: Fix iIDMA error
Date:   Fri,  8 Nov 2019 06:42:33 -0500
Message-Id: <20191108114310.14363-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 8d9bf0a9a268f7ca0b811d6e6a1fc783afa5c746 ]

When switch responds with error for Get Port Speed Command (GPSC), driver
should not proceed with telling FW about the speed of the remote port.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 2a19ec0660cbb..1088038e6a418 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3033,7 +3033,7 @@ static void qla24xx_async_gpsc_sp_done(void *s, int res)
 			ql_dbg(ql_dbg_disc, vha, 0x2019,
 			    "GPSC command unsupported, disabling query.\n");
 			ha->flags.gpsc_supported = 0;
-			res = QLA_SUCCESS;
+			goto done;
 		}
 	} else {
 		switch (be16_to_cpu(ct_rsp->rsp.gpsc.speed)) {
@@ -3066,13 +3066,13 @@ static void qla24xx_async_gpsc_sp_done(void *s, int res)
 		    be16_to_cpu(ct_rsp->rsp.gpsc.speeds),
 		    be16_to_cpu(ct_rsp->rsp.gpsc.speed));
 	}
-done:
 	memset(&ea, 0, sizeof(ea));
 	ea.event = FCME_GPSC_DONE;
 	ea.rc = res;
 	ea.fcport = fcport;
 	qla2x00_fcport_event_handler(vha, &ea);
 
+done:
 	sp->free(sp);
 }
 
-- 
2.20.1

