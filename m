Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D4247AD7B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbhLTOw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbhLTOu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B232FC08EA7C;
        Mon, 20 Dec 2021 06:46:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 505206118D;
        Mon, 20 Dec 2021 14:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B71C36AE8;
        Mon, 20 Dec 2021 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011588;
        bh=qjbLCr7WezyGujUnfNKHiHahd0qXWnFt5PQeFpZpxc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfFCKvKICMb0auA/2vi5IF0X2+71UfR2v/xImTCUf/8Jjol5RgoBdD/GKGndwluf7
         n70AEL2KKLiExwIwWJuywoQPu3FpKX3CL9sSNHCUai6ILXJkpmNb0NKzhhxtA1HF+m
         jnrGRCWB/YY3Dvukhu0zn0+pWvPkYIHjS1ThTJ4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 66/71] Revert "xsk: Do not sleep in poll() when need_wakeup set"
Date:   Mon, 20 Dec 2021 15:34:55 +0100
Message-Id: <20211220143027.900680008@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit 0706a78f31c4217ca144f630063ec9561a21548d upstream.

This reverts commit bd0687c18e635b63233dc87f38058cd728802ab4.

This patch causes a Tx only workload to go to sleep even when it does
not have to, leading to misserable performance in skb mode. It fixed
one rare problem but created a much worse one, so this need to be
reverted while I try to craft a proper solution to the original
problem.

Fixes: bd0687c18e63 ("xsk: Do not sleep in poll() when need_wakeup set")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211217145646.26449-1-magnus.karlsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -434,6 +434,8 @@ static __poll_t xsk_poll(struct file *fi
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xdp_umem *umem;
 
+	sock_poll_wait(file, sock, wait);
+
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
@@ -445,8 +447,6 @@ static __poll_t xsk_poll(struct file *fi
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
-	} else {
-		sock_poll_wait(file, sock, wait);
 	}
 
 	if (xs->rx && !xskq_empty_desc(xs->rx))


