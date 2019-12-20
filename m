Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66995127D65
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfLTOdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbfLTOah (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D52924689;
        Fri, 20 Dec 2019 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852236;
        bh=wkJAdtkBXdnXu9aJYtGZe9L7P79h8OzAjQykNDwnR8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvV72O5uH60SYxsRPw0oX0FHw1sniAi1uX4lOH9N3rNvQSYbnQpaHmBvPFwnCdH/X
         kBdY/i46RwyeMVUuQ8jodc2nqcdg8Xg0qEziE5nfe2KwOlmbAPCapblCzMxCUfw9eR
         +xgXwMwkHdAN3vQKG+7qNc1kB9imgGfa9Tk0lRFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/52] scsi: qla2xxx: Don't defer relogin unconditonally
Date:   Fri, 20 Dec 2019 09:29:32 -0500
Message-Id: <20191220142954.9500-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit dabc5ec915f3a2c657ecfb529cd3d4ec303a4412 ]

qla2x00_configure_local_loop sets RELOGIN_NEEDED bit and calls
qla24xx_fcport_handle_login to perform the login. This bit triggers a wake
up of DPC later after a successful login.

The deferred call is not needed if login succeeds, and it's set in
qla24xx_fcport_handle_login in case of errors, hence it should be safe to
drop.

Link: https://lore.kernel.org/r/20191125165702.1013-12-r.bolshakov@yadro.com
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Acked-by: Quinn Tran <qutran@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7364f3b62b9d9..1c3a5fcbd3153 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5043,7 +5043,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 				memcpy(&ha->plogi_els_payld.data,
 				    (void *)ha->init_cb,
 				    sizeof(ha->plogi_els_payld.data));
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			} else {
 				ql_dbg(ql_dbg_init, vha, 0x00d1,
 				    "PLOGI ELS param read fail.\n");
-- 
2.20.1

