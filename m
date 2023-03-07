Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6EB6AF5A3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbjCGT2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbjCGT1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:27:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7464B4F56
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05E3F6153D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13D3C433EF;
        Tue,  7 Mar 2023 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216400;
        bh=tXeg5/dxj+YI6JBqpG3Z6J2/hg9i6L80Dzb3gRlYmgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzJJvW7YitrPV3XktwLm93vcKsUAa1c/71UKujiZ6SHCe2+NMDqoXazL/cS0b/kZZ
         k7aCM+pgA+HUmJb5HdxwzVjXMZoHXHzyd6r6uVSCZAOBjjCst2Dj3veVWTYpaHig7J
         2ulSQAFU9qEFy7Ls4xOYVvUvLksIg2s6HRgYEHoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shreyas Deodhar <sdeodhar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 540/567] scsi: qla2xxx: Check if port is online before sending ELS
Date:   Tue,  7 Mar 2023 18:04:36 +0100
Message-Id: <20230307165929.352381992@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit 0c227dc22ca18856055983f27594feb2e0149965 upstream.

CT Ping and ELS cmds fail for NVMe targets.  Check if port is online before
sending ELS instead of sending login.

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -278,8 +278,8 @@ qla2x00_process_els(struct bsg_job *bsg_
 	const char *type;
 	int req_sg_cnt, rsp_sg_cnt;
 	int rval =  (DID_ERROR << 16);
-	uint16_t nextlid = 0;
 	uint32_t els_cmd = 0;
+	int qla_port_allocated = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
@@ -329,9 +329,9 @@ qla2x00_process_els(struct bsg_job *bsg_
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
-		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
+		if (atomic_read(&fcport->state) != FCS_ONLINE) {
 			ql_dbg(ql_dbg_user, vha, 0x7003,
-			    "Failed to login port %06X for ELS passthru.\n",
+			    "Port %06X is not online for ELS passthru.\n",
 			    fcport->d_id.b24);
 			rval = -EIO;
 			goto done;
@@ -348,6 +348,7 @@ qla2x00_process_els(struct bsg_job *bsg_
 			goto done;
 		}
 
+		qla_port_allocated = 1;
 		/* Initialize all required  fields of fcport */
 		fcport->vha = vha;
 		fcport->d_id.b.al_pa =
@@ -432,7 +433,7 @@ done_unmap_sg:
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_request->msgcode != FC_BSG_RPT_ELS)
+	if (qla_port_allocated)
 		qla2x00_free_fcport(fcport);
 done:
 	return rval;


