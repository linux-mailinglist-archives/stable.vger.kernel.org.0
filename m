Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D4F3449CC
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 16:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhCVPxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 11:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhCVPxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 11:53:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA01D619AB;
        Mon, 22 Mar 2021 15:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616428394;
        bh=iahYK4r7WtNOdjL/Bg1oM/WoYw/NIOXasi54gp8KbEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2sJ7slOeIHlf3Q8GdYebQNBIiz8WkOMIYxta7kN3IgOWQD9AVjhaSEpowsbSHW4t
         BAnmOlKCt+GZRle1GLEy+DbP4+eEDWUChRNmQSf4VfVRRU6VARgZOzomWsVTMmx5z8
         yNG0lOMFoNT2UZ5vIhu+CqFB8e+AJ7vb1v9wTMtSILBcywhbiXar0TP19M16ttLZZm
         evVYGqFjiZApflVk6GYa/hX6qsY+UCb3U77LdMzHo0mklDgMblLCJfMyHCS+ojLl0h
         2Cz6i3wY7RKHxzOsiOG865+JJTbc9uK+WDyU52jm6vZR8tIjGlEu9nEUQANEHwtJZU
         uEaelfClbCqFA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lOMs0-0002ZY-IJ; Mon, 22 Mar 2021 16:53:32 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Jaejoong Kim <climbbb.kim@gmail.com>
Subject: [PATCH v2 1/8] USB: cdc-acm: fix double free on probe failure
Date:   Mon, 22 Mar 2021 16:53:11 +0100
Message-Id: <20210322155318.9837-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210322155318.9837-1-johan@kernel.org>
References: <20210322155318.9837-1-johan@kernel.org>
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
Acked-by: Oliver Neukum <oneukum@suse.com>
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
2.26.3

