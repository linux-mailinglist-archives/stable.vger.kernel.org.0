Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C502C15AE
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfI2OFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbfI2N7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:59:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F60921835;
        Sun, 29 Sep 2019 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765560;
        bh=YcWYCDKC6Ee+vr7KG353/saGlnzVkqNyB8m/RuJQEIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP3lMCOkQ7KJkwBTSJvkIQoNAKNJoj7Ef9jLt055aa4zij6HkAF+FYzsyIvadCeZh
         uNf5ANFH7arjoplRHMRtyct9MaWjovCv+2FoYBAzdToo2cwy6HelRU2vm/tQGDvgMj
         f+Lz5s4Yq4e/gWb4dat6FD2MCh5ooTQienR7dXPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/63] scsi: qla2xxx: Return switch command on a timeout
Date:   Sun, 29 Sep 2019 15:54:13 +0200
Message-Id: <20190929135038.992548017@linuxfoundation.org>
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

From: Himanshu Madhani <himanshu.madhani@cavium.com>

[ Upstream commit ef801f07e7b3cc1786d8ab1b4fdf069cc2a136d2 ]

This patch fixes commit bcc71cc3cde1 ("scsi: qla2xxx: Fix for double
free of SRB structure") which placed code in wrong routines.

Also updated the use of WARN_ON() to WARN_ON_ONCE() to prevent
flooding log messages.

Fixes: bcc71cc3cde1 ("scsi: qla2xxx: Fix for double free of SRB structure")
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 39a8f4a671aaa..7c1f36b69bdc3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -54,7 +54,7 @@ qla2x00_sp_timeout(struct timer_list *t)
 	unsigned long flags;
 	struct qla_hw_data *ha = sp->vha->hw;
 
-	WARN_ON(irqs_disabled());
+	WARN_ON_ONCE(irqs_disabled());
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	req = sp->qpair->req;
 	req->outstanding_cmds[sp->handle] = NULL;
@@ -796,6 +796,9 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 	    sp->name, res, sp->u.iocb_cmd.u.mbx.in_mb[1],
 	    sp->u.iocb_cmd.u.mbx.in_mb[2]);
 
+	if (res == QLA_FUNCTION_TIMEOUT)
+		return;
+
 	memset(&ea, 0, sizeof(ea));
 	ea.sp = sp;
 	ea.rc = res;
@@ -979,17 +982,13 @@ void qla24xx_async_gpdb_sp_done(void *s, int res)
 	    "Async done-%s res %x, WWPN %8phC mb[1]=%x mb[2]=%x \n",
 	    sp->name, res, fcport->port_name, mb[1], mb[2]);
 
-	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
-
-	if (res == QLA_FUNCTION_TIMEOUT)
-		return;
-
 	if (res == QLA_FUNCTION_TIMEOUT) {
 		dma_pool_free(sp->vha->hw->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
 			sp->u.iocb_cmd.u.mbx.in_dma);
 		return;
 	}
 
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	memset(&ea, 0, sizeof(ea));
 	ea.event = FCME_GPDB_DONE;
 	ea.fcport = fcport;
-- 
2.20.1



