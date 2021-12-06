Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85F7469C8A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358563AbhLFPXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53734 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359758AbhLFPUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:20:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 571A3B81118;
        Mon,  6 Dec 2021 15:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8654EC341C2;
        Mon,  6 Dec 2021 15:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803813;
        bh=1MPCTGDcl+t5vgW4Q/TWQGoXeAXt1H6veDu/jdAksPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlbixRUwkUCnIzLrX3YGsc+7zmkl9qLvRXximxubJr/jZL4rjBD+vW5K3KbyGQDtD
         0M5QtVuy9OrHCIU4pJW9GHu5RPHYHb6vBlIcmPenk0Ig/1bgOHmSccRC5wc36XROwh
         UUkuoox4KDEUgydrPDpBWhyy7PQAxVDDEKxp9J+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 055/130] wireguard: selftests: actually test for routing loops
Date:   Mon,  6 Dec 2021 15:56:12 +0100
Message-Id: <20211206145601.585810160@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 782c72af567fc2ef09bd7615d0307f24de72c7e0 upstream.

We previously removed the restriction on looping to self, and then added
a test to make sure the kernel didn't blow up during a routing loop. The
kernel didn't blow up, thankfully, but on certain architectures where
skb fragmentation is easier, such as ppc64, the skbs weren't actually
being discarded after a few rounds through. But the test wasn't catching
this. So actually test explicitly for massive increases in tx to see if
we have a routing loop. Note that the actual loop problem will need to
be addressed in a different commit.

Fixes: b673e24aad36 ("wireguard: socket: remove errant restriction on looping to self")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/wireguard/netns.sh |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -276,7 +276,11 @@ n0 ping -W 1 -c 1 192.168.241.2
 n1 wg set wg0 peer "$pub2" endpoint 192.168.241.2:7
 ip2 link del wg0
 ip2 link del wg1
-! n0 ping -W 1 -c 10 -f 192.168.241.2 || false # Should not crash kernel
+read _ _ tx_bytes_before < <(n0 wg show wg1 transfer)
+! n0 ping -W 1 -c 10 -f 192.168.241.2 || false
+sleep 1
+read _ _ tx_bytes_after < <(n0 wg show wg1 transfer)
+(( tx_bytes_after - tx_bytes_before < 70000 ))
 
 ip0 link del wg1
 ip1 link del wg0


