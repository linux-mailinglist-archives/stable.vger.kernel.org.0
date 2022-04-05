Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F724F258E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiDEHuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiDEHqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:46:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99D7939E9;
        Tue,  5 Apr 2022 00:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17995B81B7F;
        Tue,  5 Apr 2022 07:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577E7C340EE;
        Tue,  5 Apr 2022 07:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144551;
        bh=hzFTItGk6MhMLG5gB5eFJka/S3aQMbJUpwbjLiXXVC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1F9Ou+ui2ZHL1dstKvyB6MCwpc0+N8V4AWsZ6g29mbR87hrie1O7Sxgy+uW55H9h8
         8prRma3YiTPFAC3fru+ZzP1OsQ75y3uAAG8KtrKm2T9cFAOKmt1tQhA3d0LCpR8FVJ
         X8ycGH9x52yD2vKhZKLCig77LS3HHhNVp6kJVC60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.17 0084/1126] scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Tue,  5 Apr 2022 09:13:51 +0200
Message-Id: <20220405070410.035257186@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 8454563e4c2aafbfb81a383ab423ea8b9b430a25 upstream.

To detect for the DMA_NONE (no data transfer) DMA direction,
sas_ata_qc_issue() tests if the command protocol is ATA_PROT_NODATA.  This
test does not include the ATA_CMD_NCQ_NON_DATA command as this command
protocol is defined as ATA_PROT_NCQ_NODATA (equal to ATA_PROT_FLAG_NCQ) and
not as ATA_PROT_NODATA.

To include both NCQ and non-NCQ commands when testing for the DMA_NONE DMA
direction, use "!ata_is_data()".

Link: https://lore.kernel.org/r/20220220031810.738362-2-damien.lemoal@opensource.wdc.com
Fixes: 176ddd89171d ("scsi: libsas: Reset num_scatter if libata marks qc as NODATA")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libsas/sas_ata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -197,7 +197,7 @@ static unsigned int sas_ata_qc_issue(str
 		task->total_xfer_len = qc->nbytes;
 		task->num_scatter = qc->n_elem;
 		task->data_dir = qc->dma_dir;
-	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
+	} else if (!ata_is_data(qc->tf.protocol)) {
 		task->data_dir = DMA_NONE;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)


