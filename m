Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD30F49C0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389421AbfKHLlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389383AbfKHLlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E616E222CF;
        Fri,  8 Nov 2019 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213282;
        bh=8QGmzeogi6k2oblfvGFyTdoWO5OoMRPbPTDlYihF9qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtGrG4MLY1S/Mtn6JNMljWULqjgMi/pnnQYyYubXbTaliM9qb+wFE66ik0N6gU9sT
         dQdjC3d3KgXLpY1LZwFWOFHZvZ33UEuhuemIrQAPpsA42UhDI8q2S6QPX5mp6QCcm0
         kDbOG9LMZHqwjwrsVXZB9FHDvRP5VwIgCVoQqQ20=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sawan Chandak <sawan.chandak@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 143/205] scsi: qla2xxx: Check for Register disconnect
Date:   Fri,  8 Nov 2019 06:36:50 -0500
Message-Id: <20191108113752.12502-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index bfbdec61b3c6e..cb7f4d59343f0 100644
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

