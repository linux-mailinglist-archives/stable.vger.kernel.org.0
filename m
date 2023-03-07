Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F636AF150
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjCGSmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbjCGSlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:41:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5FA9E321
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96C8C61514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD6DC433EF;
        Tue,  7 Mar 2023 18:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213875;
        bh=McXVmaGZIe5dH25Fw7zJhlCsWC6teei+TNOKX59zYa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dakH+KZxLDi6xCw4jIF2FSDYqaaFeEKHD/Hrf3NPVilYmhzprJJBOHcTw3rKncEEX
         8ek9zrMXxinzH5qquUs/YZahIDX3W648dpFa9BlqMLNlaJfBs+rNsNUaJmAOjvhbGC
         O8tUqsM6g0ctEEyyMjR1JEZa8HM5U8Ohn4IAs1Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.1 648/885] scsi: mpt3sas: Remove usage of dma_get_required_mask() API
Date:   Tue,  7 Mar 2023 17:59:42 +0100
Message-Id: <20230307170030.297642506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 06e472acf964649a58b7de35fc9cdc3151acb970 upstream.

Remove the usage of dma_get_required_mask() API.  Directly set the DMA mask
to 63/64 if the system is a 64bit machine.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20221028091655.17741-2-sreekanth.reddy@broadcom.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2992,8 +2992,7 @@ _base_config_dma_addressing(struct MPT3S
 	struct sysinfo s;
 	u64 coherent_dma_mask, dma_mask;
 
-	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
-	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32)) {
+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4) {
 		ioc->dma_mask = 32;
 		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */


