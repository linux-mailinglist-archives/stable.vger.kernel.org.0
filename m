Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1B1B0BC1
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgDTMnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbgDTMnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:43:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F05920735;
        Mon, 20 Apr 2020 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386585;
        bh=V7Z1Ou20oyFZWx0TQyRWgNXHrlNbaRl4RvOAZbsm3Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukkG9K41EAdOj7Cb2MisYwcEpP7rYnol6/Ti8evZIHZjmInfQ6Mkaiqi6V2DA6fHS
         ksWkvGU9rZBJVgnkqGjXP6+AcaFcK609Pjae7O4BXqXz9KDlofcK1TnhGtA10aKGpU
         hPTP28DwsVUAUqVilFvvZtsnIZ/JqgTSF++vUtbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 07/71] net: macsec: fix using wrong structure in macsec_changelink()
Date:   Mon, 20 Apr 2020 14:38:21 +0200
Message-Id: <20200420121510.107242068@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 022e9d6090599c0593c78e87dc9ba98a290e6bc4 ]

In the macsec_changelink(), "struct macsec_tx_sa tx_sc" is used to
store "macsec_secy.tx_sc".
But, the struct type of tx_sc is macsec_tx_sc, not macsec_tx_sa.
So, the macsec_tx_sc should be used instead.

Test commands:
    ip link add dummy0 type dummy
    ip link add macsec0 link dummy0 type macsec
    ip link set macsec0 type macsec encrypt off

Splat looks like:
[61119.963483][ T9335] ==================================================================
[61119.964709][ T9335] BUG: KASAN: slab-out-of-bounds in macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.965787][ T9335] Read of size 160 at addr ffff888020d69c68 by task ip/9335
[61119.966699][ T9335]
[61119.966979][ T9335] CPU: 0 PID: 9335 Comm: ip Not tainted 5.6.0+ #503
[61119.967791][ T9335] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[61119.968914][ T9335] Call Trace:
[61119.969324][ T9335]  dump_stack+0x96/0xdb
[61119.969809][ T9335]  ? macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.970554][ T9335]  print_address_description.constprop.5+0x1be/0x360
[61119.971294][ T9335]  ? macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.971973][ T9335]  ? macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.972703][ T9335]  __kasan_report+0x12a/0x170
[61119.973323][ T9335]  ? macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.973942][ T9335]  kasan_report+0xe/0x20
[61119.974397][ T9335]  check_memory_region+0x149/0x1a0
[61119.974866][ T9335]  memcpy+0x1f/0x50
[61119.975209][ T9335]  macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.975825][ T9335]  ? macsec_get_stats64+0x3e0/0x3e0 [macsec]
[61119.976451][ T9335]  ? kernel_text_address+0x111/0x120
[61119.976990][ T9335]  ? pskb_expand_head+0x25f/0xe10
[61119.977503][ T9335]  ? stack_trace_save+0x82/0xb0
[61119.977986][ T9335]  ? memset+0x1f/0x40
[61119.978397][ T9335]  ? __nla_validate_parse+0x98/0x1ab0
[61119.978936][ T9335]  ? macsec_alloc_tfm+0x90/0x90 [macsec]
[61119.979511][ T9335]  ? __kasan_slab_free+0x111/0x150
[61119.980021][ T9335]  ? kfree+0xce/0x2f0
[61119.980700][ T9335]  ? netlink_trim+0x196/0x1f0
[61119.981420][ T9335]  ? nla_memcpy+0x90/0x90
[61119.982036][ T9335]  ? register_lock_class+0x19e0/0x19e0
[61119.982776][ T9335]  ? memcpy+0x34/0x50
[61119.983327][ T9335]  __rtnl_newlink+0x922/0x1270
[ ... ]

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3463,7 +3463,7 @@ static int macsec_changelink(struct net_
 			     struct netlink_ext_ack *extack)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-	struct macsec_tx_sa tx_sc;
+	struct macsec_tx_sc tx_sc;
 	struct macsec_secy secy;
 	int ret;
 


