Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B8747FF6E
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbhL0Ph0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:37:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40572 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237642AbhL0Pgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E68D5CE10B6;
        Mon, 27 Dec 2021 15:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EBAC36AE7;
        Mon, 27 Dec 2021 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619393;
        bh=XzFIFJt3SJwiUPa1KICozvdDlmS4MNfX2qdCNuEQAdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLjx+qGOMYRvLsI2sPtQ2lRvmvoYNd6IUGE+LsN0rAfMbxIwo+e2qSdN9aFCqy4kp
         gKNrvgjLXIfubtN6eW+td94bZORrveoEbXVTd3CRn7w1mk/vH2tcWIeid57Hi2rR+C
         RzOx2l637fYVBBPaOvgY/EP1oqDXXYY0If+capMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 46/47] hamradio: improve the incomplete fix to avoid NPD
Date:   Mon, 27 Dec 2021 16:31:22 +0100
Message-Id: <20211227151322.385861668@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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
@@ -793,14 +793,14 @@ static void mkiss_close(struct tty_struc
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
 


