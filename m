Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5069B5FFEFB
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 13:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiJPLh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 07:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJPLhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 07:37:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E063539B99
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 04:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8932D60AF5
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 11:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FF6C433C1;
        Sun, 16 Oct 2022 11:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665920273;
        bh=aAFZebPZD1f22A+WQzCZcZqvKPny9f0g8sDRBvNbaT4=;
        h=Subject:To:Cc:From:Date:From;
        b=cr/YCX44UpCHsWzR0T/pC4eFv04KRghnEhf9t49AOmYTXInyNNDQ6MczOX8439zOE
         gTRk/+Ei1eIbKD/pLdAn3UiTt0EjmqFoiuN4mTndXbG8OeBfSAu0miRQ5+fQndaj0U
         A9OG/td5quaX4Omds8uyg6onT3oIhI0ls62LmLkE=
Subject: FAILED: patch "[PATCH] scsi: qedf: Populate sysfs attributes for vport" failed to apply to 5.4-stable tree
To:     skashyap@marvell.com, guazhang@redhat.com, jmeneghi@redhat.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 13:38:35 +0200
Message-ID: <16659203153170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

592642e6b11e ("scsi: qedf: Populate sysfs attributes for vport")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 592642e6b11e620e4b43189f8072752429fc8dc3 Mon Sep 17 00:00:00 2001
From: Saurav Kashyap <skashyap@marvell.com>
Date: Mon, 19 Sep 2022 06:44:34 -0700
Subject: [PATCH] scsi: qedf: Populate sysfs attributes for vport

Few vport parameters were displayed by systool as 'Unknown' or 'NULL'.
Copy speed, supported_speed, frame_size and update port_type for NPIV port.

Link: https://lore.kernel.org/r/20220919134434.3513-1-njavali@marvell.com
Cc: stable@vger.kernel.org
Tested-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 3d6b137314f3..cc6d9decf62c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1921,6 +1921,27 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
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
 

