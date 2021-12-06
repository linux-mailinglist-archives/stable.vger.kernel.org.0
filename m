Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD0B469D2C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357528AbhLFP2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359218AbhLFPYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56A7C08EAE4;
        Mon,  6 Dec 2021 07:15:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A84BB8111D;
        Mon,  6 Dec 2021 15:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67549C341C2;
        Mon,  6 Dec 2021 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803723;
        bh=3mlHMoeJRKot5WnElRIA0pcb5XRwioQUnSQVasggHMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTUhIfAoUox6lRw1+dk+bRdhptIm766WaB9JdOUaTx8gLHJcLez3zAVQQmjeTS1e8
         wOcOEPLBujoCHQUd6MuK0JW4wl48ZVW/Vq4cD2zYGscNCFMXTj6nEMBuMyLxlFKsUM
         6p2bA8jQw62/728WjI5aLHrQX+Znx/LS9BtQf/ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordy Zomer <jordy@pwning.systems>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/130] ipv6: check return value of ipv6_skip_exthdr
Date:   Mon,  6 Dec 2021 15:55:40 +0100
Message-Id: <20211206145600.434599458@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordy Zomer <jordy@pwning.systems>

[ Upstream commit 5f9c55c8066bcd93ac25234a02585701fe2e31df ]

The offset value is used in pointer math on skb->data.
Since ipv6_skip_exthdr may return -1 the pointer to uh and th
may not point to the actual udp and tcp headers and potentially
overwrite other stuff. This is why I think this should be checked.

EDIT:  added {}'s, thanks Kees

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/esp6.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 8d001f665fb15..7f2ffc7b1f75a 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -808,6 +808,12 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		struct tcphdr *th;
 
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
+
+		if (offset < 0) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		uh = (void *)(skb->data + offset);
 		th = (void *)(skb->data + offset);
 		hdr_len += offset;
-- 
2.33.0



