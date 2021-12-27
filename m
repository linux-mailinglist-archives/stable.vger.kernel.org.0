Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9FB480021
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239172AbhL0PnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239102AbhL0PlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45537C06175E;
        Mon, 27 Dec 2021 07:40:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C66C8CE10D2;
        Mon, 27 Dec 2021 15:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD232C36AE7;
        Mon, 27 Dec 2021 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619605;
        bh=0hrgJNxdNh9Mbe1pCvXmSFIk6P7WyoFBiRXUib7l0CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6BhUIVe9dhrLlTf9qTywKjDiAzI7Ri4LIR9ENTXMYmlfnn3v/RpBbxxqHyd3WsaU
         nUEvwhtFH+iiUusi7SiLo2p1W+PjkBS3BqiwGpSuUGDPDccGoDb75zMzn2aRNN68wG
         rkMT1CnmYsG0UPIJ3pBUKlAmqvwD6Oyiwn2mrqj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 75/76] hamradio: improve the incomplete fix to avoid NPD
Date:   Mon, 27 Dec 2021 16:31:30 +0100
Message-Id: <20211227151327.285330134@linuxfoundation.org>
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

commit b2f37aead1b82a770c48b5d583f35ec22aabb61e upstream.

The previous commit 3e0588c291d6 ("hamradio: defer ax25 kfree after
unregister_netdev") reorder the kfree operations and unregister_netdev
operation to prevent UAF.

This commit improves the previous one by also deferring the nullify of
the ax->tty pointer. Otherwise, a NULL pointer dereference bug occurs.
Partial of the stack trace is shown below.

BUG: kernel NULL pointer dereference, address: 0000000000000538
RIP: 0010:ax_xmit+0x1f9/0x400
...
Call Trace:
 dev_hard_start_xmit+0xec/0x320
 sch_direct_xmit+0xea/0x240
 __qdisc_run+0x166/0x5c0
 __dev_queue_xmit+0x2c7/0xaf0
 ax25_std_establish_data_link+0x59/0x60
 ax25_connect+0x3a0/0x500
 ? security_socket_connect+0x2b/0x40
 __sys_connect+0x96/0xc0
 ? __hrtimer_init+0xc0/0xc0
 ? common_nsleep+0x2e/0x50
 ? switch_fpu_return+0x139/0x1a0
 __x64_sys_connect+0x11/0x20
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The crash point is shown as below

static void ax_encaps(...) {
  ...
  set_bit(TTY_DO_WRITE_WAKEUP, &ax->tty->flags); // ax->tty = NULL!
  ...
}

By placing the nullify action after the unregister_netdev, the ax->tty
pointer won't be assigned as NULL net_device framework layer is well
synchronized.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hamradio/mkiss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -792,14 +792,14 @@ static void mkiss_close(struct tty_struc
 	 */
 	netif_stop_queue(ax->dev);
 
-	ax->tty = NULL;
-
 	unregister_netdev(ax->dev);
 
 	/* Free all AX25 frame buffers after unreg. */
 	kfree(ax->rbuff);
 	kfree(ax->xbuff);
 
+	ax->tty = NULL;
+
 	free_netdev(ax->dev);
 }
 


