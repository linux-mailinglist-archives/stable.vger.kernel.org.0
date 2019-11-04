Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF41EEC3B
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbfKDVzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:55:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388075AbfKDVzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:55:09 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99930217F4;
        Mon,  4 Nov 2019 21:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904509;
        bh=UV1M5/gA4SkMgON+EcMHEN4/oOwh67vj+z8Wz/ZKckc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQHDR7ZjEjWsfn3cB2KeAyPoF3lMgSFeGO1+fUv4cJCcMOz0PGIXQIiHrPbejw0Zn
         xD49dsxm1Vm0R9Vu+BoorIy4sXoot8QgIoGiyz3INh8WmK5dxjSDfeH1DlupvzNueu
         NwtlcGtt3rErgRNBPGDEbm0d8hlwtS69h8JOFq+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 70/95] USB: ldusb: fix ring-buffer locking
Date:   Mon,  4 Nov 2019 22:45:08 +0100
Message-Id: <20191104212113.778507135@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit d98ee2a19c3334e9343df3ce254b496f1fc428eb upstream.

The custom ring-buffer implementation was merged without any locking or
explicit memory barriers, but a spinlock was later added by commit
9d33efd9a791 ("USB: ldusb bugfix").

The lock did not cover the update of the tail index once the entry had
been processed, something which could lead to memory corruption on
weakly ordered architectures or due to compiler optimisations.

Specifically, a completion handler running on another CPU might observe
the incremented tail index and update the entry before ld_usb_read() is
done with it.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Fixes: 9d33efd9a791 ("USB: ldusb bugfix")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191022143203.5260-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/ldusb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -498,11 +498,11 @@ static ssize_t ld_usb_read(struct file *
 		retval = -EFAULT;
 		goto unlock_exit;
 	}
-	dev->ring_tail = (dev->ring_tail+1) % ring_buffer_size;
-
 	retval = bytes_to_read;
 
 	spin_lock_irq(&dev->rbsl);
+	dev->ring_tail = (dev->ring_tail + 1) % ring_buffer_size;
+
 	if (dev->buffer_overflow) {
 		dev->buffer_overflow = 0;
 		spin_unlock_irq(&dev->rbsl);


