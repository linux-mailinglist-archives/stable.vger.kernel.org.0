Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909591BCBED
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgD1S0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728673AbgD1S0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:26:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A468208E0;
        Tue, 28 Apr 2020 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098375;
        bh=4r6aacRDYq6Hlwz2V30XSValEQ2V7Q+sqM4zheLkdQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHsx6PxKzE95n8/9jNVeilSrVbRPQcQYJhrkA4xycq2mkIA5ixIaddQQVNbB83Mqc
         aocyK798ylsITZoy0wjooNn7vsr8lVmET3cXUBqtHSyDhj5AOAOZ8C/92SNJxy/zkJ
         YYH9JArVUh82csewlL1jhBHKnUxvjZxz9zcNBBKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Wu Bo <wubo40@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 015/167] scsi: iscsi: Report unbind session event when the target has been removed
Date:   Tue, 28 Apr 2020 20:23:11 +0200
Message-Id: <20200428182227.152115606@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
index dfc726fa34e34..443ace019852f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2012,7 +2012,7 @@ static void __iscsi_unbind_session(struct work_struct *work)
 	if (session->target_id == ISCSI_MAX_TARGET) {
 		spin_unlock_irqrestore(&session->lock, flags);
 		mutex_unlock(&ihost->mutex);
-		return;
+		goto unbind_session_exit;
 	}
 
 	target_id = session->target_id;
@@ -2024,6 +2024,8 @@ static void __iscsi_unbind_session(struct work_struct *work)
 		ida_simple_remove(&iscsi_sess_ida, target_id);
 
 	scsi_remove_target(&session->dev);
+
+unbind_session_exit:
 	iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
 }
-- 
2.20.1



