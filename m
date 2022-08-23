Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8070459DBB4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354343AbiHWKc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354851AbiHWK3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:29:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDD2A4B37;
        Tue, 23 Aug 2022 02:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F3BA61598;
        Tue, 23 Aug 2022 09:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D5BC433D6;
        Tue, 23 Aug 2022 09:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245579;
        bh=EMvzIdefN3lMaZ3idynwCzn/gclQRL0S2MQySKvo1z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3dCPzURf2rNWxxM+dWBFxdGdkSqkS6lPhzQmhagVsv03a78JM3cyIAowuvXJSCg3
         jA4Lj7czdXCm53nSWHv5xljTRF5pNKo3TrOqj/BJ7xwD7ZGwnvbWoksyCv6bFfzsmp
         tjdqvRW1cQIbpt0LzcXm1hDuhQexvbDRqWbIPa20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/287] misc: rtsx: Fix an error handling path in rtsx_pci_probe()
Date:   Tue, 23 Aug 2022 10:24:51 +0200
Message-Id: <20220823080104.499177350@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 44fd1917314e9d4f53dd95dd65df1c152f503d3a ]

If an error occurs after a successful idr_alloc() call, the corresponding
resource must be released with idr_remove() as already done in the .remove
function.

Update the error handling path to add the missing idr_remove() call.

Fixes: ada8a8a13b13 ("mfd: Add realtek pcie card reader driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/e8dc41716cbf52fb37a12e70d8972848e69df6d6.1655271216.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 3eb3c237f339..80b9f36dbca4 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1479,7 +1479,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	pcr->remap_addr = ioremap_nocache(base, len);
 	if (!pcr->remap_addr) {
 		ret = -ENOMEM;
-		goto free_handle;
+		goto free_idr;
 	}
 
 	pcr->rtsx_resv_buf = dma_alloc_coherent(&(pcidev->dev),
@@ -1541,6 +1541,10 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 			pcr->rtsx_resv_buf, pcr->rtsx_resv_buf_addr);
 unmap:
 	iounmap(pcr->remap_addr);
+free_idr:
+	spin_lock(&rtsx_pci_lock);
+	idr_remove(&rtsx_pci_idr, pcr->id);
+	spin_unlock(&rtsx_pci_lock);
 free_handle:
 	kfree(handle);
 free_pcr:
-- 
2.35.1



