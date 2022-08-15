Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FF5593B31
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344873AbiHOTpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344510AbiHOTn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:43:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458B06B173;
        Mon, 15 Aug 2022 11:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BA95B81057;
        Mon, 15 Aug 2022 18:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87626C433D6;
        Mon, 15 Aug 2022 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589298;
        bh=xP/ztu0pUq3CTpZIxN6O309pzYdzPqxQGpCHUkUVZK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rswcGjtObRCu5AaUcdteoFBQbiONL6UhraOHURbewxxoGpuoZD669ZzsPzGUVteF9
         FOL3uVEI0NpTxLlGahZqJYLyNLDlIRwhUArHc/NLipXwhK6nUYoVtJD2/S/Li7/Owi
         P2CBlMWqEt1byWNK18dfm7jOTA19O+0+v60IyHXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 675/779] scsi: qla2xxx: Fix excessive I/O error messages by default
Date:   Mon, 15 Aug 2022 20:05:19 +0200
Message-Id: <20220815180406.199561698@linuxfoundation.org>
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

From: Arun Easi <aeasi@marvell.com>

commit bff4873c709085e09d0ffae0c25b8e65256e3205 upstream.

Disable printing I/O error messages by default.  The messages will be
printed only when logging was enabled.

Link: https://lore.kernel.org/r/20220616053508.27186-2-njavali@marvell.com
Fixes: 8e2d81c6b5be ("scsi: qla2xxx: Fix excessive messages during device logout")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2633,7 +2633,7 @@ static void qla24xx_nvme_iocb_entry(scsi
 	}
 
 	if (unlikely(logit))
-		ql_log(ql_dbg_io, fcport->vha, 0x5060,
+		ql_dbg(ql_dbg_io, fcport->vha, 0x5060,
 		   "NVME-%s ERR Handling - hdl=%x status(%x) tr_len:%x resid=%x  ox_id=%x\n",
 		   sp->name, sp->handle, comp_status,
 		   fd->transferred_length, le32_to_cpu(sts->residual_len),
@@ -3491,7 +3491,7 @@ check_scsi_status:
 
 out:
 	if (logit)
-		ql_log(ql_dbg_io, fcport->vha, 0x3022,
+		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
 		       "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
 		       comp_status, scsi_status, res, vha->host_no,
 		       cp->device->id, cp->device->lun, fcport->d_id.b.domain,


