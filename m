Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43928D2380
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388054AbfJJInP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387767AbfJJInP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:43:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A6D121D6C;
        Thu, 10 Oct 2019 08:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696993;
        bh=6aJTqbREb2X6AGt6ZSLFhTjF2AAoUGnOEamyy4LHoCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGsdosJV8HA42rSJqlnHTyQmrrZK7i6anZriQQY7D17boVifKwjtIP23yTrnAQ2Pi
         ge1JfRuTAxi4DuOm7M3ihzX6z0ZwtR8hRKLYQkmLgYQkIhoSSt7nPGE4ovnPzgF0OV
         7hQbGGvRzGOyfv9LeP548hwKhmWHKXPhVtvhYJvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>,
        syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.3 084/148] ieee802154: atusb: fix use-after-free at disconnect
Date:   Thu, 10 Oct 2019 10:35:45 +0200
Message-Id: <20191010083616.434288544@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 7fd25e6fc035f4b04b75bca6d7e8daa069603a76 upstream.

The disconnect callback was accessing the hardware-descriptor private
data after having having freed it.

Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
Cc: stable <stable@vger.kernel.org>     # 4.2
Cc: Alexander Aring <alex.aring@gmail.com>
Reported-by: syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ieee802154/atusb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -1137,10 +1137,11 @@ static void atusb_disconnect(struct usb_
 
 	ieee802154_unregister_hw(atusb->hw);
 
+	usb_put_dev(atusb->usb_dev);
+
 	ieee802154_free_hw(atusb->hw);
 
 	usb_set_intfdata(interface, NULL);
-	usb_put_dev(atusb->usb_dev);
 
 	pr_debug("%s done\n", __func__);
 }


