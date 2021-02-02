Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8147830CAAA
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbhBBS4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:56:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233549AbhBBOBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:01:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC8FD64F82;
        Tue,  2 Feb 2021 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273626;
        bh=rIXqksq/htgMwEFnllL30pOvS3D5WauEmuC34++6aAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKeeAtCvbDgTcZAAIwxFqTSe+EFAgbN6h9AjjD4QZ65dgLgqxo68UzE81ndAwAw4B
         pbsAHyIQYKhLtSTZiGCoP+DS6sxodtowQr33yTjZlOCZrq0EC81+dJ3UwAswMuhYxH
         yTH5Ika9vk9bkkttn4HkMy7Osi60D1K1x9GjRyB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/61] xfrm: Fix oops in xfrm_replay_advance_bmp
Date:   Tue,  2 Feb 2021 14:38:11 +0100
Message-Id: <20210202132947.865408426@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shmulik Ladkani <shmulik@metanetworks.com>

[ Upstream commit 56ce7c25ae1525d83cf80a880cf506ead1914250 ]

When setting xfrm replay_window to values higher than 32, a rare
page-fault occurs in xfrm_replay_advance_bmp:

  BUG: unable to handle page fault for address: ffff8af350ad7920
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD ad001067 P4D ad001067 PUD 0
  Oops: 0002 [#1] SMP PTI
  CPU: 3 PID: 30 Comm: ksoftirqd/3 Kdump: loaded Not tainted 5.4.52-050452-generic #202007160732
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
  RIP: 0010:xfrm_replay_advance_bmp+0xbb/0x130
  RSP: 0018:ffffa1304013ba40 EFLAGS: 00010206
  RAX: 000000000000010d RBX: 0000000000000002 RCX: 00000000ffffff4b
  RDX: 0000000000000018 RSI: 00000000004c234c RDI: 00000000ffb3dbff
  RBP: ffffa1304013ba50 R08: ffff8af330ad7920 R09: 0000000007fffffa
  R10: 0000000000000800 R11: 0000000000000010 R12: ffff8af29d6258c0
  R13: ffff8af28b95c700 R14: 0000000000000000 R15: ffff8af29d6258fc
  FS:  0000000000000000(0000) GS:ffff8af339ac0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff8af350ad7920 CR3: 0000000015ee4000 CR4: 00000000001406e0
  Call Trace:
   xfrm_input+0x4e5/0xa10
   xfrm4_rcv_encap+0xb5/0xe0
   xfrm4_udp_encap_rcv+0x140/0x1c0

Analysis revealed offending code is when accessing:

	replay_esn->bmp[nr] |= (1U << bitnr);

with 'nr' being 0x07fffffa.

This happened in an SMP system when reordering of packets was present;
A packet arrived with a "too old" sequence number (outside the window,
i.e 'diff > replay_window'), and therefore the following calculation:

			bitnr = replay_esn->replay_window - (diff - pos);

yields a negative result, but since bitnr is u32 we get a large unsigned
quantity (in crash dump above: 0xffffff4b seen in ecx).

This was supposed to be protected by xfrm_input()'s former call to:

		if (x->repl->check(x, skb, seq)) {

However, the state's spinlock x->lock is *released* after '->check()'
is performed, and gets re-acquired before '->advance()' - which gives a
chance for a different core to update the xfrm state, e.g. by advancing
'replay_esn->seq' when it encounters more packets - leading to a
'diff > replay_window' situation when original core continues to
xfrm_replay_advance_bmp().

An attempt to fix this issue was suggested in commit bcf66bf54aab
("xfrm: Perform a replay check after return from async codepaths"),
by calling 'x->repl->recheck()' after lock is re-acquired, but fix
applied only to asyncronous crypto algorithms.

Augment the fix, by *always* calling 'recheck()' - irrespective if we're
using async crypto.

Fixes: 0ebea8ef3559 ("[IPSEC]: Move state lock into x->type->input")
Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 7a84745477919..e120df0a6da13 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -656,7 +656,7 @@ resume:
 		/* only the first xfrm gets the encap type */
 		encap_type = 0;
 
-		if (async && x->repl->recheck(x, skb, seq)) {
+		if (x->repl->recheck(x, skb, seq)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
 			goto drop_unlock;
 		}
-- 
2.27.0



