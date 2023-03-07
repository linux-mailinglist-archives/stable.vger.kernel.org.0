Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B006AEA1D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjCGRay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjCGRag (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5C69C99E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:25:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49D69614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F41AC433EF;
        Tue,  7 Mar 2023 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209954;
        bh=tfqhrKl/67BgqJ5hefqE8ljkPntiYXdBO9A2lEcM0cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ee8aUxRC+3vnznWW0vAzbjN11knnqFrA45EnLxDe/VbH2CCubl0UwgjHCvAsW1S8Q
         em1d5+/FI+GxJHxr5uJUa6+hncwuQuRJywRj+PCZsfC/zyD8EgUOd9WR1WKumRuBdU
         UOeeV6Bdvaq0JmFs8NurxjM5bsuWLIrY7x8rOt+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0358/1001] scsi: qla2xxx: edif: Fix clang warning
Date:   Tue,  7 Mar 2023 17:52:10 +0100
Message-Id: <20230307170036.969560258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 2f5fab1b6c3a8efc93ba52c28539c45a8d0142ad ]

clang warning:

  drivers/scsi/qla2xxx/qla_edif_bsg.h:93:12: warning: field remote_pid
  within 'struct app_pinfo_req' is less aligned than 'port_id_t' and is
  usually due to 'struct app_pinfo_req' being packed, which can lead to
  unaligned accesses [-Wunaligned-access]
  port_id_t remote_pid;
	        ^
  2 warnings generated.

Remove u32 field in remote_pid to silence warning.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c     |  4 +++-
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 53186a1459629..38d5bda1f2748 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -925,7 +925,9 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			if (!(fcport->flags & FCF_FCSP_DEVICE))
 				continue;
 
-			tdid = app_req.remote_pid;
+			tdid.b.domain = app_req.remote_pid.domain;
+			tdid.b.area = app_req.remote_pid.area;
+			tdid.b.al_pa = app_req.remote_pid.al_pa;
 
 			ql_dbg(ql_dbg_edif, vha, 0x2058,
 			    "APP request entry - portid=%06x.\n", tdid.b24);
diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 0931f4e4e127a..514c265ba86e2 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -89,7 +89,20 @@ struct app_plogi_reply {
 struct app_pinfo_req {
 	struct app_id app_info;
 	uint8_t	 num_ports;
-	port_id_t remote_pid;
+	struct {
+#ifdef __BIG_ENDIAN
+		uint8_t domain;
+		uint8_t area;
+		uint8_t al_pa;
+#elif defined(__LITTLE_ENDIAN)
+		uint8_t al_pa;
+		uint8_t area;
+		uint8_t domain;
+#else
+#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
+#endif
+		uint8_t rsvd_1;
+	} remote_pid;
 	uint8_t		version;
 	uint8_t		pad[VND_CMD_PAD_SIZE];
 	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
-- 
2.39.2



