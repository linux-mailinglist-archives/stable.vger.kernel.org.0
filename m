Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA721FE303
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgFRCFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgFRBWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0A7120663;
        Thu, 18 Jun 2020 01:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443361;
        bh=aOufcwBmOp7E2fx+crtfEfqmLoPsbiYvQABJl+tdg3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpP4MiUR+xRUOpCCCIcXcLWvkEGX5/3b2loQuZ1UgKa5KRypyfeMftNKlNIZZHDnZ
         LJ3ZAwmCuPcZAin4SGZVD8ItvD6XoREDrnZoc34f1ZUihwYYqd4cYyymKrjhDOuAOm
         vgab8kW03n+K1DSAwvO6LSl2sDXPdlxXG5FZclKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viacheslav Dubeyko <v.dubeiko@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 018/172] scsi: qla2xxx: Fix issue with adapter's stopping state
Date:   Wed, 17 Jun 2020 21:19:44 -0400
Message-Id: <20200618012218.607130-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viacheslav Dubeyko <v.dubeiko@yadro.com>

[ Upstream commit 803e45550b11c8e43d89812356fe6f105adebdf9 ]

The goal of the following command sequence is to restart the adapter.
However, the tgt_stop flag remains set, indicating that the adapter is
still in stopping state even after re-enabling it.

echo 0x7fffffff > /sys/module/qla2xxx/parameters/logging
modprobe target_core_mod
modprobe tcm_qla2xxx
mkdir /sys/kernel/config/target/qla2xxx
mkdir /sys/kernel/config/target/qla2xxx/<port-name>
mkdir /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1
echo 1 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable
echo 0 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable
echo 1 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable

kernel: PID 1396:qla_target.c:1555 qlt_stop_phase1(): tgt_stop 0x0, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-e803:1: PID 1396:qla_target.c:1567: Stopping target for host 1(c0000000033557e8)
kernel: PID 1396:qla_target.c:1579 qlt_stop_phase1(): tgt_stop 0x1, tgt_stopped 0x0
kernel: PID 1396:qla_target.c:1266 qlt_schedule_sess_for_deletion(): tgt_stop 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-e801:1: PID 1396:qla_target.c:1316: Scheduling sess c00000002d5cd800 for deletion 21:00:00:24:ff:7f:35:c7
<skipped>
kernel: qla2xxx [0001:00:02.0]-290a:1: PID 340:qla_target.c:1187: qlt_unreg_sess sess c00000002d5cd800 for deletion 21:00:00:24:ff:7f:35:c7
<skipped>
kernel: qla2xxx [0001:00:02.0]-f801:1: PID 340:qla_target.c:1145: Unregistration of sess c00000002d5cd800 21:00:00:24:ff:7f:35:c7 finished fcp_cnt 0
kernel: PID 340:qla_target.c:1155 qlt_free_session_done(): tgt_stop 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-4807:1: PID 346:qla_os.c:6329: ISP abort scheduled.
<skipped>
kernel: qla2xxx [0001:00:02.0]-28f1:1: PID 346:qla_os.c:3956: Mark all dev lost
kernel: PID 346:qla_target.c:1266 qlt_schedule_sess_for_deletion(): tgt_stop 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-4808:1: PID 346:qla_os.c:6338: ISP abort end.
<skipped>
kernel: PID 1396:qla_target.c:6812 qlt_enable_vha(): tgt_stop 0x1, tgt_stopped 0x0
<skipped>
kernel: qla2xxx [0001:00:02.0]-4807:1: PID 346:qla_os.c:6329: ISP abort scheduled.
<skipped>
kernel: qla2xxx [0001:00:02.0]-4808:1: PID 346:qla_os.c:6338: ISP abort end.

qlt_handle_cmd_for_atio() rejects the request to send commands because the
adapter is in the stopping state:

kernel: PID 0:qla_target.c:4442 qlt_handle_cmd_for_atio(): tgt_stop 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-3861:1: PID 0:qla_target.c:4447: New command while device c000000005314600 is shutting down
kernel: qla2xxx [0001:00:02.0]-e85f:1: PID 0:qla_target.c:5728: qla_target: Unable to send command to target

This patch calls qla_stop_phase2() in addition to qlt_stop_phase1() in
tcm_qla2xxx_tpg_enable_store() and tcm_qla2xxx_npiv_tpg_enable_store(). The
qlt_stop_phase1() marks adapter as stopping (tgt_stop == 0x1, tgt_stopped
== 0x0) but qlt_stop_phase2() marks adapter as stopped (tgt_stop == 0x0,
tgt_stopped == 0x1).

Link: https://lore.kernel.org/r/52be1e8a3537f6c5407eae3edd4c8e08a9545ea5.camel@yadro.com
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 654e1af7f542..b51dba35bcf7 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -960,6 +960,7 @@ static ssize_t tcm_qla2xxx_tpg_enable_store(struct config_item *item,
 
 		atomic_set(&tpg->lport_tpg_enabled, 0);
 		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
+		qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 	}
 
 	return count;
@@ -1122,6 +1123,7 @@ static ssize_t tcm_qla2xxx_npiv_tpg_enable_store(struct config_item *item,
 
 		atomic_set(&tpg->lport_tpg_enabled, 0);
 		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
+		qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 	}
 
 	return count;
-- 
2.25.1

