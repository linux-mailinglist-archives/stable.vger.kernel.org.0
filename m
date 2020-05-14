Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8281D3C64
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgENSxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbgENSxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46691206F1;
        Thu, 14 May 2020 18:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482403;
        bh=/YIMc0DjlVGWM+fRgQmvqtFvqtfNuEA6pf5gHXY2z6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vi1qgPeZ/hbrR4u4TSF9I+Tpoce2RFPARRnKK0seboe3krRcfd9L5It0+NJWpt3KJ
         ZhTxeQu/F9uZ6okpmq1r/izjU1IwHS4zIhQtdukQO+KliJYhsKPMUpGWUcj+ydW7u8
         lJeMJiAMe+Rk6cDs9jO5fgfr6OFZfCCZU5gb6rvI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/49] scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV
Date:   Thu, 14 May 2020 14:52:30 -0400
Message-Id: <20200514185311.20294-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 45a76264c26fd8cfd0c9746196892d9b7e2657ee ]

In NPIV environment, a NPIV host may use a queue pair created by base host
or other NPIVs, so the check for a queue pair created by this NPIV is not
correct, and can cause an abort to fail, which in turn means the NVME
command not returned.  This leads to hang in nvme_fc layer in
nvme_fc_delete_association() which waits for all I/Os to be returned, which
is seen as hang in the application.

Link: https://lore.kernel.org/r/20200331104015.24868-3-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1ef8907314e58..62a16463f0254 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3117,7 +3117,7 @@ qla24xx_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
 	    "Entered %s.\n", __func__);
 
-	if (vha->flags.qpairs_available && sp->qpair)
+	if (sp->qpair)
 		req = sp->qpair->req;
 	else
 		return QLA_FUNCTION_FAILED;
-- 
2.20.1

