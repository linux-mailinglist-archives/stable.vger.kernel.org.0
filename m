Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304D742221D
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhJEJXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhJEJXQ (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E768261526;
        Tue,  5 Oct 2021 09:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425686;
        bh=Mg+5/mar1KkTHN1wz4UoE4RDeYJAbAKbgbdRkg1TYOs=;
        h=Subject:To:From:Date:From;
        b=fZFnrJh93jESEeH1cAT/X34IvVZWrIPNA6UHUE5Jxa9rPsUUA/M8XeXRJEkXs6NXz
         bndG+SWk89iU3iTvFivBYAkLGtpwcj92Au76p9AwjazdU9So2l5V+SZDRWp8XFthVL
         VwpbbAO/1hPTEUrW4R7+Mk6Zmg3PUwk22MMPuFDM=
Subject: patch "iio: accel: fxls8962af: return IRQ_HANDLED when fifo is flushed" added to staging-linus
To:     sean@geanix.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:20 +0200
Message-ID: <16334256809833@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: fxls8962af: return IRQ_HANDLED when fifo is flushed

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9033c7a357481fb5bcc1737bafa4aec572dca5c6 Mon Sep 17 00:00:00 2001
From: Sean Nyekjaer <sean@geanix.com>
Date: Tue, 17 Aug 2021 14:43:36 +0200
Subject: iio: accel: fxls8962af: return IRQ_HANDLED when fifo is flushed

fxls8962af_fifo_flush() will return the samples flushed.
So return IRQ_NONE only if an error is returned.

Fixes: 79e3a5bdd9ef ("iio: accel: fxls8962af: add hw buffered sampling")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20210817124336.1672169-1-sean@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/fxls8962af-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/fxls8962af-core.c b/drivers/iio/accel/fxls8962af-core.c
index 0019f1ea7df2..f41db9e0249a 100644
--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -738,7 +738,7 @@ static irqreturn_t fxls8962af_interrupt(int irq, void *p)
 
 	if (reg & FXLS8962AF_INT_STATUS_SRC_BUF) {
 		ret = fxls8962af_fifo_flush(indio_dev);
-		if (ret)
+		if (ret < 0)
 			return IRQ_NONE;
 
 		return IRQ_HANDLED;
-- 
2.33.0


