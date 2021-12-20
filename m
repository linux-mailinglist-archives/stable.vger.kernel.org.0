Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE98E47AD87
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbhLTOwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:52:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42192 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbhLTOun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA059611C4;
        Mon, 20 Dec 2021 14:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92743C36AF7;
        Mon, 20 Dec 2021 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011842;
        bh=Om3VCe39iMGhWLeHaypEQk6uXFLDdEp/52R0FAZjtYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XrQ3/ec/vzNoFTXSHQod7eDhdQ2VtdPh267N8t5P3Srtw3aiQsPXb8CrEJZNXx1V
         U+Co547UF44470+mJisj2jmJsZs8i6uL8oDFWBdIMvgLV1in6/Fy2F74R/32OAao08
         /GXrlzdz0wm1o5uB1PXgOkLQRsbijx1VRQOovrIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 94/99] Revert "xsk: Do not sleep in poll() when need_wakeup set"
Date:   Mon, 20 Dec 2021 15:35:07 +0100
Message-Id: <20211220143032.559788561@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
@@ -499,6 +499,8 @@ static __poll_t xsk_poll(struct file *fi
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xsk_buff_pool *pool;
 
+	sock_poll_wait(file, sock, wait);
+
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
@@ -510,8 +512,6 @@ static __poll_t xsk_poll(struct file *fi
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
-	} else {
-		sock_poll_wait(file, sock, wait);
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))


