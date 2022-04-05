Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAE54F31F8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiDEJCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237567AbiDEImt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834911276A;
        Tue,  5 Apr 2022 01:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FF4060B0A;
        Tue,  5 Apr 2022 08:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E58C385A1;
        Tue,  5 Apr 2022 08:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147710;
        bh=hzFTItGk6MhMLG5gB5eFJka/S3aQMbJUpwbjLiXXVC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQUgH3GOgXweSkXo5n+U6IynUKmX188LDJ3LDBaD83Ya3oUjyxN6mGCmNrdyzPClT
         aU4AXfAeBOk1Nyeei1fRJ5qqJ6LWTMeN8OmCUVxK2c9hdRT3Rrs5yXzV68Oiecol8Q
         8wGM8miDZdJ5rR9CSzQRAEzFlC3ERbvg2f2gfIZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0094/1017] scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Tue,  5 Apr 2022 09:16:47 +0200
Message-Id: <20220405070356.986151516@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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


