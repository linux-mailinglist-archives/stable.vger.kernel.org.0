Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C501214A3
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfLPSNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731071AbfLPSNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7487C206E0;
        Mon, 16 Dec 2019 18:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519988;
        bh=fwJCKovsLkqZb80+g3AyreicO1Fvvvg4vopenRTYNig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVoZtorhEQ12DRew1ZfPGlORQ+wneijIl2obZOS8+aFM0tx1UVy8EhfCgrqk6P/1N
         fIiUMW2sgTeVgWumAiJBMxY72/jz2T8kdegLUA3CVi1AGnMnKkcYnsytw+LTl4cbU9
         8iSBDlvJRdlhgdzIpOZk7geAn3kqYVf1B8kBqDQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Carnuccio <joe.carnuccio@cavium.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 150/180] scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft
Date:   Mon, 16 Dec 2019 18:49:50 +0100
Message-Id: <20191216174844.076122064@linuxfoundation.org>
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

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit edbd56472a636ab396f5ee6783e8438fa725a6ee ]

In qla2x00_alloc_fw_dump(), an existing EFT buffer (e.g. from previous
invocation of qla2x00_alloc_offload_mem()) is freed.  The buffer is then
re-allocated, but without setting the eft and eft_dma fields to the new
values.

Fixes: a28d9e4ef997 ("scsi: qla2xxx: Add support for multiple fwdump templates/segments")
Cc: Joe Carnuccio <joe.carnuccio@cavium.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Tested-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bcd3411fc6be8..f4ed061b96886 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3317,6 +3317,8 @@ try_eft:
 		ql_dbg(ql_dbg_init, vha, 0x00c3,
 		    "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
 		eft_size = EFT_SIZE;
+		ha->eft_dma = tc_dma;
+		ha->eft = tc;
 	}
 
 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-- 
2.20.1



