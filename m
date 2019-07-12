Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF566D88
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbfGLMax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729254AbfGLMaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:30:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24F28208E4;
        Fri, 12 Jul 2019 12:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934651;
        bh=lzhyzfmwmUKawTmQ/mElfmssS/iFia+yCKcYouMRLtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAG0V7b6lutT+vTaGlbdrBWIBC5ry53DnW71EKIVCl1do2jOws3hS+HaDCR60LlKF
         p9j6BZmdvbqkOSaHNU/zd0NqXpaJQD8yI/rIPLLEUZ2RItBExaVjXtKPHx4AD9Ipfe
         QKvw8JGxaH0QdkW+Rwx/+vbjs9UJOGISN0TgQ3cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 082/138] scsi: qedi: Check targetname while finding boot target information
Date:   Fri, 12 Jul 2019 14:19:06 +0200
Message-Id: <20190712121631.884352148@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1ac3549ed58cdfdaf43bbf31ac260e2381cc0dae ]

The kernel panic was observed during iSCSI discovery via offload with below
call trace,

[ 2115.646901] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 2115.646909] IP: [<ffffffffacf7f0cc>] strncmp+0xc/0x60
[ 2115.646927] PGD 0
[ 2115.646932] Oops: 0000 [#1] SMP
[ 2115.647107] CPU: 24 PID: 264 Comm: kworker/24:1 Kdump: loaded Tainted: G
               OE  ------------   3.10.0-957.el7.x86_64 #1
[ 2115.647133] Workqueue: slowpath-13:00. qed_slowpath_task [qed]
[ 2115.647135] task: ffff8d66af80b0c0 ti: ffff8d66afb80000 task.ti: ffff8d66afb80000
[ 2115.647136] RIP: 0010:[<ffffffffacf7f0cc>]  [<ffffffffacf7f0cc>] strncmp+0xc/0x60
[ 2115.647141] RSP: 0018:ffff8d66afb83c68  EFLAGS: 00010206
[ 2115.647143] RAX: 0000000000000001 RBX: 0000000000000007 RCX: 000000000000000a
[ 2115.647144] RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff8d632b3ba040
[ 2115.647145] RBP: ffff8d66afb83c68 R08: 0000000000000000 R09: 000000000000ffff
[ 2115.647147] R10: 0000000000000007 R11: 0000000000000800 R12: ffff8d66a30007a0
[ 2115.647148] R13: ffff8d66747a3c10 R14: ffff8d632b3ba000 R15: ffff8d66747a32f8
[ 2115.647149] FS:  0000000000000000(0000) GS:ffff8d66aff00000(0000) knlGS:0000000000000000
[ 2115.647151] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2115.647152] CR2: 0000000000000000 CR3: 0000000509610000 CR4: 00000000007607e0
[ 2115.647153] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2115.647154] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2115.647155] PKRU: 00000000
[ 2115.647157] Call Trace:
[ 2115.647165]  [<ffffffffc0634cc5>] qedi_get_protocol_tlv_data+0x2c5/0x510 [qedi]
[ 2115.647184]  [<ffffffffc05968f5>] ? qed_mfw_process_tlv_req+0x245/0xbe0 [qed]
[ 2115.647195]  [<ffffffffc05496cb>] qed_mfw_fill_tlv_data+0x4b/0xb0 [qed]
[ 2115.647206]  [<ffffffffc0596911>] qed_mfw_process_tlv_req+0x261/0xbe0 [qed]
[ 2115.647215]  [<ffffffffacce0e8e>] ? dequeue_task_fair+0x41e/0x660
[ 2115.647221]  [<ffffffffacc2a59e>] ? __switch_to+0xce/0x580
[ 2115.647230]  [<ffffffffc0546013>] qed_slowpath_task+0xa3/0x160 [qed]
[ 2115.647278] RIP  [<ffffffffacf7f0cc>] strncmp+0xc/0x60

Fix kernel panic by validating the session targetname before providing TLV
data and confirming the presence of boot targets.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index e5db9a9954dc..a6ff7be0210a 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -990,6 +990,9 @@ static int qedi_find_boot_info(struct qedi_ctx *qedi,
 		if (!iscsi_is_session_online(cls_sess))
 			continue;
 
+		if (!sess->targetname)
+			continue;
+
 		if (pri_ctrl_flags) {
 			if (!strcmp(pri_tgt->iscsi_name, sess->targetname) &&
 			    !strcmp(pri_tgt->ip_addr, ep_ip_addr)) {
-- 
2.20.1



