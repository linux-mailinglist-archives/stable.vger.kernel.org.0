Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89B8E6589
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfJ0VDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbfJ0VDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:03:03 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5569720873;
        Sun, 27 Oct 2019 21:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210181;
        bh=3HIHj0GIBcAutRMnLSPPpw5aosuZHolhLDv0a8ZBVuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ip/r+I2mY23UAeQ5gf/yN3m7fg9cNZtM+hVZHMKrz14NQ0Exy8JTlFtRHw0msUe1Y
         sLKzA1fcoXc2bbPQ+T7o3kIuc5IPFs/dKnFuKXbeg7I45Qn1LMNXCrXKuwyRQrwFGc
         wB8cYLLnnV/Yom/FknwoJ4+HIBbamMZmDwKVPMkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 19/41] USB: legousbtower: fix memleak on disconnect
Date:   Sun, 27 Oct 2019 22:00:57 +0100
Message-Id: <20191027203116.029871693@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
References: <20191027203056.220821342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b6c03e5f7b463efcafd1ce141bd5a8fc4e583ae2 upstream.

If disconnect() races with release() after a process has been
interrupted, release() could end up returning early and the driver would
fail to free its driver data.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191010125835.27031-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/legousbtower.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -425,10 +425,7 @@ static int tower_release (struct inode *
 		goto exit;
 	}
 
-	if (mutex_lock_interruptible(&dev->lock)) {
-	        retval = -ERESTARTSYS;
-		goto exit;
-	}
+	mutex_lock(&dev->lock);
 
 	if (dev->open_count != 1) {
 		dev_dbg(&dev->udev->dev, "%s: device not opened exactly once\n",


