Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84F848361A
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbiACRcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:32:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38740 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiACRbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:31:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43733B81082;
        Mon,  3 Jan 2022 17:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61375C36AED;
        Mon,  3 Jan 2022 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231079;
        bh=4EGK0cupgO/Up7OJsS5Gs0mvmW5A5oCJMYw8CH+TD0M=;
        h=From:To:Cc:Subject:Date:From;
        b=L1Xmr4Ax6o+iaGXEGrX2jq1EAY7opkvZWc6Ra/g92y60JzxEKiS5fFlFplALkozRg
         LFOaCbTJ4O/U6bENVIlZvk3ma3qFwtjHZjfHKRTkXFd+khsnE8q5c1AkQkEvKTQZ5S
         Pf6YsTqG02XJq/mL5phPPgWHTQmLrPPnUMXmfnLh8211RWB/XmlFsBs4Gfw+aCa7kD
         FFDOwNh13nojYJznkWjw/oVCSxNhp0fabWLNSw3WlFNbNAykVK0DMAH0P0Upa7oFpW
         vyywqaBJ+zd7Ql74IJnveWgwRqW9j7Rva0hD5okmi7mKr/SS8BGQq27MKnFUZ+qtE6
         4dplIaGVCN2mA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lixiaokeng <lixiaokeng@huawei.com>,
        Lu Tixiong <lutianxiong@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Linfeilong <linfeilong@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, cleech@redhat.com,
        jejb@linux.ibm.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/4] scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()
Date:   Mon,  3 Jan 2022 12:31:02 -0500
Message-Id: <20220103173105.1613707-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lixiaokeng <lixiaokeng@huawei.com>

[ Upstream commit 1b8d0300a3e9f216ae4901bab886db7299899ec6 ]

|- iscsi_if_destroy_conn            |-dev_attr_show
 |-iscsi_conn_teardown
  |-spin_lock_bh                     |-iscsi_sw_tcp_conn_get_param

  |-kfree(conn->persistent_address)   |-iscsi_conn_get_param
  |-kfree(conn->local_ipaddr)
                                       ==>|-read persistent_address
                                       ==>|-read local_ipaddr
  |-spin_unlock_bh

When iscsi_conn_teardown() and iscsi_conn_get_param() happen in parallel, a
UAF may be triggered.

Link: https://lore.kernel.org/r/046ec8a0-ce95-d3fc-3235-666a7c65b224@huawei.com
Reported-by: Lu Tixiong <lutianxiong@huawei.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0713d02cf1126..b1ef1aa4dd44b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2994,6 +2994,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
+	char *tmp_persistent_address = conn->persistent_address;
+	char *tmp_local_ipaddr = conn->local_ipaddr;
 
 	del_timer_sync(&conn->transport_timer);
 
@@ -3015,8 +3017,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->frwd_lock);
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
-	kfree(conn->persistent_address);
-	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
@@ -3028,6 +3028,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	mutex_unlock(&session->eh_mutex);
 
 	iscsi_destroy_conn(cls_conn);
+	kfree(tmp_persistent_address);
+	kfree(tmp_local_ipaddr);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_teardown);
 
-- 
2.34.1

