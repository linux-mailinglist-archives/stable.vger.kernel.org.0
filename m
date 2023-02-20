Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA32769CC45
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjBTNiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjBTNiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:38:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610971C331
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:38:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19CB3B80D48
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD76C4339B;
        Mon, 20 Feb 2023 13:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900327;
        bh=nFL98HanffDr/9tMYNjucP1NEOPJIbYQ6Acved+q6Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiCxP17dOO279DrcPrHAJrfTRFggLO/ErfkmL5vvoJ8nCIHVcHJlm7z1XseuwL3Kx
         2uChrpY8Zhoe3o7iXUIHH/vd/DzZ9f0Wl25zmBeCXHDHFy+z/U2MFL8E/zSHwtysSU
         7dogT8D5/IqYNe77C1hWzLInD4ra4JCagsGFWlhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Ding Hui <dinghui@sangfor.com.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/53] scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress
Date:   Mon, 20 Feb 2023 14:35:35 +0100
Message-Id: <20230220133548.514792185@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index e3ca16043f9a..9161fe8fba88 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -773,7 +773,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 				       enum iscsi_host_param param, char *buf)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
-	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
@@ -782,6 +782,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
+		session = tcp_sw_host->session;
 		if (!session)
 			return -ENOTCONN;
 
@@ -870,12 +871,14 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
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



