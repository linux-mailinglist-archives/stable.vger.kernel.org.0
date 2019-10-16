Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D3BD9DB9
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394779AbfJPVw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394765AbfJPVw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:52:28 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A005F218DE;
        Wed, 16 Oct 2019 21:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262747;
        bh=1pWgX6uDTUOH3YJheezI2u1Praf4IWP5+BgBbA3TdN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUWgP8ZmeakA17yihpJiWULISmUQC9yjkGCusyWPj3BtKVaIZS/oqQESCYvRk42z9
         iYKT8yC1M3/YCPaZui5kY5aygy7Z2+JxZeCw2HFdowIWwcx77P7jzR/dlpTctgOmIA
         g5tgD2dZ37OMJurj0CubIL4ZAZj0gNUvQYGuWz20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>,
        syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.4 10/79] ieee802154: atusb: fix use-after-free at disconnect
Date:   Wed, 16 Oct 2019 14:49:45 -0700
Message-Id: <20191016214738.771838140@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
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
@@ -756,10 +756,11 @@ static void atusb_disconnect(struct usb_
 
 	ieee802154_unregister_hw(atusb->hw);
 
+	usb_put_dev(atusb->usb_dev);
+
 	ieee802154_free_hw(atusb->hw);
 
 	usb_set_intfdata(interface, NULL);
-	usb_put_dev(atusb->usb_dev);
 
 	pr_debug("atusb_disconnect done\n");
 }


