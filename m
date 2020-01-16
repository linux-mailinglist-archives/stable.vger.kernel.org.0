Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A168613E426
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388594AbgAPRG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388129AbgAPRG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99C882081E;
        Thu, 16 Jan 2020 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194387;
        bh=Bp4pI+ad+N9IwNA/+aNu2276XV/+Ac7nGVNYGPFcSlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUpJctyhckpA+XT4ElbQHetOwh9KekGPSFv090SJNxzv0DhEulcJQjBoY5Gm9+sPU
         d8MLwAWMtujnoQsF5MiGRVWN4PSLi9yajZhfs6XLsr+cwetjaRsypElrOKF1CVdJzD
         K+oUJjKl+1K9YJTpQ5LYHcuysl/YPNyQo0045UII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 316/671] scsi: qla2xxx: Fix a format specifier
Date:   Thu, 16 Jan 2020 11:59:14 -0500
Message-Id: <20200116170509.12787-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 19ce192cd718e02f880197c0983404ca48236807 ]

Since mcmd->sess->port_name is eight bytes long, use %8phC to format that
port name instead of %phC.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery") # v4.11.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e9545411ec5a..bbbe1996620b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2290,7 +2290,7 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 		    mcmd->orig_iocb.imm_ntfy.u.isp24.status_subcode ==
 		    ELS_TPRLO) {
 			ql_dbg(ql_dbg_disc, vha, 0x2106,
-			    "TM response logo %phC status %#x state %#x",
+			    "TM response logo %8phC status %#x state %#x",
 			    mcmd->sess->port_name, mcmd->fc_tm_rsp,
 			    mcmd->flags);
 			qlt_schedule_sess_for_deletion(mcmd->sess);
-- 
2.20.1

