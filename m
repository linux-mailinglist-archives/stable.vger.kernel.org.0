Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD72480016
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239621AbhL0Pm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbhL0PlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89E9C06175D;
        Mon, 27 Dec 2021 07:40:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2AB69CE10D2;
        Mon, 27 Dec 2021 15:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6F9C36AE7;
        Mon, 27 Dec 2021 15:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619602;
        bh=3za8ShKFypf2gtjUMw0RZPcP1wQ3ppYpJLRO0U8bkv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wx+TBBIZcUSTUs/kzEYTp0CxTfn9/Hur4dhCZ9y0EOGLi/w1mVyAmZt0T7cvcAMW0
         TAC5BSkfVqagkPs+AK+Aj3FgyRD9SqnQ0f9vZ4XF9VoL8FWEcJ6rtCf5LsMuNrDCgz
         cRbaSL7Tv6VMunYWY0H3FXVRezfBJwkPrT5zvqTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 74/76] hamradio: defer ax25 kfree after unregister_netdev
Date:   Mon, 27 Dec 2021 16:31:29 +0100
Message-Id: <20211227151327.253220546@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 3e0588c291d6ce225f2b891753ca41d45ba42469 upstream.

There is a possible race condition (use-after-free) like below

 (USE)                       |  (FREE)
ax25_sendmsg                 |
 ax25_queue_xmit             |
  dev_queue_xmit             |
   __dev_queue_xmit          |
    __dev_xmit_skb           |
     sch_direct_xmit         | ...
      xmit_one               |
       netdev_start_xmit     | tty_ldisc_kill
        __netdev_start_xmit  |  mkiss_close
         ax_xmit             |   kfree
          ax_encaps          |
                             |

Even though there are two synchronization primitives before the kfree:
1. wait_for_completion(&ax->dead). This can prevent the race with
routines from mkiss_ioctl. However, it cannot stop the routine coming
from upper layer, i.e., the ax25_sendmsg.

2. netif_stop_queue(ax->dev). It seems that this line of code aims to
halt the transmit queue but it fails to stop the routine that already
being xmit.

This patch reorder the kfree after the unregister_netdev to avoid the
possible UAF as the unregister_netdev() is well synchronized and won't
return if there is a running routine.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hamradio/mkiss.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -792,13 +792,14 @@ static void mkiss_close(struct tty_struc
 	 */
 	netif_stop_queue(ax->dev);
 
-	/* Free all AX25 frame buffers. */
-	kfree(ax->rbuff);
-	kfree(ax->xbuff);
-
 	ax->tty = NULL;
 
 	unregister_netdev(ax->dev);
+
+	/* Free all AX25 frame buffers after unreg. */
+	kfree(ax->rbuff);
+	kfree(ax->xbuff);
+
 	free_netdev(ax->dev);
 }
 


