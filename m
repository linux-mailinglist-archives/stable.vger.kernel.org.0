Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DBF3C4DEB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243487AbhGLHPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241506AbhGLHOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A018D613EC;
        Mon, 12 Jul 2021 07:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073888;
        bh=T1wAeuWT7+y5rbqoxQHr4a1GsyCW465NMBfjnELrFLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QH6usELYEMT2xihUO82RjvVQqp9mw+obCQS/aQMBx9CxP6GLKUqq1z2v5YPrx3Bpl
         AnsiZZkFpzsHwV3a7iIEf5TB76rGm8NFo/UWzCBLTMH82kVu3+dNfbPSU+EB3Bj0SI
         NHOl9bL9wIOySrrxTmFeXV4nEI/IBOzLDiZlVGNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 391/700] xfrm: remove the fragment check for ipv6 beet mode
Date:   Mon, 12 Jul 2021 08:07:54 +0200
Message-Id: <20210712061017.979281447@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit eebd49a4ffb420a991c606e54aa3c9f02857a334 ]

In commit 68dc022d04eb ("xfrm: BEET mode doesn't support fragments
for inner packets"), it tried to fix the issue that in TX side the
packet is fragmented before the ESP encapping while in the RX side
the fragments always get reassembled before decapping with ESP.

This is not true for IPv6. IPv6 is different, and it's using exthdr
to save fragment info, as well as the ESP info. Exthdrs are added
in TX and processed in RX both in order. So in the above case, the
ESP decapping will be done earlier than the fragment reassembling
in TX side.

Here just remove the fragment check for the IPv6 inner packets to
recover the fragments support for BEET mode.

Fixes: 68dc022d04eb ("xfrm: BEET mode doesn't support fragments for inner packets")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4cb0ff4dcf4..ac907b9d32d1 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -711,15 +711,8 @@ out:
 static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	unsigned int ptr = 0;
 	int err;
 
-	if (x->outer_mode.encap == XFRM_MODE_BEET &&
-	    ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL, NULL) >= 0) {
-		net_warn_ratelimited("BEET mode doesn't support inner IPv6 fragments\n");
-		return -EAFNOSUPPORT;
-	}
-
 	err = xfrm6_tunnel_check_size(skb);
 	if (err)
 		return err;
-- 
2.30.2



