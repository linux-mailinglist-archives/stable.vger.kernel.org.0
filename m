Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0233712C9C6
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfL2R1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbfL2R1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:27:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96EA7207FF;
        Sun, 29 Dec 2019 17:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640421;
        bh=gDNljlF11NNJt87x/cTDiyTrXxvQj868zamGs1Win84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyS7hsBZRliSANBAUoBDLhHNNnbJpxhCPrVNjnv7H6KPyN4LHUdlNR4+Lsu0F2rfu
         B8VD0BGcs0LymxCaM1Fk6Xo+upEdbq/cqJA2a4UsB50cVYF2WmHuxia4OSfvbfTQmI
         KeB7OVkdwNiVTNNzBe5UfPNtCPiqMXg/KuujDhpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 150/161] staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value
Date:   Sun, 29 Dec 2019 18:19:58 +0100
Message-Id: <20191229162446.612345868@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit ab42b48f32d4c766420c3499ee9c0289b7028182 upstream.

The "auto-attach" handler function `gsc_hpdi_auto_attach()` calls
`dma_alloc_coherent()` in a loop to allocate some DMA data buffers, and
also calls it to allocate a buffer for a DMA descriptor chain.  However,
it does not check the return value of any of these calls.  Change
`gsc_hpdi_auto_attach()` to return `-ENOMEM` if any of these
`dma_alloc_coherent()` calls fail.  This will result in the comedi core
calling the "detach" handler `gsc_hpdi_detach()` as part of the
clean-up, which will call `gsc_hpdi_free_dma()` to free any allocated
DMA coherent memory buffers.

Cc: <stable@vger.kernel.org> #4.6+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20191216110823.216237-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/gsc_hpdi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -632,6 +632,11 @@ static int gsc_hpdi_auto_attach(struct c
 		    dma_alloc_coherent(&pcidev->dev, DMA_BUFFER_SIZE,
 				       &devpriv->dio_buffer_phys_addr[i],
 				       GFP_KERNEL);
+		if (!devpriv->dio_buffer[i]) {
+			dev_warn(dev->class_dev,
+				 "failed to allocate DMA buffer\n");
+			return -ENOMEM;
+		}
 	}
 	/* allocate dma descriptors */
 	devpriv->dma_desc = dma_alloc_coherent(&pcidev->dev,
@@ -639,6 +644,11 @@ static int gsc_hpdi_auto_attach(struct c
 					       NUM_DMA_DESCRIPTORS,
 					       &devpriv->dma_desc_phys_addr,
 					       GFP_KERNEL);
+	if (!devpriv->dma_desc) {
+		dev_warn(dev->class_dev,
+			 "failed to allocate DMA descriptors\n");
+		return -ENOMEM;
+	}
 	if (devpriv->dma_desc_phys_addr & 0xf) {
 		dev_warn(dev->class_dev,
 			 " dma descriptors not quad-word aligned (bug)\n");


