Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3783235406C
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbhDEJRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239715AbhDEJRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6418360FE4;
        Mon,  5 Apr 2021 09:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614247;
        bh=Vc5k0RGmfhgCwOgqXqo0y2ZlrWMWi4ngE+017w1Qqec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRhC4wMSuuSAJ2P1OGPGxlxutW5SUbvzq+nebcd9XKSdqiSvvegFHxOI35QBhIBAQ
         3lBM3UQo9sQL6VpXyX26rg7zrlpXQH8Z25zb1t30j5hZz2KTKVuu1Xgrk8uTvCHTtA
         hToGJ75HoSba/jKx8VAlvTLMSLIflpGr743gEc2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 137/152] USB: cdc-acm: fix double free on probe failure
Date:   Mon,  5 Apr 2021 10:54:46 +0200
Message-Id: <20210405085038.670052853@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 7180495cb3d0e2a2860d282a468b4146c21da78f upstream.

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
Link: https://lore.kernel.org/r/20210322155318.9837-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1521,7 +1521,6 @@ alloc_fail6:
 				&dev_attr_wCountryCodes);
 		device_remove_file(&acm->control->dev,
 				&dev_attr_iCountryCodeRelDate);
-		kfree(acm->country_codes);
 	}
 	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 alloc_fail5:


