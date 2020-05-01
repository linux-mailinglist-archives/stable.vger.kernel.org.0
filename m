Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434F51C1718
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbgEAN5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730097AbgEANbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:31:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 757B824953;
        Fri,  1 May 2020 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339871;
        bh=FtfC7Z9l+PF/gQBBs9jNp4cGmr4oyYE08j4RqK3c2XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EW1jG9dwXUCeI4oxJudhwBlVsRW6UTGwo5v3uKWpAsmGFzZnaU8LRXPGrK/5mFRmj
         0Wo0O0BRXH6Fm1sbGRtl3bdHlEUIYAdvPVQwzR+jx3+PJkjyo6enqR1QIDWHJv0hy5
         eI1B3cWQo4U/l6nE0ytodKMeZys4x7IPHILZXpx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Wu Bo <wubo40@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 013/117] scsi: iscsi: Report unbind session event when the target has been removed
Date:   Fri,  1 May 2020 15:20:49 +0200
Message-Id: <20200501131546.658345368@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

[ Upstream commit 13e60d3ba287d96eeaf1deaadba51f71578119a3 ]

If the daemon is restarted or crashes while logging out of a session, the
unbind session event sent by the kernel is not processed and is lost.  When
the daemon starts again, the session can't be unbound because the daemon is
waiting for the event message. However, the kernel has already logged out
and the event will not be resent.

When iscsid restart is complete, logout session reports error:

Logging out of session [sid: 6, target: iqn.xxxxx, portal: xx.xx.xx.xx,3260]
iscsiadm: Could not logout of [sid: 6, target: iscsiadm -m node iqn.xxxxx, portal: xx.xx.xx.xx,3260].
iscsiadm: initiator reported error (9 - internal error)
iscsiadm: Could not logout of all requested sessions

Make sure the unbind event is emitted.

[mkp: commit desc and applied by hand since patch was mangled]

Link: https://lore.kernel.org/r/4eab1771-2cb3-8e79-b31c-923652340e99@huawei.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index aecb563a2b4e3..9589015234693 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2010,7 +2010,7 @@ static void __iscsi_unbind_session(struct work_struct *work)
 	if (session->target_id == ISCSI_MAX_TARGET) {
 		spin_unlock_irqrestore(&session->lock, flags);
 		mutex_unlock(&ihost->mutex);
-		return;
+		goto unbind_session_exit;
 	}
 
 	target_id = session->target_id;
@@ -2022,6 +2022,8 @@ static void __iscsi_unbind_session(struct work_struct *work)
 		ida_simple_remove(&iscsi_sess_ida, target_id);
 
 	scsi_remove_target(&session->dev);
+
+unbind_session_exit:
 	iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
 }
-- 
2.20.1



