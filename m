Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B00D1D80C6
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgERRl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbgERRl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:41:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB1120715;
        Mon, 18 May 2020 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823717;
        bh=Kf9UdWTpewwbEiLcAFnPxTvF7LYrr5lciOCyie7P9Io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywmSXonRFLkLeLesfMLJMwOS9eY2TTtWc5o5vw+EsG3POgkAJbBEGidS4auD7YiE9
         eicbJlpbQwFiqEzxAmbqhmPkKVfASEI97tfIpUxbUiMSPGLDHTjKbLLqIoVRKpBWA9
         C+cYGUDoU/JH1j3OxH8qzjNAyKdEqkgAFwdqRMAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 50/86] scsi: qla2xxx: Avoid double completion of abort command
Date:   Mon, 18 May 2020 19:36:21 +0200
Message-Id: <20200518173500.704581304@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

[ Upstream commit 3a9910d7b686546dcc9986e790af17e148f1c888 ]

qla2x00_tmf_sp_done() now deletes the timer that will run
qla2x00_tmf_iocb_timeout(), but doesn't check whether the timer already
expired.  Check the return value from del_timer() to avoid calling
complete() a second time.

Fixes: 4440e46d5db7 ("[SCSI] qla2xxx: Add IOCB Abort command asynchronous ...")
Fixes: 1514839b3664 ("scsi: qla2xxx: Fix NULL pointer crash due to active ...")
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 41a646696babb..0772804dbc27e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -364,8 +364,8 @@ qla24xx_abort_sp_done(void *data, void *ptr, int res)
 	srb_t *sp = (srb_t *)ptr;
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
 
-	del_timer(&sp->u.iocb_cmd.timer);
-	complete(&abt->u.abt.comp);
+	if (del_timer(&sp->u.iocb_cmd.timer))
+		complete(&abt->u.abt.comp);
 }
 
 static int
-- 
2.20.1



