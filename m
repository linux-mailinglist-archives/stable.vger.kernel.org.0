Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1345340943
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 16:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhCRPwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 11:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231640AbhCRPwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 11:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A0B364F2B;
        Thu, 18 Mar 2021 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616082720;
        bh=e/lpZ0wThnKoFB2K3ago5r1z4Pnc0Pi1QIWPHg8ZIis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2f991Fp9+EGj3b9w0kw5Uab5TCCeytBeL+jShcRQeU/yB3qKGmG2NStUqWsJrRX5
         L33LvCWnzfWzNSW4Ao1A8O02hQJB9LJpwqrFa1Y+Ko2KcJmif/AeEqtUC4zh6kRWN8
         18y5FkcNKSnqFhD0BcTfEF7Peu+mdNzXrhsBTL0NUZ/IgwtnXocd+uOJf8XW+BA5Ln
         YdRGRcFL1opuzkotir6nQKKsaGdZkGlsOvGBpYCI6kA11ON+0DBeZtMGG2ScibNnpD
         sr0eOdyTxy9kq+54ndShc73TQnAaDbXxerTD6JoiF4grFhC/3Z3oqQ0Eu9Z2XB7Aph
         eEgNXRsXzQ0ug==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lMuwb-0005nQ-Vb; Thu, 18 Mar 2021 16:52:18 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Jaejoong Kim <climbbb.kim@gmail.com>
Subject: [PATCH 1/7] USB: cdc-acm: fix double free on probe failure
Date:   Thu, 18 Mar 2021 16:51:56 +0100
Message-Id: <20210318155202.22230-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210318155202.22230-1-johan@kernel.org>
References: <20210318155202.22230-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If tty-device registration fails the driver copy of any Country
Selection functional descriptor would end up being freed twice; first
explicitly in the error path and then again in the tty-port destructor.

Drop the first erroneous free that was left when fixing a tty-port
resource leak.

Fixes: cae2bc768d17 ("usb: cdc-acm: Decrement tty port's refcount if probe() fail")
Cc: stable@vger.kernel.org      # 4.19
Cc: Jaejoong Kim <climbbb.kim@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 39ddb5585ded..d75a78ad464d 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1508,7 +1508,6 @@ static int acm_probe(struct usb_interface *intf,
 				&dev_attr_wCountryCodes);
 		device_remove_file(&acm->control->dev,
 				&dev_attr_iCountryCodeRelDate);
-		kfree(acm->country_codes);
 	}
 	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 alloc_fail5:
-- 
2.26.2

