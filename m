Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DAD6CC2F7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjC1OuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjC1Otr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE97DBE6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C03F1617F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF73EC433D2;
        Tue, 28 Mar 2023 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014955;
        bh=nhMFUjjMJEejkzYjAXfcZ54TkUZzKKQ+USxK6zZsWm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1SHraevl2XHh880Yo8SLofMv2mQP5AVSlvUK1tljozK2QIBAU0xpFowW6csnuZiX
         /wlR5lQ0C6tmYqog3FDyEX6Ve5TI1MlT4djNRryruNBkAcGz1bZSP9cpmwP+/94ibD
         +1iy3n+v8WNxaRosBY41m146uHMW3TMBjown8L60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lin Li <lilin@redhat.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        John Meneghini <jmeneghi@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.2 114/240] scsi: qla2xxx: Perform lockless command completion in abort path
Date:   Tue, 28 Mar 2023 16:41:17 +0200
Message-Id: <20230328142624.536276203@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
@@ -1848,6 +1848,17 @@ __qla2x00_abort_all_cmds(struct qla_qpai
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


