Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885DA120389
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 12:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfLPLQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 06:16:46 -0500
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:49816 "EHLO
        smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfLPLQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 06:16:46 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2019 06:16:45 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1576494517;
        bh=WLd3xrSEYO6aiQo721gX/dm1JxG+nSUMrXStEQ3wHvg=;
        h=From:To:Subject:Date:From;
        b=Ai9v+y06+7s03bsmweD4dpbrDAJ2oyNXhg0znMjL7Sl+ZU99hTqryl5YGUOrjNQEY
         S1By6Bgkcr+crqgDmYFrtSa5lEk99te3bQx8y20+C5HjYiEy+dHTOKifMgkcShxut1
         Wrg914oSAHDqpyvv+aloXiVnuaxD9vQsQnKBYHdU=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp8.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 3F646A015C;
        Mon, 16 Dec 2019 06:08:36 -0500 (EST)
X-Sender-Id: abbotti@mev.co.uk
Received: from ian-deb.inside.mev.co.uk (remote.quintadena.com [81.133.34.160])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Mon, 16 Dec 2019 06:08:37 -0500
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH] staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value
Date:   Mon, 16 Dec 2019 11:08:23 +0000
Message-Id: <20191216110823.216237-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
Note: Bug is also present in kernel 4.5 and earlier, but the patch will
not apply cleanly to those (the gsc_hpdi driver used to call
`pci_alloc_consistent()` instead of `dma_alloc_coherent()`).
---
 drivers/staging/comedi/drivers/gsc_hpdi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 4bdf44d82879..dc62db1ee1dd 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -623,6 +623,11 @@ static int gsc_hpdi_auto_attach(struct comedi_device *dev,
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
@@ -630,6 +635,11 @@ static int gsc_hpdi_auto_attach(struct comedi_device *dev,
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
-- 
2.24.0

