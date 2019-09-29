Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81828C14F0
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfI2N7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbfI2N7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:59:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 679E621835;
        Sun, 29 Sep 2019 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765553;
        bh=347XeaNdPJ+bx8b/BEW4Kw1Lti+PBow2zX+LzVv5hsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O49Zf4xp9fMLylRHUnijpCzphztFg4JCtmtcj0pD5jepYzwtqCzj9n6nIPf868M/H
         YQQQPCUZhhyRY45b6hNHqSE+nIqb4MSnQpD7ByqppsjchsbTNO0ENbOLJltxcX0Ipr
         QIOYATx3IRNKlZfHY6FT6OYtJpx4m+lyU89JJO1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/63] scsi: qla2xxx: Turn off IOCB timeout timer on IOCB completion
Date:   Sun, 29 Sep 2019 15:54:11 +0200
Message-Id: <20190929135038.749635490@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit e112761a4f1dcbe9fb9f43f46de7be69d6963b0d ]

Turn off IOCB timeout timer on IOCB completion instead of turning it off in a
deferred task.  This prevent false alarm if the deferred task is stalled out.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index fc08e46a93ca9..98d936f18b65e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4225,10 +4225,13 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 		return;
 	}
 
-	if (cmd == GPN_FT_CMD)
+	if (cmd == GPN_FT_CMD) {
+		del_timer(&sp->u.iocb_cmd.timer);
 		e = qla2x00_alloc_work(vha, QLA_EVT_GPNFT_DONE);
-	else
+	} else {
 		e = qla2x00_alloc_work(vha, QLA_EVT_GNNFT_DONE);
+	}
+
 	if (!e) {
 		/* please ignore kernel warning. Otherwise, we have mem leak. */
 		if (sp->u.iocb_cmd.u.ctarg.req) {
@@ -4357,7 +4360,6 @@ void qla24xx_async_gpnft_done(scsi_qla_host_t *vha, srb_t *sp)
 {
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "%s enter\n", __func__);
-	del_timer(&sp->u.iocb_cmd.timer);
 	qla24xx_async_gnnft(vha, sp, sp->gen2);
 }
 
-- 
2.20.1



