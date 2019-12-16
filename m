Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98796121749
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbfLPSIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730250AbfLPSIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:08:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E86206E0;
        Mon, 16 Dec 2019 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519696;
        bh=XbOkqfHcYzoxB/Wg8L63PoBiqIPSJL8OG1qVl1X2uFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQSQhg5sfw+K5uulEVHKk3JEmRTGZ/MOHfMBy5V/4WqSFeDtDSZBIjbTo44owTq6G
         /uv0KPd7gXf9Qr3fVYedayLp3K52zD8AME2OIqYVPK99o0Ty+OdK5qkI6jjAta1C9F
         j9sGpWgKSDopZkNvL5VxHZ8H46I+dtlSVHb/v/Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.3 006/180] scsi: qla2xxx: Fix memory leak when sending I/O fails
Date:   Mon, 16 Dec 2019 18:47:26 +0100
Message-Id: <20191216174807.180209096@linuxfoundation.org>
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

From: Arun Easi <aeasi@marvell.com>

commit 2f856d4e8c23f5ad5221f8da4a2f22d090627f19 upstream.

On heavy loads, a memory leak of the srb_t structure is observed.  This
would make the qla2xxx_srbs cache gobble up memory.

Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Cc: stable@vger.kernel.org # 5.2
Link: https://lore.kernel.org/r/20191105150657.8092-7-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -947,6 +947,8 @@ qla2xxx_queuecommand(struct Scsi_Host *h
 
 qc24_host_busy_free_sp:
 	sp->free(sp);
+	CMD_SP(cmd) = NULL;
+	qla2x00_rel_sp(sp);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -1036,6 +1038,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *
 
 qc24_host_busy_free_sp:
 	sp->free(sp);
+	CMD_SP(cmd) = NULL;
+	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;


