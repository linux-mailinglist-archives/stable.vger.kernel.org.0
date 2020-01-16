Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BFE13F8AA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbgAPTUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbgAPQyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D936A21582;
        Thu, 16 Jan 2020 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193646;
        bh=/N7dXcgnUL4QvYlzGgdYmk0bhnECzleSvnWAkrNYoY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9rcyNVLIax+ZqYdb+/OIGPT8CtwoFp3NGpNHqSCFUaRa0Vf52CriV/oZSTs1Ik8W
         MWQOcdrt1Eegg+n+C4dOj6srYh3JZdWJpNeB145URxh5wXUz2Rl3/qIXmY1we8byFW
         PNZYnqvoGNVpeRdW23MN2/qKh/C0pm7DSt0nXyn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, David Bond <dbond@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 177/205] scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan
Date:   Thu, 16 Jan 2020 11:42:32 -0500
Message-Id: <20200116164300.6705-177-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit d341e9a8f2cffe4000c610225c629f62c7489c74 ]

In qla2x00_find_all_fabric_devs(), fcport->flags & FCF_LOGIN_NEEDED is a
necessary condition for logging into new rports, but not for dropping lost
ones.

Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Link: https://lore.kernel.org/r/20191122221912.20100-2-martin.wilck@suse.com
Tested-by: David Bond <dbond@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 80f276d67c14..9ffaa920fc8f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5891,8 +5891,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 			break;
 
-		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
-		    (fcport->flags & FCF_LOGIN_NEEDED) == 0)
+		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 			continue;
 
 		if (fcport->scan_state == QLA_FCPORT_SCAN) {
@@ -5915,7 +5914,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			}
 		}
 
-		if (fcport->scan_state == QLA_FCPORT_FOUND)
+		if (fcport->scan_state == QLA_FCPORT_FOUND &&
+		    (fcport->flags & FCF_LOGIN_NEEDED) != 0)
 			qla24xx_fcport_handle_login(vha, fcport);
 	}
 	return (rval);
-- 
2.20.1

