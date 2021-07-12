Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E2B3C556E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355706AbhGLIKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353645AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 069BE61CF8;
        Mon, 12 Jul 2021 07:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076582;
        bh=xQKtFhwk1WIY5bQOMEul0K5e0geDXLbfz/Sw8EAC1rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMw5Fo00VRGugCUzl+31V6reDe9rftr4eNBnKe8paE2D2hYSNY6p4B74Whfcub5uo
         /fpwaISWGoI0UMXIcF6bJ4QMyj/0IKsnb1HcTuMyMeOKav2hXK7MTMFmZnQaVju/hX
         0nqMj2pQOqL5xQBz5WBgcs6oKYt6ko7R4q0PPU4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 663/800] scsi: iscsi: Force immediate failure during shutdown
Date:   Mon, 12 Jul 2021 08:11:26 +0200
Message-Id: <20210712061037.469164625@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 82491343e94a..d134156d67f0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2513,11 +2513,17 @@ static void stop_conn_work_fn(struct work_struct *work)
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
2.30.2



