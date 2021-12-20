Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D31647AFBC
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbhLTPSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbhLTPRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:17:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83966C08E9BA;
        Mon, 20 Dec 2021 06:58:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 256FE61183;
        Mon, 20 Dec 2021 14:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F42BC36AE7;
        Mon, 20 Dec 2021 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012309;
        bh=Im4tbQPwP58RFUcR/Ks3T2gBkUksFtFY3ChGZAR2pjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcokpnYVXg33JOyRb4W6H9+xQoGXXxU4kiwgjqFtOIqtUDOjpbcPrVEynehpLAmDV
         20U5vwEXVCI2K99+UTObsDaf1zcBUDJrKXtNpF5p4M/Y4MoEBgqV0mWsb5NfxdQDgS
         MM+oZQo3hVa4WZnMdwJaBSFYS5RDKn2rLM/lYsPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Wiles <keith.wiles@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH 5.15 155/177] xsk: Do not sleep in poll() when need_wakeup set
Date:   Mon, 20 Dec 2021 15:35:05 +0100
Message-Id: <20211220143045.289751892@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit bd0687c18e635b63233dc87f38058cd728802ab4 upstream.

Do not sleep in poll() when the need_wakeup flag is set. When this
flag is set, the application needs to explicitly wake up the driver
with a syscall (poll, recvmsg, sendmsg, etc.) to guarantee that Rx
and/or Tx processing will be processed promptly. But the current code
in poll(), sleeps first then wakes up the driver. This means that no
driver processing will occur (baring any interrupts) until the timeout
has expired.

Fix this by checking the need_wakeup flag first and if set, wake the
driver and return to the application. Only if need_wakeup is not set
should the process sleep if there is a timeout set in the poll() call.

Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
Reported-by: Keith Wiles <keith.wiles@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/bpf/20211214102607.7677-1-magnus.karlsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -692,8 +692,6 @@ static __poll_t xsk_poll(struct file *fi
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xsk_buff_pool *pool;
 
-	sock_poll_wait(file, sock, wait);
-
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
@@ -705,6 +703,8 @@ static __poll_t xsk_poll(struct file *fi
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
+	} else {
+		sock_poll_wait(file, sock, wait);
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))


