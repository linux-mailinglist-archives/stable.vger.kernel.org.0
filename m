Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8CF01212E1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLPR4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728303AbfLPR4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:56:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A70205ED;
        Mon, 16 Dec 2019 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519010;
        bh=b2iBoewNmDG6SQvtgQipZKZPGeAm3I9wJ4Bn3cK56kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulxb+K65Rrmy0v1sqkVhPJo/R6QRBEby70J9bMJ+y1SsYtCif2esi2qlnBSDrCKob
         uA2aqoc9dD+4iYkmowgYZvCRNKr+6cBZE9kWniLTDk5s8tlgjziD4TAZJzhrbKn8zl
         m4QwU5xLHsTghhf+zAO84WnxNqSnKhK4Or99oBp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 159/267] scsi: qla2xxx: Fix driver unload hang
Date:   Mon, 16 Dec 2019 18:48:05 +0100
Message-Id: <20191216174911.216875484@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit dd322b7f3efc8cda085bb60eadc4aee6324eadd8 upstream.

This patch fixes driver unload hang by removing msleep()

Fixes: d74595278f4ab ("scsi: qla2xxx: Add multiple queue pair functionality.")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191105150657.8092-5-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_init.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8092,8 +8092,6 @@ int qla2xxx_delete_qpair(struct scsi_qla
 	struct qla_hw_data *ha = qpair->hw;
 
 	qpair->delete_in_progress = 1;
-	while (atomic_read(&qpair->ref_count))
-		msleep(500);
 
 	ret = qla25xx_delete_req_que(vha, qpair->req);
 	if (ret != QLA_SUCCESS)


