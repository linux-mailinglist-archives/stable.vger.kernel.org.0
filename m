Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E8A101873
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfKSFb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbfKSFb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 359AD21939;
        Tue, 19 Nov 2019 05:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141486;
        bh=Pinh2lC8WS7vzQoxxDgtlVIhQsObFr0h8M7YlCl6gbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/FOgszXJKeYodvqVFZSXxrWb2chC8TMUle9GAzVmew2t1NtQPSSlbUv/Myo8E1hX
         +nGEe1ZHtdbFV+Vl4frP1zAVaJZsUS//sfLZCs4W09hVGT4reoLD8Lg2CcvVfYzKPT
         xtUCfT3W3VZT20SGd4MsQ9FWMf9U2uz0OP0K8GT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 176/422] scsi: qla2xxx: Fix dropped srb resource.
Date:   Tue, 19 Nov 2019 06:16:13 +0100
Message-Id: <20191119051409.841718116@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 527b8ae3948bb59c13ebaa7d657ced56ea25ab05 ]

When FW rejects a command due to "entry_status" error (malform IOCB), the srb
resource needs to be returned back for cleanup.  The filter to catch this is
in the wrong location.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f559beda8d5ad..8fa7242dbb437 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2837,6 +2837,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case ELS_IOCB_TYPE:
 	case ABORT_IOCB_TYPE:
 	case MBX_IOCB_TYPE:
+	default:
 		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 		if (sp) {
 			sp->done(sp, res);
@@ -2847,7 +2848,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case ABTS_RESP_24XX:
 	case CTIO_TYPE7:
 	case CTIO_CRC2:
-	default:
 		return 1;
 	}
 fatal:
-- 
2.20.1



