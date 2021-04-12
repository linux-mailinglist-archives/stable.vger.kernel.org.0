Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD3435BCC0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbhDLIpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237684AbhDLIoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:44:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A457A61244;
        Mon, 12 Apr 2021 08:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217061;
        bh=8XOWMIPBmbKHHSR25LAe+Vbq5bi2Pt9pxj3t3k7/gQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOYc3sLO2yKTxIvIjdKrWqLmJnvMdu1X3ps8rUe5rGwW8PDbz7xLtPtu/jOx/yiB0
         cocrEs8a2hmkrYbp52oBi2Z9bxbnkOREPQr24H3udMabMBze8bDxPqOVHZnCDR8mbw
         8vuSkfIoaVYW/VgpgHlOWjYr2H2tov558rt+yVcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+28a246747e0a465127f3@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 55/66] drivers: net: fix memory leak in atusb_probe
Date:   Mon, 12 Apr 2021 10:41:01 +0200
Message-Id: <20210412083959.905504178@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 6b9fbe16955152626557ec6f439f3407b7769941 upstream.

syzbot reported memory leak in atusb_probe()[1].
The problem was in atusb_alloc_urbs().
Since urb is anchored, we need to release the reference
to correctly free the urb

backtrace:
    [<ffffffff82ba0466>] kmalloc include/linux/slab.h:559 [inline]
    [<ffffffff82ba0466>] usb_alloc_urb+0x66/0xe0 drivers/usb/core/urb.c:74
    [<ffffffff82ad3888>] atusb_alloc_urbs drivers/net/ieee802154/atusb.c:362 [inline][2]
    [<ffffffff82ad3888>] atusb_probe+0x158/0x820 drivers/net/ieee802154/atusb.c:1038 [1]

Reported-by: syzbot+28a246747e0a465127f3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/atusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -368,6 +368,7 @@ static int atusb_alloc_urbs(struct atusb
 			return -ENOMEM;
 		}
 		usb_anchor_urb(urb, &atusb->idle_urbs);
+		usb_free_urb(urb);
 		n--;
 	}
 	return 0;


