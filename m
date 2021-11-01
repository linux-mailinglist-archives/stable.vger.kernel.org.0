Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AA9441632
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhKAJXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232284AbhKAJWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C67761179;
        Mon,  1 Nov 2021 09:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758394;
        bh=Sal7EXgUueWRxWeko37X1V1bBDOT8ItcE49Zb/dJ8sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLKmrwo1/nHv02prLgBtSspb6uEKHojfcTkr1mE+kM7V5CxUSoC0sH5oZDnR2CPyK
         EH48EShMifa2xvZvmw9vkXibuNGzHrIfLFO7dFLCfS1sQ4dR7UHx05UsL0zi0bCpKN
         jxok8TyLtLH9sIoXr1QvPMlR+G5Uczwo/UVaSKXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Johan Hovold <johan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 07/20] usbnet: fix error return code in usbnet_probe()
Date:   Mon,  1 Nov 2021 10:17:16 +0100
Message-Id: <20211101082445.753125621@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082444.133899096@linuxfoundation.org>
References: <20211101082444.133899096@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

commit 6f7c88691191e6c52ef2543d6f1da8d360b27a24 upstream.

Return error code if usb_maxpacket() returns 0 in usbnet_probe()

Fixes: 397430b50a36 ("usbnet: sanity check for maxpacket")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211026124015.3025136-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1742,6 +1742,7 @@ usbnet_probe (struct usb_interface *udev
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
 	if (dev->maxpacket == 0) {
 		/* that is a broken device */
+		status = -ENODEV;
 		goto out4;
 	}
 


