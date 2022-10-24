Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF160AAF8
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiJXNm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbiJXNkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258CFB3B3A;
        Mon, 24 Oct 2022 05:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D2E61328;
        Mon, 24 Oct 2022 12:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA9EC433D6;
        Mon, 24 Oct 2022 12:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615044;
        bh=5dmX0BxH8ERt9C6w6xHEfRy2uRICDLXXIjsgURNzIo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pkM60fYqMVeRjX9mYrYx1ZBL3tvjKAKjHOdziqYQWdZiXYAGggm5CQCOjtbXXHqt
         ooY5q6xL63ueg7QG4IRlIggjkDyzVzkwgytkzGOM84lriPH4ixmswmDtqnJiLghqHJ
         WWs4XVqBx7w7MuOeGUp7UW9x4qF+fSogP9CTjNW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangwu Zhang <guazhang@redhat.com>,
        John Meneghini <jmeneghi@redhat.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 071/530] scsi: qedf: Populate sysfs attributes for vport
Date:   Mon, 24 Oct 2022 13:26:55 +0200
Message-Id: <20221024113048.229359103@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

commit 592642e6b11e620e4b43189f8072752429fc8dc3 upstream.

Few vport parameters were displayed by systool as 'Unknown' or 'NULL'.
Copy speed, supported_speed, frame_size and update port_type for NPIV port.

Link: https://lore.kernel.org/r/20220919134434.3513-1-njavali@marvell.com
Cc: stable@vger.kernel.org
Tested-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qedf/qedf_main.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1921,6 +1921,27 @@ static int qedf_vport_create(struct fc_v
 		fc_vport_setlink(vn_port);
 	}
 
+	/* Set symbolic node name */
+	if (base_qedf->pdev->device == QL45xxx)
+		snprintf(fc_host_symbolic_name(vn_port->host), 256,
+			 "Marvell FastLinQ 45xxx FCoE v%s", QEDF_VERSION);
+
+	if (base_qedf->pdev->device == QL41xxx)
+		snprintf(fc_host_symbolic_name(vn_port->host), 256,
+			 "Marvell FastLinQ 41xxx FCoE v%s", QEDF_VERSION);
+
+	/* Set supported speed */
+	fc_host_supported_speeds(vn_port->host) = n_port->link_supported_speeds;
+
+	/* Set speed */
+	vn_port->link_speed = n_port->link_speed;
+
+	/* Set port type */
+	fc_host_port_type(vn_port->host) = FC_PORTTYPE_NPIV;
+
+	/* Set maxframe size */
+	fc_host_maxframe_size(vn_port->host) = n_port->mfs;
+
 	QEDF_INFO(&(base_qedf->dbg_ctx), QEDF_LOG_NPIV, "vn_port=%p.\n",
 		   vn_port);
 


