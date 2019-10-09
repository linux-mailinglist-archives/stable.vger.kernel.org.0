Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA3B5D16C6
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbfJIRc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732001AbfJIRX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:57 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A9AA21D6C;
        Wed,  9 Oct 2019 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641836;
        bh=dlmTroG9Z6e2QxL9z2QYYH/+HCwazBgRl60ITiwDM9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYc9p4jqDhGiX+blbeRzNv/ODThzkGnS4EwqhSUjraWbnhkaAKo1bF/JFkboCFXcS
         AkqhRPSBCGXeqAB+6nPzqc0cV2u/iJyqLalSydaAU0DM6zUphgBiGv4wvzJuyPGaHB
         BWR6Q9n2fexvSMdhEBRleUviGAneQGBUSN/VregA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 10/68] scsi: qla2xxx: Fix unbound sleep in fcport delete path.
Date:   Wed,  9 Oct 2019 13:04:49 -0400
Message-Id: <20191009170547.32204-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit c3b6a1d397420a0fdd97af2f06abfb78adc370df ]

There are instances, though rare, where a LOGO request cannot be sent out
and the thread in free session done can wait indefinitely. Fix this by
putting an upper bound to sleep.

Link: https://lore.kernel.org/r/20190912180918.6436-3-hmadhani@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 459c28aa3b94a..f77baf107024f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1021,6 +1021,7 @@ void qlt_free_session_done(struct work_struct *work)
 
 	if (logout_started) {
 		bool traced = false;
+		u16 cnt = 0;
 
 		while (!READ_ONCE(sess->logout_completed)) {
 			if (!traced) {
@@ -1030,6 +1031,9 @@ void qlt_free_session_done(struct work_struct *work)
 				traced = true;
 			}
 			msleep(100);
+			cnt++;
+			if (cnt > 200)
+				break;
 		}
 
 		ql_dbg(ql_dbg_disc, vha, 0xf087,
-- 
2.20.1

