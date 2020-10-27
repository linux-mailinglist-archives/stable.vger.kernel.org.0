Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768A229BDCB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812955AbgJ0Qqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794860AbgJ0PN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:13:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60CC620657;
        Tue, 27 Oct 2020 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811638;
        bh=7NorDwtBz89EfBAlrcmi2JV9J5c9nGobVF/FN+7wE6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxOGqyuYdyYrVukqYG7jcxMV0A8C6u9Utv8DK3vIUG7TcKGqiEd3weedKp20yLRft
         1zeKFXOQzIbDRJyHhfc6HtE8rUfpOtpE88lF1aefvBcRIU90UudFCNODUQflB+ya6+
         hmm6VPCePkXeZCRMKmia9lpgNxEieBe67f/1yMvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 565/633] scsi: target: core: Add CONTROL field for trace events
Date:   Tue, 27 Oct 2020 14:55:08 +0100
Message-Id: <20201027135549.314131585@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit 7010645ba7256992818b518163f46bd4cdf8002a ]

trace-cmd report doesn't show events from target subsystem because
scsi_command_size() leaks through event format string:

  [target:target_sequencer_start] function scsi_command_size not defined
  [target:target_cmd_complete] function scsi_command_size not defined

Addition of scsi_command_size() to plugin_scsi.c in trace-cmd doesn't
help because an expression is used inside TP_printk(). trace-cmd event
parser doesn't understand minus sign inside [ ]:

  Error: expected ']' but read '-'

Rather than duplicating kernel code in plugin_scsi.c, provide a dedicated
field for CONTROL byte.

Link: https://lore.kernel.org/r/20200929125957.83069-1-r.bolshakov@yadro.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/scsi_common.h    |  7 +++++++
 include/trace/events/target.h | 12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 731ac09ed2313..5b567b43e1b16 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -25,6 +25,13 @@ scsi_command_size(const unsigned char *cmnd)
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
 
+static inline unsigned char
+scsi_command_control(const unsigned char *cmnd)
+{
+	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
+		cmnd[1] : cmnd[COMMAND_SIZE(cmnd[0]) - 1];
+}
+
 /* Returns a human-readable name for the device */
 extern const char *scsi_device_type(unsigned type);
 
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index 77408edd29d2a..67fad2677ed55 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -141,6 +141,7 @@ TRACE_EVENT(target_sequencer_start,
 		__field( unsigned int,	opcode		)
 		__field( unsigned int,	data_length	)
 		__field( unsigned int,	task_attribute  )
+		__field( unsigned char,	control		)
 		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
 		__string( initiator,	cmd->se_sess->se_node_acl->initiatorname	)
 	),
@@ -151,6 +152,7 @@ TRACE_EVENT(target_sequencer_start,
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
+		__entry->control	= scsi_command_control(cmd->t_task_cdb);
 		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
 		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
 	),
@@ -160,9 +162,7 @@ TRACE_EVENT(target_sequencer_start,
 		  __entry->tag, show_opcode_name(__entry->opcode),
 		  __entry->data_length, __print_hex(__entry->cdb, 16),
 		  show_task_attribute_name(__entry->task_attribute),
-		  scsi_command_size(__entry->cdb) <= 16 ?
-			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
-			__entry->cdb[1]
+		  __entry->control
 	)
 );
 
@@ -178,6 +178,7 @@ TRACE_EVENT(target_cmd_complete,
 		__field( unsigned int,	opcode		)
 		__field( unsigned int,	data_length	)
 		__field( unsigned int,	task_attribute  )
+		__field( unsigned char,	control		)
 		__field( unsigned char,	scsi_status	)
 		__field( unsigned char,	sense_length	)
 		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
@@ -191,6 +192,7 @@ TRACE_EVENT(target_cmd_complete,
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
+		__entry->control	= scsi_command_control(cmd->t_task_cdb);
 		__entry->scsi_status	= cmd->scsi_status;
 		__entry->sense_length	= cmd->scsi_status == SAM_STAT_CHECK_CONDITION ?
 			min(18, ((u8 *) cmd->sense_buffer)[SPC_ADD_SENSE_LEN_OFFSET] + 8) : 0;
@@ -208,9 +210,7 @@ TRACE_EVENT(target_cmd_complete,
 		  show_opcode_name(__entry->opcode),
 		  __entry->data_length, __print_hex(__entry->cdb, 16),
 		  show_task_attribute_name(__entry->task_attribute),
-		  scsi_command_size(__entry->cdb) <= 16 ?
-			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
-			__entry->cdb[1]
+		  __entry->control
 	)
 );
 
-- 
2.25.1



