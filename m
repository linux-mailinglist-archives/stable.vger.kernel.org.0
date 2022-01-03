Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC914835CB
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbiACRaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:30:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38242 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiACRaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:30:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64415B8106C;
        Mon,  3 Jan 2022 17:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC70C36AF0;
        Mon,  3 Jan 2022 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231006;
        bh=31yQ4M//QHOHNxcA+8askJI836thsVQc74Z6+Lo2RIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdvk6XOI+UnMGiV84szWVDDK6adqKyFDvaMQ23PpYBk9bZ0iS2SwPMtC2qinP8ofV
         sXk+ofWmnB/BxThQU7zugg95926z9MKb89ib/w7PLwBb6VHs8bthv0JwCEzNvWbeKQ
         hGwtxm82G842bOtfYmDgu3L5QQRA4SaH1G4Bms6+1ggxeExhu04vl1QRLfg3Tqlsc1
         05tqLlBI15TXg0V+V1IsJ7uebuq+mGL2OBrQwOyZmTTdacY6IyHQX3HJ6JtpLOe3+a
         a2kdOfszMBA1xEuvQIhNde8H9rcLl1zUfBawOyEYz13jXOnZXv/yesvkzd6kYoRy8k
         xMPkH+ud1fTlA==
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
Subject: [PATCH AUTOSEL 5.10 2/8] scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()
Date:   Mon,  3 Jan 2022 12:29:55 -0500
Message-Id: <20220103173001.1613277-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173001.1613277-1-sashal@kernel.org>
References: <20220103173001.1613277-1-sashal@kernel.org>
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
index 30d27b6706746..d4e66c595eb87 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2950,6 +2950,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
+	char *tmp_persistent_address = conn->persistent_address;
+	char *tmp_local_ipaddr = conn->local_ipaddr;
 
 	del_timer_sync(&conn->transport_timer);
 
@@ -2971,8 +2973,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->frwd_lock);
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
-	kfree(conn->persistent_address);
-	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
@@ -2984,6 +2984,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	mutex_unlock(&session->eh_mutex);
 
 	iscsi_destroy_conn(cls_conn);
+	kfree(tmp_persistent_address);
+	kfree(tmp_local_ipaddr);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_teardown);
 
-- 
2.34.1

