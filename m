Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D939594187
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiHOV15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346382AbiHOVY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:24:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AA6E725E;
        Mon, 15 Aug 2022 12:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6463561024;
        Mon, 15 Aug 2022 19:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCFAC433D7;
        Mon, 15 Aug 2022 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591349;
        bh=YTl8WtGTSEAv6fEihigIAxYf6dV25myHpJqpS3uakVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bju5ECkm5mDxyPZ2e+m5KAU0dvVE2YJWe2+7RT3vnvJtjBQbsA2O2E8bA9AXILwva
         T+z2GKesYekXRuU6+BSknG0bCdMD+lmPk1x7m3RCfLYfKHJxtWFggrc0YzkMY3cv1g
         hnnkgJrqJ5VJlujzFuMsixx8OSWS7ltWXKalzQ+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0552/1095] scsi: qla2xxx: edif: Synchronize NPIV deletion with authentication application
Date:   Mon, 15 Aug 2022 19:59:11 +0200
Message-Id: <20220815180452.395892404@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit cf79716e6636400ae38c37bc8a652b1e522abbba ]

Notify authentication application of a NPIV deletion event is about to
occur. This allows app to perform cleanup.

Link: https://lore.kernel.org/r/20220607044627.19563-7-njavali@marvell.com
Fixes: 9efea843a906 ("scsi: qla2xxx: edif: Add detection of secure device")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 2 ++
 drivers/scsi/qla2xxx/qla_mid.c      | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 110843b13767..0931f4e4e127 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -253,4 +253,6 @@ struct aen_complete_cmd {
 
 #define RX_DELAY_DELETE_TIMEOUT 20
 
+#define FCH_EVT_VENDOR_UNIQUE_VPORT_DOWN  1
+
 #endif	/* QLA_EDIF_BSG_H */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e6b5c4ccce97..eb43a5f1b399 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -166,9 +166,13 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	int ret = QLA_SUCCESS;
 	fc_port_t *fcport;
 
-	if (vha->hw->flags.edif_enabled)
+	if (vha->hw->flags.edif_enabled) {
+		if (DBELL_ACTIVE(vha))
+			qla2x00_post_aen_work(vha, FCH_EVT_VENDOR_UNIQUE,
+			    FCH_EVT_VENDOR_UNIQUE_VPORT_DOWN);
 		/* delete sessions and flush sa_indexes */
 		qla2x00_wait_for_sess_deletion(vha);
+	}
 
 	if (vha->hw->flags.fw_started)
 		ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
-- 
2.35.1



