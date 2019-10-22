Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C8EE0677
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 16:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbfJVOcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 10:32:05 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34703 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfJVOcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 10:32:04 -0400
Received: by mail-lf1-f68.google.com with SMTP id f5so5577528lfp.1;
        Tue, 22 Oct 2019 07:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=myeyhwNwVXhKuqpYNf3n+ai6PyL9EWs0O9sOv9MeOw8=;
        b=ngzrsolloi+mOyy9bVnsBEQIqcA27mk2njOdo1Q7pnBHvrrClpHfbYwmRJTeXQyKKk
         6sVLXDuPudKyAwONHUrt8lB9CVaNeYrvT3lXjz9XfBwD5CK5xA54LY+c5GpDEGO03iCj
         0ngbX3U8G4nFVADNLVbOTa0YhJGmq/QmntD0gubRRNTa1BZbIR8EF+l0KYNi710hC6Mw
         Iq2xOEJGJ7+1deY82A+0SYtOKFCHs+8CRaPqzO+yh4CgytWbt12fkIVVlkXireRZ/Q6u
         v5+x/BrRuj9+Du8Hs3XOtrduD26ghHiZXN9DU6GvF1j4O1tk/eJn2fb/+koBtoKWIjsY
         VgNg==
X-Gm-Message-State: APjAAAWdVc/tTfWbDEwxTtDwRyZz4nsvml+JUSl/pyOilURwihNiSwuI
        EAi6X+LCE590Qv+9vrR9aR1cW5Ns
X-Google-Smtp-Source: APXvYqyI7YVeXw1Rb4IRXIrfB0jJD4y3jWE1pBYkTnaWUjJHQHR1rQt6+bLFw/1xFsZdMieQ/cKR6Q==
X-Received: by 2002:a19:7516:: with SMTP id y22mr18743353lfe.57.1571754722047;
        Tue, 22 Oct 2019 07:32:02 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id x13sm2126347ljb.92.2019.10.22.07.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 07:31:59 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iMvCn-0001Ng-Tc; Tue, 22 Oct 2019 16:32:13 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] USB: ldusb: fix ring-buffer locking
Date:   Tue, 22 Oct 2019 16:32:02 +0200
Message-Id: <20191022143203.5260-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191022143203.5260-1-johan@kernel.org>
References: <20191022143203.5260-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/misc/ldusb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 15b5f06fb0b3..c3e764909fd0 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -495,11 +495,11 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
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
-- 
2.23.0

