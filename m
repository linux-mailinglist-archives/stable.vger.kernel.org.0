Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE4C148144
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390451AbgAXLSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390315AbgAXLSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A6BC20708;
        Fri, 24 Jan 2020 11:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864712;
        bh=fIGUXI15b9Akk8P4/U5g1m5oK807u80I9/7loErqzCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICVgTrbjGJsxjy6QV3IFTgGtT6GN2hjdK5GbJynsfA08TxqPzrjSjkeILc4mlApaX
         VVaju1mT5Jh6LZKZi6hNoC/0WZ15YMGY7DgtRJvK3Cq9Xm2UhUx/bUmh0J5bXl3j6P
         DeEKistSBuLJ27M85GZ35NzQIagu27Q+7sFqMimA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 331/639] scsi: qla2xxx: Fix a format specifier
Date:   Fri, 24 Jan 2020 10:28:21 +0100
Message-Id: <20200124093128.565811436@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e9545411ec5a9..bbbe1996620bf 100644
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



