Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF21E50576D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244337AbiDRN4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245723AbiDRNx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:53:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0584706A;
        Mon, 18 Apr 2022 06:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F4D60B35;
        Mon, 18 Apr 2022 13:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EA4C385A7;
        Mon, 18 Apr 2022 13:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286987;
        bh=tS0bT0Ob+m2K2tG+sUf7Vtwmj0hwg1nLUyR2Yj1v28w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjEoRNEZpPbo34YDYmVxQuKpXFmTG8ZUAMRjuzrtj36wPxUYUc/8Ll+OiKIbUJaNF
         6gZnOiFoZwAI9ELfmQFCDSXqnltlOnd4Ow280w9SmpKsg+cChQrFrmvVND60lIElbj
         DYGoNQ/NE5nYN5IuyyTlpm4T6OL9I7dsOaryewTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 023/218] scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Mon, 18 Apr 2022 14:11:29 +0200
Message-Id: <20220418121159.899603887@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -220,7 +220,7 @@ static unsigned int sas_ata_qc_issue(str
 		task->total_xfer_len = qc->nbytes;
 		task->num_scatter = qc->n_elem;
 		task->data_dir = qc->dma_dir;
-	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
+	} else if (!ata_is_data(qc->tf.protocol)) {
 		task->data_dir = DMA_NONE;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)


