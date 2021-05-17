Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5E3382F14
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbhEQONB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238605AbhEQOLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88789613C5;
        Mon, 17 May 2021 14:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260463;
        bh=lcZIRNgJsFuH/pUy5vo/SVQpCr855oGUmw48fpCQeQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTDh1kOz+DG3ml4aaPQ7v22uBv63vuF/4GMCIP/0adgAor/NXvgyTEtNWYyK+CyeR
         RCZ/vuM1S8pULCnoxLxVHb9EtjasRJCRknAKx6sVHcC2YaRX2p5NXsGKWltpOB+etf
         y6C3Ldg6avIC8xN7SBEX5Um+RkIfAbZijTN8BUpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 092/363] flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()
Date:   Mon, 17 May 2021 15:59:18 +0200
Message-Id: <20210517140305.703871300@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 1e3d976dbb23b3fce544752b434bdc32ce64aabc ]

Fix the following out-of-bounds warning:

net/core/flow_dissector.c:835:3: warning: 'memcpy' offset [33, 48] from the object at 'flow_keys' is out of the bounds of referenced subobject 'ipv6_src' with type '__u32[4]' {aka 'unsigned int[4]'} at offset 16 [-Warray-bounds]

The problem is that the original code is trying to copy data into a
couple of struct members adjacent to each other in a single call to
memcpy().  So, the compiler legitimately complains about it. As these
are just a couple of members, fix this by copying each one of them in
separate calls to memcpy().

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index a96a4f5de0ce..3f36b04d86a0 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -828,8 +828,10 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 		key_addrs = skb_flow_dissector_target(flow_dissector,
 						      FLOW_DISSECTOR_KEY_IPV6_ADDRS,
 						      target_container);
-		memcpy(&key_addrs->v6addrs, &flow_keys->ipv6_src,
-		       sizeof(key_addrs->v6addrs));
+		memcpy(&key_addrs->v6addrs.src, &flow_keys->ipv6_src,
+		       sizeof(key_addrs->v6addrs.src));
+		memcpy(&key_addrs->v6addrs.dst, &flow_keys->ipv6_dst,
+		       sizeof(key_addrs->v6addrs.dst));
 		key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 	}
 
-- 
2.30.2



