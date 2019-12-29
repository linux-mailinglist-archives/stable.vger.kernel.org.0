Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B545812C91D
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387643AbfL2SAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732557AbfL2R53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D77C8227BF;
        Sun, 29 Dec 2019 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642249;
        bh=GkB5R2UJ6ARn4a70f3TzS5/TimRwnPueAlRS5du8h58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVEH046f1SXFRAN3PSTM05Pzt4SK50jxt1r2fscrbGGXdU2M3RAIf3ScToVqw3NYA
         9OYj65scrOQFN8jfrPLIcKYEyoGAjVecy0+2kLHH36Twn3K0kdeOwlmwFUeWG6Zj8+
         AhP9XHfGewia7aHP+Tr9oOqRJOGqZAdgF34+x5PI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 403/434] staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value
Date:   Sun, 29 Dec 2019 18:27:36 +0100
Message-Id: <20191229172729.346408516@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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
@@ -623,6 +623,11 @@ static int gsc_hpdi_auto_attach(struct c
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
@@ -630,6 +635,11 @@ static int gsc_hpdi_auto_attach(struct c
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


