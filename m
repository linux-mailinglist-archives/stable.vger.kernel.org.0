Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF1943F4E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389826AbfFMP4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731525AbfFMIvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BA8421473;
        Thu, 13 Jun 2019 08:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415871;
        bh=T2SUF5nERlkCdOrURqPAw3KiYCcClNT45NcbR3pBk6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWSbm6cCJwur7h/IXipqJvpDL42ypNTnykE7B9A60b5tpCfXn+DK8HvJnt6L6rlnc
         UlWito45sP9lFzve5G1d7bwYGG2kczpqb7k28cOB+/bh4wIblzmSPDUgRb/l8hMCHB
         tX/y3y7QhyAv9rjxHBh1g7Mqz4B6/LvwC5xA2WOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giridhar Malavali <gmalavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 127/155] scsi: qla2xxx: Reset the FCF_ASYNC_{SENT|ACTIVE} flags
Date:   Thu, 13 Jun 2019 10:33:59 +0200
Message-Id: <20190613075659.923182240@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0257eda08e806b82ee1fc90ef73583b6f022845c ]

Driver maintains state machine for processing and completing switch
commands. This patch resets FCF_ASYNC_{SENT|ACTIVE} flag to indicate if the
previous command is active or sent, in order for next GPSC command to
advance the state machine.

[mkp: commit desc typo]

Signed-off-by: Giridhar Malavali <gmalavali@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index c6fdad12428e..2e377814d7c1 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3031,6 +3031,8 @@ static void qla24xx_async_gpsc_sp_done(void *s, int res)
 	    "Async done-%s res %x, WWPN %8phC \n",
 	    sp->name, res, fcport->port_name);
 
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+
 	if (res == QLA_FUNCTION_TIMEOUT)
 		return;
 
@@ -4370,6 +4372,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
+	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }
-- 
2.20.1



