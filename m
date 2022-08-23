Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C795C59DCB1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbiHWLkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357745AbiHWLiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:38:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F06F101CF;
        Tue, 23 Aug 2022 02:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4ACDB81C89;
        Tue, 23 Aug 2022 09:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C309C433C1;
        Tue, 23 Aug 2022 09:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246886;
        bh=V4LgSedpr3Mn3JFQSAmnZTgGzA5U6Wo8O3HklmKyLu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J528pb1rmNSGQoSULv4WjCvR3z6mFamfFW9CISF1HfAQ8D7YbP5gadmCnbuLDmnzs
         32WV0bhgkZnBwdga68GWET9jNMingunocPwlClH4YkHZwTHTPIGjgtprIMRHtA0R06
         /0guiJzaynqreIxGprK01PiczaBN+pEpowjleiWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Bannoth <nbannoth@in.ibm.com>,
        Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 251/389] scsi: qla2xxx: Fix erroneous mailbox timeout after PCI error injection
Date:   Tue, 23 Aug 2022 10:25:29 +0200
Message-Id: <20220823080126.074957854@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -271,6 +271,12 @@ qla2x00_mailbox_command(scsi_qla_host_t
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
 				spin_lock_irqsave(&ha->hardware_lock, flags);
 				ha->flags.mbox_busy = 0;
@@ -281,12 +287,6 @@ qla2x00_mailbox_command(scsi_qla_host_t
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
 			spin_lock_irqsave(&ha->hardware_lock, flags);


