Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C4820655F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbgFWUBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387678AbgFWUBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:01:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A861820706;
        Tue, 23 Jun 2020 20:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942499;
        bh=BcoPlaJxEp4Zp/+2Aax9h0lWHxMq9slIoHXaXQK1qzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2VH58GnUQlqXbMD5TyexpLo2whxqNjMdhipMBAUnoEd1tQuGTHbMjLX2TpWcI5VI
         fzKqiuIkTI98c9h0giiUa246WcQfel+2RZYGFF3caEuMsoTSCEjvOXZDtZ/+Hu62Lq
         tO7ou0RsgEjJzhI20J+A+1fmh9bEW8pjKwafKGjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 022/477] scsi: qedi: Check for buffer overflow in qedi_set_path()
Date:   Tue, 23 Jun 2020 21:50:19 +0200
Message-Id: <20200623195408.657797136@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4a4c0cfb4be74e216dd4446b254594707455bfc6 ]

Smatch complains that the "path_data->handle" variable is user controlled.
It comes from iscsi_set_path() so that seems possible.  It's harmless to
add a limit check.

The qedi->ep_tbl[] array has qedi->max_active_conns elements (which is
always ISCSI_MAX_SESS_PER_HBA (4096) elements).  The array is allocated in
the qedi_cm_alloc_mem() function.

Link: https://lore.kernel.org/r/20200428131939.GA696531@mwanda
Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_iscsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 1f4a5fb00a057..d2e5b485afeb4 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1218,6 +1218,10 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 	}
 
 	iscsi_cid = (u32)path_data->handle;
+	if (iscsi_cid >= qedi->max_active_conns) {
+		ret = -EINVAL;
+		goto set_path_exit;
+	}
 	qedi_ep = qedi->ep_tbl[iscsi_cid];
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 		  "iscsi_cid=0x%x, qedi_ep=%p\n", iscsi_cid, qedi_ep);
-- 
2.25.1



