Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4F0489152
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbiAJHbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58392 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239405AbiAJH2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:28:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AAA6B81204;
        Mon, 10 Jan 2022 07:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94DBC36AE9;
        Mon, 10 Jan 2022 07:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799732;
        bh=zj5JQ/FB/3oH+CKU4LDmkNEXOnAYAmu7p3POgFGq5CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qs0e0INlbAbpcSBGwP4RAw0p9YHnspkPC/jMQGOSpH9A/Q2qw5P6pXJVTmYbj7Eq
         26jI8/iLYkFIr5WjALkP1iBsvr6WKrINoSOGRdyP6gefa4zr07Cyl2RXNiMyxA73Cw
         aoUsSoxfbfAXMnjvRvb3yiclRFDtRzYk69JmkGCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Tixiong <lutianxiong@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Lixiaokeng <lixiaokeng@huawei.com>,
        Linfeilong <linfeilong@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/34] scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()
Date:   Mon, 10 Jan 2022 08:23:25 +0100
Message-Id: <20220110071816.694516023@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index eeba6180711cd..f3cee64c6d12f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2948,6 +2948,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
+	char *tmp_persistent_address = conn->persistent_address;
+	char *tmp_local_ipaddr = conn->local_ipaddr;
 
 	del_timer_sync(&conn->transport_timer);
 
@@ -2969,8 +2971,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->frwd_lock);
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
-	kfree(conn->persistent_address);
-	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
@@ -2982,6 +2982,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	mutex_unlock(&session->eh_mutex);
 
 	iscsi_destroy_conn(cls_conn);
+	kfree(tmp_persistent_address);
+	kfree(tmp_local_ipaddr);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_teardown);
 
-- 
2.34.1



