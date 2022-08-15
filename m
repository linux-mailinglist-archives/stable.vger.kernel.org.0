Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B892A594DEB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344195AbiHPAsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349245AbiHPAqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:46:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5F9178C19;
        Mon, 15 Aug 2022 13:45:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E15DF61262;
        Mon, 15 Aug 2022 20:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3C9C433B5;
        Mon, 15 Aug 2022 20:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596318;
        bh=BWkT5Y8yauvayeEYP3032GkgL1q2sJJNLjErP6LavCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9Kq1T61Z/1O2gfSpnvxZJQt+urzSogw3N4hy67W7c58k3tl+c7A9Adi+H4P2SQyf
         tezi1z5EYSicagV4d+25W5DSHM04Ko4XDSGmKb/ZnYOPLQTDZ1Wl+zNMUwQyi8v4V9
         ijkWsWO5JTdLtUvFsCe50SC7Y4Pda+jyxFmG7JfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Bannoth <nbannoth@in.ibm.com>,
        Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.19 1040/1157] scsi: qla2xxx: Fix erroneous mailbox timeout after PCI error injection
Date:   Mon, 15 Aug 2022 20:06:36 +0200
Message-Id: <20220815180521.594043203@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

commit f260694e6463b63ae550aad25ddefe94cb1904da upstream.

Clear wait for mailbox interrupt flag to prevent stale mailbox:

Feb 22 05:22:56 ltcden4-lp7 kernel: qla2xxx [0135:90:00.1]-500a:4: LOOP UP detected (16 Gbps).
Feb 22 05:22:59 ltcden4-lp7 kernel: qla2xxx [0135:90:00.1]-d04c:4: MBX Command timeout for cmd 69, ...

To fix the issue, driver needs to clear the MBX_INTR_WAIT flag on purging
the mailbox. When the stale mailbox completion does arrive, it will be
dropped.

Link: https://lore.kernel.org/r/20220616053508.27186-11-njavali@marvell.com
Fixes: b6faaaf796d7 ("scsi: qla2xxx: Serialize mailbox request")
Cc: Naresh Bannoth <nbannoth@in.ibm.com>
Cc: Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Cc: stable@vger.kernel.org
Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
Tested-by: Naresh Bannoth <nbannoth@in.ibm.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -276,6 +276,12 @@ qla2x00_mailbox_command(scsi_qla_host_t
 		atomic_inc(&ha->num_pend_mbx_stage3);
 		if (!wait_for_completion_timeout(&ha->mbx_intr_comp,
 		    mcp->tov * HZ)) {
+			ql_dbg(ql_dbg_mbx, vha, 0x117a,
+			    "cmd=%x Timeout.\n", command);
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 			if (chip_reset != ha->chip_reset) {
 				eeh_delay = ha->flags.eeh_busy ? 1 : 0;
 
@@ -288,12 +294,6 @@ qla2x00_mailbox_command(scsi_qla_host_t
 				rval = QLA_ABORTED;
 				goto premature_exit;
 			}
-			ql_dbg(ql_dbg_mbx, vha, 0x117a,
-			    "cmd=%x Timeout.\n", command);
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 		} else if (ha->flags.purge_mbox ||
 		    chip_reset != ha->chip_reset) {
 			eeh_delay = ha->flags.eeh_busy ? 1 : 0;


