Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CFD591AA2
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbiHMNac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239462AbiHMNaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F011D5
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2188960CA4
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEC9C433C1;
        Sat, 13 Aug 2022 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660397426;
        bh=yBKqfsnumjbJS4WvXd1rfXZk2t0ql4rUW+V30zPjq9U=;
        h=Subject:To:Cc:From:Date:From;
        b=m25SBJT/APHt0o34KiwQdnJ5mBvYBqcLTsTLS6NVMN1XJuOfVNXgEiQqGeuUg9rLu
         Sa6BVwNilEx7Xq2rnDcZwYWSVcK5s8JsLGGgJnD6X0GdPd5DYYVyCeYItwzWsiwyWd
         mp23aaLP3QpUBG+SFk+y8tc+7qPRM6OYcu2WUQ9c=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Zero undefined mailbox IN registers" failed to apply to 4.19-stable tree
To:     bhazarika@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com, qutran@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 15:30:11 +0200
Message-ID: <166039741120046@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c96a3c7d49593ef15805f5e497601c87695abc9 Mon Sep 17 00:00:00 2001
From: Bikash Hazarika <bhazarika@marvell.com>
Date: Tue, 12 Jul 2022 22:20:38 -0700
Subject: [PATCH] scsi: qla2xxx: Zero undefined mailbox IN registers

While requesting a new mailbox command, driver does not write any data to
unused registers.  Initialize the unused register value to zero while
requesting a new mailbox command to prevent stale entry access by firmware.

Link: https://lore.kernel.org/r/20220713052045.10683-4-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 643fa0052f5a..9a3f832c49ef 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -238,6 +238,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			ql_dbg(ql_dbg_mbx, vha, 0x1112,
 			    "mbox[%d]<-0x%04x\n", cnt, *iptr);
 			wrt_reg_word(optr, *iptr);
+		} else {
+			wrt_reg_word(optr, 0);
 		}
 
 		mboxes >>= 1;

