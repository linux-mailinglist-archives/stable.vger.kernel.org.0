Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD0250598
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgHXRRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728303AbgHXQgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:36:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 063CD22D2A;
        Mon, 24 Aug 2020 16:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286963;
        bh=a4AFxIIbHQK9Lqw9oBlSp8gM0Wf/4JFV3vGKeiNeUr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUyQBfL678mmao72Pfn8cK3th7lY9+iOnWs4W5Rc26yByRKEw4ynQTEKeA4Mwu2PV
         NYC7GVFoYA0wrJd01rZmLu2sJKpDcbnM8hRuQK6XrfcNvHTYZG7XcRN8ozv+FZzW8i
         9WnhQSt0E2xSVf4Rdq6zy1gVVWb9H6NNHayeqoFw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 43/63] scsi: qla2xxx: Flush all sessions on zone disable
Date:   Mon, 24 Aug 2020 12:34:43 -0400
Message-Id: <20200824163504.605538-43-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 10ae30ba664822f62de169a61628e31c999c7cc8 ]

On Zone Disable, certain switches would ignore all commands. This causes
timeout for both switch scan command and abort of that command. On
detection of this condition, all sessions will be shutdown.

Link: https://lore.kernel.org/r/20200806111014.28434-2-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index df670fba2ab8a..c6b6a3250312e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3736,6 +3736,18 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
 		unsigned long flags;
 		const char *name = sp->name;
 
+		if (res == QLA_OS_TIMER_EXPIRED) {
+			/* switch is ignoring all commands.
+			 * This might be a zone disable behavior.
+			 * This means we hit 64s timeout.
+			 * 22s GPNFT + 44s Abort = 64s
+			 */
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			       "%s: Switch Zone check please .\n",
+			       name);
+			qla2x00_mark_all_devices_lost(vha);
+		}
+
 		/*
 		 * We are in an Interrupt context, queue up this
 		 * sp for GNNFT_DONE work. This will allow all
-- 
2.25.1

