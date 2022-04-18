Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C5E5053F1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbiDRNB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240394AbiDRM4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:56:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9355B12755;
        Mon, 18 Apr 2022 05:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFC2D611CC;
        Mon, 18 Apr 2022 12:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB34AC385B0;
        Mon, 18 Apr 2022 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285473;
        bh=plLRFRABPQzeHzsPhuHHKYd36CfjqlRb/871J9RPo7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNWUWWYSSjCIVBO6l43URLG922pn7pYfgOPpGuBDbjPzqbHQ5h+V31jF0vB4AeeGO
         C0Wt1Tr5Ar0mHsF5Fd2Z2G5MizZ//OSNJZKnPr4NzGcySuWxxCpFMy2uh49HRFcDBp
         6syWbWnSljxYUhU7OQh2Aq+MM6CepFi/kOy95/ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/105] scsi: iscsi: Force immediate failure during shutdown
Date:   Mon, 18 Apr 2022 14:12:30 +0200
Message-Id: <20220418121147.114581108@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 06c203a5566beecebb1f8838d026de8a61c8df71 ]

If the system is not up, we can just fail immediately since iscsid is not
going to ever answer our netlink events. We are already setting the
recovery_tmo to 0, but by passing stop_conn STOP_CONN_TERM we never will
block the session and start the recovery timer, because for that flag
userspace will do the unbind and destroy events which would remove the
devices and wake up and kill the eh.

Since the conn is dead and the system is going dowm this just has us use
STOP_CONN_RECOVER with recovery_tmo=0 so we fail immediately. However, if
the user has set the recovery_tmo=-1 we let the system hang like they
requested since they might have used that setting for specific reasons
(one known reason is for buggy cluster software).

Link: https://lore.kernel.org/r/20210525181821.7617-5-michael.christie@oracle.com
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 6490211b55d2..f93660142e35 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2508,11 +2508,17 @@ static void stop_conn_work_fn(struct work_struct *work)
 		session = iscsi_session_lookup(sid);
 		if (session) {
 			if (system_state != SYSTEM_RUNNING) {
-				session->recovery_tmo = 0;
-				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
-			} else {
-				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
+				/*
+				 * If the user has set up for the session to
+				 * never timeout then hang like they wanted.
+				 * For all other cases fail right away since
+				 * userspace is not going to relogin.
+				 */
+				if (session->recovery_tmo > 0)
+					session->recovery_tmo = 0;
 			}
+
+			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
 		}
 
 		list_del_init(&conn->conn_list_err);
-- 
2.35.1



