Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF8D50F5DD
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiDZIzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347049AbiDZIvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F021C1738CA;
        Tue, 26 Apr 2022 01:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 504116090C;
        Tue, 26 Apr 2022 08:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCFEC385A0;
        Tue, 26 Apr 2022 08:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962364;
        bh=JQxcb8I4zW0fNZWM3VRNh61ptw73ZrM7m53hpGMdlrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCeSLxDsmVgAcUWtvYwEPQ9V/SF/d4E/6Xk+1gA1rdW0sBgJbGeAy1X/iVHa8fqur
         gpEiIFcJ3Qa/dElOCUVlsPdt9nIkScya+pStNwSuwfVgZLKLWZZVG4O5ATbW3Huj51
         rxLvtyKxR9iRl0hfsw+Wm18aWp5uYhPqd8NSjb+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/124] scsi: iscsi: Fix NOP handling during conn recovery
Date:   Tue, 26 Apr 2022 10:21:11 +0200
Message-Id: <20220426081749.291563079@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 44ac97109e42f87b1a34954704b81b6c8eca80c4 ]

If a offload driver doesn't use the xmit workqueue, then when we are doing
ep_disconnect libiscsi can still inject PDUs to the driver. This adds a
check for if the connection is bound before trying to inject PDUs.

Link: https://lore.kernel.org/r/20220408001314.5014-9-michael.christie@oracle.com
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 7 ++++++-
 include/scsi/libiscsi.h | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a4f26431b033..0f2c7098f9d6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -678,7 +678,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_task *task;
 	itt_t itt;
 
-	if (session->state == ISCSI_STATE_TERMINATE)
+	if (session->state == ISCSI_STATE_TERMINATE ||
+	    !test_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags))
 		return NULL;
 
 	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
@@ -2214,6 +2215,8 @@ void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->frwd_lock);
+	clear_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
+
 	if (!is_active) {
 		/*
 		 * if logout timed out before userspace could even send a PDU
@@ -3312,6 +3315,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	spin_lock_bh(&session->frwd_lock);
 	if (is_leading)
 		session->leadconn = conn;
+
+	set_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
 	spin_unlock_bh(&session->frwd_lock);
 
 	/*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index bdb0ae11682d..d1e282f0d6f1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -55,7 +55,7 @@ enum {
 /* Connection flags */
 #define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
 #define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
-
+#define ISCSI_CONN_FLAG_BOUND		BIT(2)
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
-- 
2.35.1



