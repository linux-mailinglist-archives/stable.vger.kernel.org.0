Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21B53D61FF
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhGZPdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232959AbhGZPcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5969A60F5E;
        Mon, 26 Jul 2021 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315925;
        bh=fP855E9686zR6CXMsZpON5/Cf6HNpGS9rJ5YroC0iiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjSCMqaJ7I8zmcGjwtFNo0XeOt+Msh0ASc7xwRUtPZb2JTaHCxTqAy6r9e++uCedl
         ZI9A/p8DWjHcnMyt05hj54euM6tupfNVZCR9Vs6rr13nf4nZ2941fAc9+i+Me6A5Qz
         KNgGqKAqUbLoH2AgCSzntQd6T1/Ql5zEJla7vYrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        David Disseldorp <ddiss@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 121/223] scsi: target: Fix NULL dereference on XCOPY completion
Date:   Mon, 26 Jul 2021 17:38:33 +0200
Message-Id: <20210726153850.228528804@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit a47fa41381a09e5997afd762664db4f5f6657e03 ]

CPU affinity control added with commit 39ae3edda325 ("scsi: target: core:
Make completion affinity configurable") makes target_complete_cmd() queue
work on a CPU based on se_tpg->se_tpg_wwn->cmd_compl_affinity state.

LIO's EXTENDED COPY worker is a special case in that read/write cmds are
dispatched using the global xcopy_pt_tpg, which carries a NULL se_tpg_wwn
pointer following initialization in target_xcopy_setup_pt().

The NULL xcopy_pt_tpg->se_tpg_wwn pointer is dereferenced on completion of
any EXTENDED COPY initiated read/write cmds. E.g using the libiscsi
SCSI.ExtendedCopy.Simple test:

  BUG: kernel NULL pointer dereference, address: 00000000000001a8
  RIP: 0010:target_complete_cmd+0x9d/0x130 [target_core_mod]
  Call Trace:
   fd_execute_rw+0x148/0x42a [target_core_file]
   ? __dynamic_pr_debug+0xa7/0xe0
   ? target_check_reservation+0x5b/0x940 [target_core_mod]
   __target_execute_cmd+0x1e/0x90 [target_core_mod]
   transport_generic_new_cmd+0x17c/0x330 [target_core_mod]
   target_xcopy_issue_pt_cmd+0x9/0x60 [target_core_mod]
   target_xcopy_read_source.isra.7+0x10b/0x1b0 [target_core_mod]
   ? target_check_fua+0x40/0x40 [target_core_mod]
   ? transport_complete_task_attr+0x130/0x130 [target_core_mod]
   target_xcopy_do_work+0x61f/0xc00 [target_core_mod]

This fix makes target_complete_cmd() queue work on se_cmd->cpuid if
se_tpg_wwn is NULL.

Link: https://lore.kernel.org/r/20210720225522.26291-1-ddiss@suse.de
Fixes: 39ae3edda325 ("scsi: target: core: Make completion affinity configurable")
Cc: Lee Duncan <lduncan@suse.com>
Cc: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7e35eddd9eb7..26ceabe34de5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -886,7 +886,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
 		  target_complete_failure_work);
 
-	if (wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
+	if (!wwn || wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
 		cpu = cmd->cpuid;
 	else
 		cpu = wwn->cmd_compl_affinity;
-- 
2.30.2



