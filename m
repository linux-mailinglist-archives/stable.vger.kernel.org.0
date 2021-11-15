Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4779C451E01
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350915AbhKPAep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344234AbhKOTYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED0E6347D;
        Mon, 15 Nov 2021 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002456;
        bh=wWTWcgii0aHV3eSVRgcoS1F0PxZ4Awv/p5Mg9tj3z50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9zgdBPOw1WflVHiFPdafLGR/xzAy1LumSr/KGC7InSe7rJFvvyuQECsRuTNu0ag2
         oVgLii1oKN1aEId295aFzNmmCdJLcm/jZCHXuXSReO86Lh6siz27+CBYx8QUNEnvnC
         LuSIeYosQPDpnZ62/rl9Gi6ixxIt/DEk8Vuz6HUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 574/917] scsi: qla2xxx: edif: Use link event to wake up app
Date:   Mon, 15 Nov 2021 18:01:09 +0100
Message-Id: <20211115165448.245930278@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 527d46e0b0147f2b32b78ba49c6a231835b24a41 ]

Authentication application may be running and in the past tried to probe
driver (app_start) but was unsuccessful. This could be due to the bsg layer
not being ready to service the request. On a successful link up, driver
will use the netlink Link Up event to notify the app to retry the app_start
call.

In another case, app does not poll for new NPIV host. This link up event
would notify app of the presence of a new SCSI host.

Link: https://lore.kernel.org/r/20210908164622.19240-6-njavali@marvell.com
Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5fc7697f0af4c..7e64e4730b259 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5335,15 +5335,14 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 			    "LOOP READY.\n");
 			ha->flags.fw_init_done = 1;
 
+			/*
+			 * use link up to wake up app to get ready for
+			 * authentication.
+			 */
 			if (ha->flags.edif_enabled &&
-			    !(vha->e_dbell.db_flags & EDB_ACTIVE) &&
-			    N2N_TOPO(vha->hw)) {
-				/*
-				 * use port online to wake up app to get ready
-				 * for authentication
-				 */
-				qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE, 0);
-			}
+			    !(vha->e_dbell.db_flags & EDB_ACTIVE))
+				qla2x00_post_aen_work(vha, FCH_EVT_LINKUP,
+						      ha->link_data_rate);
 
 			/*
 			 * Process any ATIO queue entries that came in
-- 
2.33.0



