Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A593F171FDB
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbgB0NzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731961AbgB0NzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:55:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97EA12469D;
        Thu, 27 Feb 2020 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811717;
        bh=d2Y3vdBjdlgymI0gTztZkgEs4JJBDw6qwf8ODVNVIYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdlrAuJ37Go4dbciQcX0ru2S0y80vJ4Exnvrd18+Wpnr6jZ9hS7SSzgIb6aiB4FTx
         vKtlMSTqIgHbvH6918d/Yd9QD09Mv9AseVYMbLNHLM1D/alfqqb5kKIgIJA8w0uDN3
         yZJUkhhMN6RNjsrvBu1MiVZVuSpLYd+uM39l6O2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Pais <allen.pais@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 4.14 035/237] scsi: qla2xxx: fix a potential NULL pointer dereference
Date:   Thu, 27 Feb 2020 14:34:09 +0100
Message-Id: <20200227132259.293580864@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>

commit 35a79a63517981a8aea395497c548776347deda8 upstream.

alloc_workqueue is not checked for errors and as a result a potential
NULL dereference could occur.

Link: https://lore.kernel.org/r/1568824618-4366-1-git-send-email-allen.pais@oracle.com
Signed-off-by: Allen Pais <allen.pais@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Ajay: Modified to apply on v4.14.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3178,6 +3178,10 @@ qla2x00_probe_one(struct pci_dev *pdev,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
 	ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
+	if (unlikely(!ha->wq)) {
+		ret = -ENOMEM;
+		goto probe_failed;
+	}
 
 	if (ha->mqenable) {
 		bool mq = false;


