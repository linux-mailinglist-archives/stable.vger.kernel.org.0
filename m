Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D4F65180C
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiLTBYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiLTBWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:22:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AEBFCCE;
        Mon, 19 Dec 2022 17:21:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 641F56122C;
        Tue, 20 Dec 2022 01:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F5BC433F0;
        Tue, 20 Dec 2022 01:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499313;
        bh=meXrmIHc4uB22MVvnpTkZ0t6/lXPGSax7WRu1NPzbQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CY8/VzROTZcB8q71U70ILPgIXT1JwhIJfYS4CqGFlffiPRUPExsVF9ZkfSjGA14+1
         pWIObzXHVF4QznJ+IYky/Mb+ic+825GuE/I2416CyOH1+LGqf7+QZbOlmBRWWd5vLX
         HmuvXZxNBrc9lnMBSwNI7MirrTQWKYq7as/5R4V21zsB5VFauLq0tpHvoWpA7j+GEK
         MFssHw3Kg1eFFfJK4YgUdjcSWL1yeu6mg6lRVSchhOe0X7x0qu7JiKqFL4LLpJKrlY
         r8tNPhMZTefyee0CfaIBAdApmjtAh4hfUGsMqswXk06jAZNRNcqk0h3iXNCO9DLVbW
         zzNd1gqQyjcAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, d.bogdanov@yadro.com,
        k.shelekhin@yadro.com, mgurtovoy@nvidia.com,
        yang.lee@linux.alibaba.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 12/16] scsi: target: iscsi: Fix a race condition between login_work and the login thread
Date:   Mon, 19 Dec 2022 20:21:22 -0500
Message-Id: <20221220012127.1222311-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012127.1222311-1-sashal@kernel.org>
References: <20221220012127.1222311-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit fec1b2fa62c162d03f5dcd7b03e3c89d3116d49f ]

In case a malicious initiator sends some random data immediately after a
login PDU; the iscsi_target_sk_data_ready() callback will schedule the
login_work and, at the same time, the negotiation may end without clearing
the LOGIN_FLAGS_INITIAL_PDU flag (because no additional PDU exchanges are
required to complete the login).

The login has been completed but the login_work function will find the
LOGIN_FLAGS_INITIAL_PDU flag set and will never stop from rescheduling
itself; at this point, if the initiator drops the connection, the
iscsit_conn structure will be freed, login_work will dereference a released
socket structure and the kernel crashes.

BUG: kernel NULL pointer dereference, address: 0000000000000230
PF: supervisor write access in kernel mode
PF: error_code(0x0002) - not-present page
Workqueue: events iscsi_target_do_login_rx [iscsi_target_mod]
RIP: 0010:_raw_read_lock_bh+0x15/0x30
Call trace:
 iscsi_target_do_login_rx+0x75/0x3f0 [iscsi_target_mod]
 process_one_work+0x1e8/0x3c0

Fix this bug by forcing login_work to stop after the login has been
completed and the socket callbacks have been restored.

Add a comment to clearify the return values of iscsi_target_do_login()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Link: https://lore.kernel.org/r/20221115125638.102517-1-mlombard@redhat.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_nego.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index f2919319ad38..ff49c8f3fe24 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1018,6 +1018,13 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 	return 0;
 }
 
+/*
+ * RETURN VALUE:
+ *
+ *  1 = Login successful
+ * -1 = Login failed
+ *  0 = More PDU exchanges required
+ */
 static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *login)
 {
 	int pdu_count = 0;
@@ -1363,12 +1370,13 @@ int iscsi_target_start_negotiation(
 		ret = -1;
 
 	if (ret < 0) {
-		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_target_restore_sock_callbacks(conn);
 		iscsi_remove_failed_auth_entry(conn);
 	}
-	if (ret != 0)
+	if (ret != 0) {
+		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_target_nego_release(conn);
+	}
 
 	return ret;
 }
-- 
2.35.1

