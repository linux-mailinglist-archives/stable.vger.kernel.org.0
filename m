Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3730915C41D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbgBMP1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387638AbgBMP1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:01 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A87D824676;
        Thu, 13 Feb 2020 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607620;
        bh=p6JrbT3CgbN40TmXB28kT1XvH8v/sceqsNnGlOEqp48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=132T4Gls7UQ1PjAnW172ogKLcv1RGC9EgH5PKoDsdehieiKFotHQMvOFVYEbUUfhB
         lr2z/6LYaI9ECjJxJ5L+C7dv6U3p1SL0RsIH6Mj8k6rbiewnXnN6EGPposiHbmaS+I
         WIUqOr7Y2P9CnTBbNY3xs0a8V0n33CGKwyepWnvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Sheng <wesley.sheng@microchip.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 15/96] PCI/switchtec: Use dma_set_mask_and_coherent()
Date:   Thu, 13 Feb 2020 07:20:22 -0800
Message-Id: <20200213151845.371550113@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Sheng <wesley.sheng@microchip.com>

commit aa82130a22f77c1aa5794703730304d035a0c1f4 upstream.

Use dma_set_mask_and_coherent() instead of dma_set_coherent_mask() as the
Switchtec hardware fully supports 64bit addressing and we should set both
the streaming and coherent masks the same.

[logang@deltatee.com: reworked commit message]
Fixes: aff614c6339c ("switchtec: Set DMA coherent mask")
Link: https://lore.kernel.org/r/20200106190337.2428-2-logang@deltatee.com
Signed-off-by: Wesley Sheng <wesley.sheng@microchip.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/switch/switchtec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1349,7 +1349,7 @@ static int switchtec_init_pci(struct swi
 	if (rc)
 		return rc;
 
-	rc = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
+	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (rc)
 		return rc;
 


