Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B051D121498
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbfLPSMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730993AbfLPSMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E5F21582;
        Mon, 16 Dec 2019 18:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519964;
        bh=AXCS24bMiz5Bb0xzUxIt8oDfRwDtdzooXWjmdPF5MMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgCAg100FfxCvyj7YyG764Zerannu28cnfBUnMTbpPg6odq3Xl0WwNjyhubuibtOS
         JbgGTAWS0ONsIlV7oq40KmUSSG1yi1kK2q5oDxbRVYoQr0GiP35cyCseZ2MNi/y0aU
         8FyADy+tEtcb6StD/KgE67y3VFijfq/fY0iuWcCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 141/180] scsi: qla2xxx: Fix NVMe port discovery after a short device port loss
Date:   Mon, 16 Dec 2019 18:49:41 +0100
Message-Id: <20191216174843.037897728@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 9e744591ef1b8df27c25c68dac858dada8688f77 ]

The following sequence of event leads to NVME port disappearing:

    - device port shut
    - nvme_fc_unregister_remoteport
    - device port online
    - remote port delete completes
    - relogin is scheduled
    - "post gidpn" message appears due to rscn generation # mismatch

In short, if a device comes back online sooner than an unregister
completion, a mismatch in rscn generation number occurs, which is not
handled correctly during device relogin. Fix this by starting with a redo
of GNL.

When ql2xextended_error_logging is enabled, the re-plugged device's
discovery stops with the following messages printed:

--8<--
qla2xxx [0000:41:00.0]-480d:3: Relogin scheduled.
qla2xxx [0000:41:00.0]-4800:3: DPC handler sleeping.
qla2xxx [0000:41:00.0]-2902:3: qla24xx_handle_relogin_event 21:00:00:24:ff:17:9e:91 DS 0 LS 7 P 0 del 2 cnfl
   (null) rscn 1|2 login 1|2 fl 1
qla2xxx [0000:41:00.0]-28e9:3: qla24xx_handle_relogin_event 1666 21:00:00:24:ff:17:9e:91 post gidpn
qla2xxx [0000:41:00.0]-480e:3: Relogin end.
--8<--

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a75a40b14140a..2c617a34ae1e7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1712,9 +1712,9 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 	}
 
 	if (fcport->last_rscn_gen != fcport->rscn_gen) {
-		ql_dbg(ql_dbg_disc, vha, 0x20e9, "%s %d %8phC post gidpn\n",
+		ql_dbg(ql_dbg_disc, vha, 0x20e9, "%s %d %8phC post gnl\n",
 		    __func__, __LINE__, fcport->port_name);
-
+		qla24xx_post_gnl_work(vha, fcport);
 		return;
 	}
 
-- 
2.20.1



