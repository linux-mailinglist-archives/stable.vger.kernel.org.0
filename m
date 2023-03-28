Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BCB6CC4EB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjC1PKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjC1PJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4677E3B5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 853C56183C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9672DC4339C;
        Tue, 28 Mar 2023 15:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016123;
        bh=Ev3FwFwxS8EuNBubLLKM8cRw7SEv3IRxfl9/BmBrtcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwUcUHDFAj/G+kNIYJoNEJ8Mib/5a8KJkPCptUeCObqTCdKrPsbsp6MsJJdxXKFw4
         Nrg5d2/+rxQlEF7LqTGEadgiWZPl1BJl7Tcjw5AUq7/pOHaEuP1fRCCV/2lvubHQEI
         wKtwUeGoYDk7xX/+trzT3G7DZQ5UgMTypC7ie2oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lin Li <lilin@redhat.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        John Meneghini <jmeneghi@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 074/146] scsi: qla2xxx: Perform lockless command completion in abort path
Date:   Tue, 28 Mar 2023 16:42:43 +0200
Message-Id: <20230328142605.810581193@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

commit 0367076b0817d5c75dfb83001ce7ce5c64d803a9 upstream.

While adding and removing the controller, the following call trace was
observed:

WARNING: CPU: 3 PID: 623596 at kernel/dma/mapping.c:532 dma_free_attrs+0x33/0x50
CPU: 3 PID: 623596 Comm: sh Kdump: loaded Not tainted 5.14.0-96.el9.x86_64 #1
RIP: 0010:dma_free_attrs+0x33/0x50

Call Trace:
   qla2x00_async_sns_sp_done+0x107/0x1b0 [qla2xxx]
   qla2x00_abort_srb+0x8e/0x250 [qla2xxx]
   ? ql_dbg+0x70/0x100 [qla2xxx]
   __qla2x00_abort_all_cmds+0x108/0x190 [qla2xxx]
   qla2x00_abort_all_cmds+0x24/0x70 [qla2xxx]
   qla2x00_abort_isp_cleanup+0x305/0x3e0 [qla2xxx]
   qla2x00_remove_one+0x364/0x400 [qla2xxx]
   pci_device_remove+0x36/0xa0
   __device_release_driver+0x17a/0x230
   device_release_driver+0x24/0x30
   pci_stop_bus_device+0x68/0x90
   pci_stop_and_remove_bus_device_locked+0x16/0x30
   remove_store+0x75/0x90
   kernfs_fop_write_iter+0x11c/0x1b0
   new_sync_write+0x11f/0x1b0
   vfs_write+0x1eb/0x280
   ksys_write+0x5f/0xe0
   do_syscall_64+0x5c/0x80
   ? do_user_addr_fault+0x1d8/0x680
   ? do_syscall_64+0x69/0x80
   ? exc_page_fault+0x62/0x140
   ? asm_exc_page_fault+0x8/0x30
   entry_SYSCALL_64_after_hwframe+0x44/0xae

The command was completed in the abort path during driver unload with a
lock held, causing the warning in abort path. Hence complete the command
without any lock held.

Reported-by: Lin Li <lilin@redhat.com>
Tested-by: Lin Li <lilin@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230313043711.13500-2-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1845,6 +1845,17 @@ __qla2x00_abort_all_cmds(struct qla_qpai
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
 		if (sp) {
+			/*
+			 * perform lockless completion during driver unload
+			 */
+			if (qla2x00_chip_is_down(vha)) {
+				req->outstanding_cmds[cnt] = NULL;
+				spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+				sp->done(sp, res);
+				spin_lock_irqsave(qp->qp_lock_ptr, flags);
+				continue;
+			}
+
 			switch (sp->cmd_type) {
 			case TYPE_SRB:
 				qla2x00_abort_srb(qp, sp, res, &flags);


