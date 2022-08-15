Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE11593C8F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344394AbiHOTnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345119AbiHOTm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:42:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C64B6A496;
        Mon, 15 Aug 2022 11:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E68561215;
        Mon, 15 Aug 2022 18:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E50EC433C1;
        Mon, 15 Aug 2022 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589285;
        bh=S/JQouxy1F63QMdn0oomDfQuYY1coqzJfhi6JPkD6tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP9E4fS0BboJIQFFdIc5S/MdMRKO+6VPZskKZLyCeqXJoolV4iuYOtA6IFlUvgEpa
         PQ4sIIWj1sqGrkUGcqZpKUcKE+w/DxAJVs7gFDGMR3HrYMPlycvaa2N0lFuOvulXXb
         WiiBzLEj0QVvsowGm6vjQewqmNL3APCuy7prgTAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 671/779] scsi: qla2xxx: Fix imbalance vha->vref_count
Date:   Mon, 15 Aug 2022 20:05:15 +0200
Message-Id: <20220815180406.029915271@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

commit 63fa7f2644b4b48e1913af33092c044bf48e9321 upstream.

vref_count took an extra decrement in the task management path.  Add an
extra ref count to compensate the imbalance.

Link: https://lore.kernel.org/r/20220713052045.10683-7-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -161,6 +161,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_s
 	struct srb_iocb *abt_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
+	uint8_t bail;
 
 	/* ref: INIT for ABTS command */
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
@@ -168,6 +169,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_s
 	if (!sp)
 		return QLA_MEMORY_ALLOC_FAILED;
 
+	QLA_VHA_MARK_BUSY(vha, bail);
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
@@ -2009,12 +2011,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport,
 	struct srb_iocb *tm_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
+	uint8_t bail;
 
 	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	QLA_VHA_MARK_BUSY(vha, bail);
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
 	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),


