Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E476AEEF2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjCGSSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbjCGSSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:18:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2F41F4B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A731B819BA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E7FC433D2;
        Tue,  7 Mar 2023 18:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212763;
        bh=U3MWIQ/4Gtl9L0r8CtRfGwsUelv5bGu9qoRiPdvBXBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWMa9oix9q4nErosBf9RDG3SCXlDJrLWDCuVo4FeqJMexOGQFRte57eVYR5idyT6S
         PtT3V+29beO1GGJzNzuDt7vVhn6lyA4JH+0ICrrQWQ4GYSuDtMHJwQ+hn79v3xx2sx
         M0VUGe+l+3mqz9lcE95wvYZbWQFy5BwcM49WBf9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 290/885] scsi: qla2xxx: edif: Fix clang warning
Date:   Tue,  7 Mar 2023 17:53:44 +0100
Message-Id: <20230307170014.659866068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index d17ba6275b685..1cafd27d5a609 100644
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



