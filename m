Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75961133106
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgAGU5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgAGU47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20722214D8;
        Tue,  7 Jan 2020 20:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430618;
        bh=aBwBqSzxGxhNrT1YnWU+12cijlj0os4qRgHbt6kJyqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzlyffdf5f5e4UZccIikFl/UDcNE7swkd9VGpngYffO+oP4PY7XIGZOXfldEmeh+c
         kOkTnikgXMwBGvDgmbiUXxiKwoXls0r0vFnu95PbrArYyt2GN/oqWNkuo6qXOR3tKP
         UeFvzbak/WO46wRr46bV1h9rzvNuTpHNHyjxE4YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/191] scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
Date:   Tue,  7 Jan 2020 21:52:27 +0100
Message-Id: <20200107205334.454832749@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit 0334cdea1fba36fad8bdf9516f267ce01de625f7 ]

The size of the buffer is hardcoded as 0x70 or 112 bytes, while the size of
ELS IOCB is 0x40 and the size of PLOGI payload returned by Get Parameters
command is 0x74.

Cc: Quinn Tran <qutran@marvell.com>
Link: https://lore.kernel.org/r/20191125165702.1013-9-r.bolshakov@yadro.com
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 44dc97cebb06..bdf1994251b9 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2684,7 +2684,8 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3073,
 		    "PLOGI ELS IOCB:\n");
 		ql_dump_buffer(ql_log_info, vha, 0x0109,
-		    (uint8_t *)els_iocb, 0x70);
+		    (uint8_t *)els_iocb,
+		    sizeof(*els_iocb));
 	} else {
 		els_iocb->control_flags = 1 << 13;
 		els_iocb->tx_byte_count =
@@ -2850,7 +2851,8 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3073, "PLOGI buffer:\n");
 	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x0109,
-	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld, 0x70);
+	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
+	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-- 
2.20.1



