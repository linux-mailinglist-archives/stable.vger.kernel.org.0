Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CAD101872
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfKSFbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfKSFbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D9E6208C3;
        Tue, 19 Nov 2019 05:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141480;
        bh=KspOQ7OWR0/rKrKwCBWrNkPIFMC56qooUenNOLlMcYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiF+NPj4zcwyxztZYleFRA7gcdZCmFtkHQVmw8kicraFm2eL1YEZq3rxbIskhhwpp
         ZvzVObZY8EMCnSqKRD0dq7inacGkEqzVUlweiklFoRErakVOxxjTiKSmJVIovPigh/
         u/1iIj2PlM/GDgxuiKVYbNl2yYd0Wohxs1JW5kKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sawan Chandak <sawan.chandak@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/422] scsi: qla2xxx: Check for Register disconnect
Date:   Tue, 19 Nov 2019 06:16:11 +0100
Message-Id: <20191119051409.707280195@linuxfoundation.org>
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

From: Sawan Chandak <sawan.chandak@cavium.com>

[ Upstream commit f99c5d294b3653e6ae563eaac5db5b4138afe31c ]

During adapter shutdown process check for register disconnect before
proceeding to call PCI functions.

Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d978ea1344625..3e892e013658d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1744,6 +1744,7 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 				    !ha->flags.eeh_busy &&
 				    (!test_bit(ABORT_ISP_ACTIVE,
 					&vha->dpc_flags)) &&
+				    !qla2x00_isp_reg_stat(ha) &&
 				    (sp->type == SRB_SCSI_CMD)) {
 					/*
 					 * Don't abort commands in
-- 
2.20.1



