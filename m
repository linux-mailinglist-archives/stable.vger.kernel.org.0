Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4543DD7AD
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhHBNrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234269AbhHBNrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2B5160FF2;
        Mon,  2 Aug 2021 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912015;
        bh=+TbxYEZT3IXSthwpO6A8R0xgy2cihLk8uOxAnY25psc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYoU0JpApyk4xFx8ctDvZnRv8QBTDsbSCOhG74wdGUQwuysH1trCxvM7hjZFk8Hhx
         N8z9yBaB/dz96lPl/kUVXhDW93kul3AJnw0z0a3lkItpRIX+HSfmoQs1URNOjrMbrO
         6KnQfW8cs5voju4H2YCIOxKa244HfHWsIQmOXfzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.9 02/32] tipc: Fix backport of b77413446408fdd256599daf00d5be72b5f3e7c6
Date:   Mon,  2 Aug 2021 15:44:22 +0200
Message-Id: <20210802134333.008488234@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

Clang warns:

net/tipc/link.c:896:23: warning: variable 'hdr' is uninitialized when
used here [-Wuninitialized]
        imp = msg_importance(hdr);
                             ^~~
net/tipc/link.c:890:22: note: initialize the variable 'hdr' to silence
this warning
        struct tipc_msg *hdr;
                            ^
                             = NULL
1 warning generated.

The backport of commit b77413446408 ("tipc: fix NULL deref in
tipc_link_xmit()") to 4.9 as commit 310014f572a5 ("tipc: fix NULL deref
in tipc_link_xmit()") added the hdr initialization above the

    if (unlikely(msg_size(hdr) > mtu)) {

like in the upstream commit; however, in 4.9, that check is below imp's
first use because commit 365ad353c256 ("tipc: reduce risk of user
starvation during link congestion") is not present. This results in hdr
being used uninitialized.

Fix this by moving hdr's initialization before imp and after the if
check like the original backport did.

Cc: Hoang Le <hoang.h.le@dektech.com.au>
Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Ying Xue <ying.xue@windriver.com>
Fixes: 310014f572a5 ("tipc: fix NULL deref in tipc_link_xmit()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/link.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -893,6 +893,7 @@ int tipc_link_xmit(struct tipc_link *l,
 	if (pkt_cnt <= 0)
 		return 0;
 
+	hdr = buf_msg(skb_peek(list));
 	imp = msg_importance(hdr);
 	/* Match msg importance against this and all higher backlog limits: */
 	if (!skb_queue_empty(backlogq)) {
@@ -902,7 +903,6 @@ int tipc_link_xmit(struct tipc_link *l,
 		}
 	}
 
-	hdr = buf_msg(skb_peek(list));
 	if (unlikely(msg_size(hdr) > mtu)) {
 		skb_queue_purge(list);
 		return -EMSGSIZE;


