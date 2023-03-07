Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D896AF29B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbjCGSyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbjCGSyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:54:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97373C223A;
        Tue,  7 Mar 2023 10:41:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E728661522;
        Tue,  7 Mar 2023 18:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D588CC433EF;
        Tue,  7 Mar 2023 18:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214498;
        bh=SSTfoSVqUu/8IxWgP9kZoKE212j3zuX6BvOE1s6sczc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzwtyBxGPgNr/gJ25y0rNzY/XpBESBjACk3nFx4j8wswW9rVnFvEGeIyC8/wXW1PE
         N+nCiuAo/BQxZ6PKNN6cY2BP57BFve7nQEq4LdaYGVApQi5biisVpt/NeXxXPwXdp5
         C4H3lj6GjcIf1ex+mzwIUf8qc4kViVAfB10hg5KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 6.1 843/885] scsi: aacraid: Allocate cmd_priv with scsicmd
Date:   Tue,  7 Mar 2023 18:02:57 +0100
Message-Id: <20230307170038.454065418@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit 7ab734fc759828707dae22fe48b1eb4dcf70beea upstream.

The aac_priv() helper assumes that the private cmd area immediately follows
struct scsi_cmnd. Allocate this space as part of scsicmd, else there is a
risk of heap overflow. Seen with GCC 13:

../drivers/scsi/aacraid/aachba.c: In function 'aac_probe_container':
../drivers/scsi/aacraid/aachba.c:841:26: warning: array subscript 16 is outside array bounds of 'void[392]' [-Warray-bounds=]
  841 |         status = cmd_priv->status;
      |                          ^~
In file included from ../include/linux/resource_ext.h:11,
                 from ../include/linux/pci.h:40,
                 from ../drivers/scsi/aacraid/aachba.c:22:
In function 'kmalloc',
    inlined from 'kzalloc' at ../include/linux/slab.h:720:9,
    inlined from 'aac_probe_container' at ../drivers/scsi/aacraid/aachba.c:821:30:
../include/linux/slab.h:580:24: note: at offset 392 into object of size 392 allocated by 'kmalloc_trace'
  580 |                 return kmalloc_trace(
      |                        ^~~~~~~~~~~~~~
  581 |                                 kmalloc_caches[kmalloc_type(flags)][index],
      |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  582 |                                 flags, size);
      |                                 ~~~~~~~~~~~~

Fixes: 76a3451b64c6 ("scsi: aacraid: Move the SCSI pointer to private command data")
Link: https://lore.kernel.org/r/20230128000409.never.976-kees@kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/aacraid/aachba.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 4d4cb47b3846..24c049eff157 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -818,8 +818,8 @@ static void aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
 
 int aac_probe_container(struct aac_dev *dev, int cid)
 {
-	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd), GFP_KERNEL);
-	struct aac_cmd_priv *cmd_priv = aac_priv(scsicmd);
+	struct aac_cmd_priv *cmd_priv;
+	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd) + sizeof(*cmd_priv), GFP_KERNEL);
 	struct scsi_device *scsidev = kzalloc(sizeof(*scsidev), GFP_KERNEL);
 	int status;
 
@@ -838,6 +838,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
 		while (scsicmd->device == scsidev)
 			schedule();
 	kfree(scsidev);
+	cmd_priv = aac_priv(scsicmd);
 	status = cmd_priv->status;
 	kfree(scsicmd);
 	return status;
-- 
2.39.2



