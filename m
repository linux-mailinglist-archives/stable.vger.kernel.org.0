Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D041E26642B
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgIKQc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgIKPTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:19:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86BCA2245C;
        Fri, 11 Sep 2020 12:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829186;
        bh=ts5oWeF545x8yVXPV1jgSxK8OLtD4OAu6ZSBpIqSpDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hqBdXfa+hp1FV2RfxAXDI2fM9nu6Jwurpu5pla8WdBpnaW5Dj17cAJBeQBMGUb67
         BBWAnpUIFXwTHVEwGkfm5CcVUM41mHXRcfbRcwhDG0LJULZWsOSdzxHOGGFft0PKgi
         0fjQ+x4PkVAbcQ4hx4hlpRpBy1q6VXDQrTiIgDiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 16/16] mptcp: free acked data before waiting for more memory
Date:   Fri, 11 Sep 2020 14:47:33 +0200
Message-Id: <20200911122500.382563283@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122459.585735377@linuxfoundation.org>
References: <20200911122459.585735377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1cec170d458b1d18f6f1654ca84c0804a701c5ef ]

After subflow lock is dropped, more wmem might have been made available.

This fixes a deadlock in mptcp_connect.sh 'mmap' mode: wmem is exhausted.
But as the mptcp socket holds on to already-acked data (for retransmit)
no wakeup will occur.

Using 'goto restart' calls mptcp_clean_una(sk) which will free pages
that have been acked completely in the mean time.

Fixes: fb529e62d3f3 ("mptcp: break and restart in case mptcp sndbuf is full")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -772,7 +772,6 @@ fallback:
 restart:
 	mptcp_clean_una(sk);
 
-wait_for_sndbuf:
 	__mptcp_flush_join_list(msk);
 	ssk = mptcp_subflow_get_send(msk);
 	while (!sk_stream_memory_free(sk) ||
@@ -873,7 +872,7 @@ wait_for_sndbuf:
 				 */
 				mptcp_set_timeout(sk, ssk);
 				release_sock(ssk);
-				goto wait_for_sndbuf;
+				goto restart;
 			}
 		}
 	}


