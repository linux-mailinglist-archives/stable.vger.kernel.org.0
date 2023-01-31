Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A67C6830C2
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbjAaPGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjAaPFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:05:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ACC577CC;
        Tue, 31 Jan 2023 07:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C545B61567;
        Tue, 31 Jan 2023 15:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13672C433D2;
        Tue, 31 Jan 2023 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177266;
        bh=7YfFs3WB6ppclQlIDVFaLm+5ix7OyMw56irnbRIMRSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGF0crNkrokp/ZlXTvuE9DIUoJN6Lrw78svSt235idBjkTtrIXRYyohHQzTmEVc3v
         zZwtLuwdfjgzA6MhJcA380jvhwsJkNlTvtg1KudxG1jE86rY2uRQY+ZTaqVs9nIwDQ
         oRbxBJ2bCCyI6Y+9hOzjswQ6CojPTlYNTAxUtT+OSyWQjJrVA+Li+iFdYblU8a6rii
         sjM+IzzFDnFCU8V3CRwY88f48djf8TbR0I3eIu/WR28blkzdl/Cv+dziu9Hi208u61
         FWQV8NS2En3TKl+5qc3ur/5sefxqkLSHn7vuG7WopJuxZBHwyBHIvQAWp+2FZzoULN
         OGSOh0viZtxhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Ding Hui <dinghui@sangfor.com.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, cleech@redhat.com,
        jejb@linux.ibm.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/6] scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress
Date:   Tue, 31 Jan 2023 10:00:55 -0500
Message-Id: <20230131150100.1250267-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150100.1250267-1-sashal@kernel.org>
References: <20230131150100.1250267-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit f484a794e4ee2a9ce61f52a78e810ac45f3fe3b3 ]

If during iscsi_sw_tcp_session_create() iscsi_tcp_r2tpool_alloc() fails,
userspace could be accessing the host's ipaddress attr. If we then free the
session via iscsi_session_teardown() while userspace is still accessing the
session we will hit a use after free bug.

Set the tcp_sw_host->session after we have completed session creation and
can no longer fail.

Link: https://lore.kernel.org/r/20230117193937.21244-3-michael.christie@oracle.com
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Acked-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_tcp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 6485c1aa9e74..252d7881f99c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -802,7 +802,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 				       enum iscsi_host_param param, char *buf)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
-	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
@@ -812,6 +812,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
+		session = tcp_sw_host->session;
 		if (!session)
 			return -ENOTCONN;
 
@@ -906,12 +907,14 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
-	tcp_sw_host = iscsi_host_priv(shost);
-	tcp_sw_host->session = session;
 
 	shost->can_queue = session->scsi_cmds_max;
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
+
+	/* We are now fully setup so expose the session to sysfs. */
+	tcp_sw_host = iscsi_host_priv(shost);
+	tcp_sw_host->session = session;
 	return cls_session;
 
 remove_session:
-- 
2.39.0

