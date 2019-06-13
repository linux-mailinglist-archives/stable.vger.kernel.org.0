Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F144A44157
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbfFMQNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbfFMIms (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:42:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E3E121479;
        Thu, 13 Jun 2019 08:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415367;
        bh=Rr5mg9fg85M46vDGUr8i07bvXIQUBUKS7QRutZEt8Xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1N7E8jIXW135MWVkAvkjVC4PUfAC7b4J2IvwWQ81D95J1GS0Lb9Y7pSeHdGRdfhW
         s84lliGvRthwK0wPjHo15vrZ2Y8q00hdUlc5wJnUT028nFwBAO54MkNKgCHGLrA0dq
         1YEdnn/gOl35jmWHNBXBns+UVYQhly9PM2uA498c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giridhar Malavali <gmalavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/118] scsi: qla2xxx: Reset the FCF_ASYNC_{SENT|ACTIVE} flags
Date:   Thu, 13 Jun 2019 10:33:56 +0200
Message-Id: <20190613075649.645249428@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
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
index de3f2a097451..1f1a05a90d3d 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3261,6 +3261,8 @@ static void qla24xx_async_gpsc_sp_done(void *s, int res)
 	    "Async done-%s res %x, WWPN %8phC \n",
 	    sp->name, res, fcport->port_name);
 
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+
 	if (res == QLA_FUNCTION_TIMEOUT)
 		return;
 
@@ -4604,6 +4606,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
+	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }
-- 
2.20.1



