Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8388113E85C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404720AbgAPRbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404713AbgAPRbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:31:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99A7F246B2;
        Thu, 16 Jan 2020 17:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195869;
        bh=0++cJLb9/80RaLZW+1yZLHRT93Jn23hqDa/931c+WFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iT2//tQ7bGyIJpasxBtxUunv+Tdc6nPltHfT+E/nDq378emhO/gxclgnjc9gOdNML
         9Xji8CBS6x9kls2Vw5acHw23B2nYuNsf+R/uxftQIytV46lK7bpu8snRajscDfAqg/
         hhrvcd0T9YwqBeUBj+/rVKuZukxUZSSHoANBif1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, David Bond <dbond@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 365/371] scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan
Date:   Thu, 16 Jan 2020 12:23:57 -0500
Message-Id: <20200116172403.18149-308-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
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
index bd2421863510..a66f7cec797c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5145,8 +5145,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 			break;
 
-		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
-		    (fcport->flags & FCF_LOGIN_NEEDED) == 0)
+		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 			continue;
 
 		if (fcport->scan_state == QLA_FCPORT_SCAN) {
@@ -5171,7 +5170,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
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

