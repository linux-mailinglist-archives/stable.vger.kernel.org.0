Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC7E35359A
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 23:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhDCVym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 17:54:42 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39822 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236415AbhDCVyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Apr 2021 17:54:41 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 00E97413B5;
        Sat,  3 Apr 2021 21:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1617486876; x=
        1619301277; bh=KrOQtI6NYKDmREp+q0M7+1vhDdS/zixMKuC0oPfasSo=; b=s
        2whaDFYbODJBLuarve7zAJAbGNA33Ie4522T+zMnAs489JO0e4OktzBGQFqijNBc
        0Y46xifIvDXl0T0BxVuwDuIybwfDn30A0Ii5exYy/Sq3tAqIbak+b2iauvgg3H4Y
        zzH7OJvGklI/kSsNJ/kD6/+oCur3DHdk9P11xHNXm0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id t1vGuVJfB5Yv; Sun,  4 Apr 2021 00:54:36 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 10A6B413B1;
        Sun,  4 Apr 2021 00:54:35 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sun, 4 Apr
 2021 00:54:35 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <martin.petersen@oracle.com>, <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] target: iscsi: Fix zero tag inside a trace event
Date:   Sun, 4 Apr 2021 00:54:15 +0300
Message-ID: <20210403215415.95077-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

target_sequencer_start event is triggered inside target_cmd_init_cdb().
se_cmd.tag is not initialized with ITT at the moment so the event always
prints zero tag.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d0e7ed8f28cc..e5c443bfbdf9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1166,6 +1166,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
+	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
 	if (cmd->sense_reason) {
 		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
@@ -1180,8 +1181,6 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
-	/* only used for printks or comparing with ->ref_task_tag */
-	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_cmd_parse_cdb(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;
-- 
2.30.1

