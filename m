Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8994A38EEC7
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhEXPzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232911AbhEXPxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:53:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0B4F613F9;
        Mon, 24 May 2021 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870764;
        bh=PhFm7ALNNG4FJCbcGTUtO3K/7tninEJiovqLt4vCB+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TA6nCo0/1X8sy90Q7Hwf/2/E0MHuh8hlAeBnncjkdOazvbWeshDt9R2HGRoBNe6mH
         6AV813Qyb/9Pzc6tPlTdh6WjR6/Xr6T/3dICqHa/Wt5MOG5N47ZrPelO/tc/gWLyWo
         L1QmO2TPB3ngXqMN2/2gkr6dCMkJZRfnJKWuHWtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/104] scsi: qedf: Add pointer checks in qedf_update_link_speed()
Date:   Mon, 24 May 2021 17:25:04 +0200
Message-Id: <20210524152333.146154252@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 73578af92a0fae6609b955fcc9113e50e413c80f ]

The following trace was observed:

 [   14.042059] Call Trace:
 [   14.042061]  <IRQ>
 [   14.042068]  qedf_link_update+0x144/0x1f0 [qedf]
 [   14.042117]  qed_link_update+0x5c/0x80 [qed]
 [   14.042135]  qed_mcp_handle_link_change+0x2d2/0x410 [qed]
 [   14.042155]  ? qed_set_ptt+0x70/0x80 [qed]
 [   14.042170]  ? qed_set_ptt+0x70/0x80 [qed]
 [   14.042186]  ? qed_rd+0x13/0x40 [qed]
 [   14.042205]  qed_mcp_handle_events+0x437/0x690 [qed]
 [   14.042221]  ? qed_set_ptt+0x70/0x80 [qed]
 [   14.042239]  qed_int_sp_dpc+0x3a6/0x3e0 [qed]
 [   14.042245]  tasklet_action_common.isra.14+0x5a/0x100
 [   14.042250]  __do_softirq+0xe4/0x2f8
 [   14.042253]  irq_exit+0xf7/0x100
 [   14.042255]  do_IRQ+0x7f/0xd0
 [   14.042257]  common_interrupt+0xf/0xf
 [   14.042259]  </IRQ>

API qedf_link_update() is getting called from QED but by that time
shost_data is not initialised. This results in a NULL pointer dereference
when we try to dereference shost_data while updating supported_speeds.

Add a NULL pointer check before dereferencing shost_data.

Link: https://lore.kernel.org/r/20210512072533.23618-1-jhasan@marvell.com
Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 46d185cb9ea8..a464d0a4f465 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -536,7 +536,9 @@ static void qedf_update_link_speed(struct qedf_ctx *qedf,
 	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_20GBIT;
 
-	fc_host_supported_speeds(lport->host) = lport->link_supported_speeds;
+	if (lport->host && lport->host->shost_data)
+		fc_host_supported_speeds(lport->host) =
+			lport->link_supported_speeds;
 }
 
 static void qedf_bw_update(void *dev)
-- 
2.30.2



