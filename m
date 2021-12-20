Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0D247AFD7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbhLTPUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238599AbhLTPSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:18:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BF2C019D8B;
        Mon, 20 Dec 2021 06:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E270A6119E;
        Mon, 20 Dec 2021 14:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54A1C36AE7;
        Mon, 20 Dec 2021 14:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012376;
        bh=WALEW7ISEHxknQeaXMMMR5mST5iAFqOYUjiAfuUwv4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2vtoZLEcUedU+LkbHVFrQ3UK9tlVzz6fdekrcGC2f8OpDOAcfBFZYji3a/thUZj0
         dv0FOBxhN0F6hnP3370XadLAB/8j6XYveVd8E+XNK7iEVIXq3QzoxscDkre1BWGP0t
         bK37vDIZyNOlPpLfdUrkPhHR8SbuIH7lxxKkZMzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 172/177] Revert "xsk: Do not sleep in poll() when need_wakeup set"
Date:   Mon, 20 Dec 2021 15:35:22 +0100
Message-Id: <20211220143045.857712350@linuxfoundation.org>
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
@@ -692,6 +692,8 @@ static __poll_t xsk_poll(struct file *fi
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xsk_buff_pool *pool;
 
+	sock_poll_wait(file, sock, wait);
+
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
@@ -703,8 +705,6 @@ static __poll_t xsk_poll(struct file *fi
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
-	} else {
-		sock_poll_wait(file, sock, wait);
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))


