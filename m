Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E259E1C9053
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgEGOia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgEGO1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C896215A4;
        Thu,  7 May 2020 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861659;
        bh=WhwM3iTNbsmNSS6/bb0949tPxR2HU1JwzHMfmAt9BzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueq8VAsv+roqAxguB/gPFVMYUzmWmm2DDhM2gbqqmuUKqXcksm7tSOjMqL2a+D3yk
         UMfAGJgNOP3D4PE7a5/5KzI0NOaPMofkr7qvQcEWoiMgYi7fUkApM6fQkb6Qo8WBlu
         +zcIpkeTIL5pCcaxv5WFBukFzHJ0WC0MSM/KnT6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 10/50] scsi: qla2xxx: check UNLOADING before posting async work
Date:   Thu,  7 May 2020 10:26:46 -0400
Message-Id: <20200507142726.25751-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 5a263892d7d0b4fe351363f8d1a14c6a75955475 ]

qlt_free_session_done() tries to post async PRLO / LOGO, and waits for the
completion of these async commands. If UNLOADING is set, this is doomed to
timeout, because the async logout command will never complete.

The only way to avoid waiting pointlessly is to fail posting these commands
in the first place if the driver is in UNLOADING state.  In general,
posting any command should be avoided when the driver is UNLOADING.

With this patch, "rmmod qla2xxx" completes without noticeable delay.

Link: https://lore.kernel.org/r/20200421204621.19228-3-mwilck@suse.com
Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Acked-by: Arun Easi <aeasi@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4a89202115521..98908c2a096a7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4854,6 +4854,9 @@ qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 	struct qla_work_evt *e;
 	uint8_t bail;
 
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		return NULL;
+
 	QLA_VHA_MARK_BUSY(vha, bail);
 	if (bail)
 		return NULL;
-- 
2.20.1

