Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F84F5533
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389908AbfKHTAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390006AbfKHTAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 229A0214DB;
        Fri,  8 Nov 2019 19:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239650;
        bh=NOlrqPWGx4Qt4ThG2zHhGh6kwXDfKzJEe1B4BQNVwPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+K9HP8sVJCV9r4f1tdgcFgoCiUXJjSrOLy3BUTmOrg0tQagj5JzB2vGG48csgq5R
         shdW7FqtMzRQlC8xwTtlwJwjGoPquFt+/R00ruopdudlkPsSz2aajHc8u5ovNzmzL7
         rv9oATo8YblaW3HrRo7zkWRLsDX7BON/7L03UBvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Pais <allen.pais@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/79] scsi: qla2xxx: fix a potential NULL pointer dereference
Date:   Fri,  8 Nov 2019 19:49:55 +0100
Message-Id: <20191108174753.100182928@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>

[ Upstream commit 35a79a63517981a8aea395497c548776347deda8 ]

alloc_workqueue is not checked for errors and as a result a potential
NULL dereference could occur.

Link: https://lore.kernel.org/r/1568824618-4366-1-git-send-email-allen.pais@oracle.com
Signed-off-by: Allen Pais <allen.pais@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 60b6019a2fcae..856a7ceb9a041 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3186,6 +3186,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
 	ha->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
+	if (unlikely(!ha->wq)) {
+		ret = -ENOMEM;
+		goto probe_failed;
+	}
 
 	if (ha->isp_ops->initialize_adapter(base_vha)) {
 		ql_log(ql_log_fatal, base_vha, 0x00d6,
-- 
2.20.1



