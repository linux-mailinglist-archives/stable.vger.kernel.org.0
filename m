Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83670591F6D
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 12:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiHNKMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 06:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiHNKMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 06:12:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A212018E
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 03:11:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F081BB80B42
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 10:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61510C433D6;
        Sun, 14 Aug 2022 10:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660471916;
        bh=mipM4svaiFr1IAMpqPyP8hYbHlPdGhKMzJMo/cq1Yr0=;
        h=Subject:To:Cc:From:Date:From;
        b=nCahrQodmxfmH9/ECICLL3I9PiexyIMg0EzYqRDl1teuqrxpGezni31kLaGc+A2kP
         oFogH8zDianCPX4LO3QTc0i/Vp6FVFtYlFzq+PmT8Ho/KklUTJLwjeHNbiiJrgSl0L
         fRONJSscFGUtoVCgkoQEp4KzLxVg0SYaRqEMu+TY=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix sparse warning for dport_data" failed to apply to 5.15-stable tree
To:     njavali@marvell.com, himanshu.madhani@oracle.com, lkp@intel.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Aug 2022 12:11:46 +0200
Message-ID: <16604719061239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 166d74b876b7d8eb2e41b0587db93d23cef85221 Mon Sep 17 00:00:00 2001
From: Nilesh Javali <njavali@marvell.com>
Date: Tue, 12 Jul 2022 22:20:43 -0700
Subject: [PATCH] scsi: qla2xxx: Fix sparse warning for dport_data

Use le16_to_cpu to fix sparse warning reported for dport_data.

sparse warnings: (new ones prefixed by >>)
>> drivers/scsi/qla2xxx/qla_bsg.c:2485:34: sparse: sparse: incorrect
>> type in assignment (different base types) @@ expected unsigned
>> short [usertype] mbx1 @@ got restricted __le16 @@
   drivers/scsi/qla2xxx/qla_bsg.c:2485:34: sparse: expected unsigned short [usertype] mbx1
      drivers/scsi/qla2xxx/qla_bsg.c:2485:34: sparse: got restricted __le16
>> drivers/scsi/qla2xxx/qla_bsg.c:2486:34: sparse: sparse:
>> incorrect type in assignment (different base types) @@
>> expected unsigned short [usertype] mbx2 @@ got restricted __le16 @@
   drivers/scsi/qla2xxx/qla_bsg.c:2486:34: sparse: expected unsigned short [usertype] mbx2
   drivers/scsi/qla2xxx/qla_bsg.c:2486:34: sparse: got restricted __le16

Link: https://lore.kernel.org/r/20220713052045.10683-9-njavali@marvell.com
Fixes: 476da8faa336 ("scsi: qla2xxx: Add a new v2 dport diagnostic feature")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 299c5cba92f4..5db9bf69dcff 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2482,8 +2482,8 @@ qla2x00_do_dport_diagnostics_v2(struct bsg_job *bsg_job)
 			dd->mbx2 = mcp->mb[1];
 			vha->dport_status |=  DPORT_DIAG_IN_PROGRESS;
 		} else if (options == QLA_GET_DPORT_RESULT_V2) {
-			dd->mbx1 = vha->dport_data[1];
-			dd->mbx2 = vha->dport_data[2];
+			dd->mbx1 = le16_to_cpu(vha->dport_data[1]);
+			dd->mbx2 = le16_to_cpu(vha->dport_data[2]);
 		}
 	} else {
 		dd->mbx1 = mcp->mb[0];

