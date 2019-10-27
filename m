Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7985AE687E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbfJ0VVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731332AbfJ0VVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA9422070B;
        Sun, 27 Oct 2019 21:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211298;
        bh=DioYuE2Fc1xH/kz026vrOKLVWTO8UGykrlspo4l5FX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HduiD5EZd6P9RI3Ehg1s9Ai9mAxsQQ2YsEyBE2AqkSHA2Do4it3T+RFnHK8chYcjn
         aVqTl9DbWUvrbYe8jgTbTv5TgwKWmYCNrvHHGGt43kDicftgD3iZ+NR+/YXmv1latr
         +XcOrRa+rHLS7qYkcK3C1Ih2TBJxm54kd4IHLYfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 103/197] USB: ldusb: fix memleak on disconnect
Date:   Sun, 27 Oct 2019 22:00:21 +0100
Message-Id: <20191027203357.324669754@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b14a39048c1156cfee76228bf449852da2f14df8 upstream.

If disconnect() races with release() after a process has been
interrupted, release() could end up returning early and the driver would
fail to free its driver data.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191010125835.27031-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/ldusb.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -380,10 +380,7 @@ static int ld_usb_release(struct inode *
 		goto exit;
 	}
 
-	if (mutex_lock_interruptible(&dev->mutex)) {
-		retval = -ERESTARTSYS;
-		goto exit;
-	}
+	mutex_lock(&dev->mutex);
 
 	if (dev->open_count != 1) {
 		retval = -ENODEV;


