Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECB847AF4C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbhLTPKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbhLTPJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B144C08E883;
        Mon, 20 Dec 2021 06:55:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 093B9611B9;
        Mon, 20 Dec 2021 14:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25B3C36AE9;
        Mon, 20 Dec 2021 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012145;
        bh=VKXco1J1X7VoH9JI1VCXUGlX9NAOZbrtBkCZfZpo2CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lphrxPwmiRx4y7rLc0ToGP9WcrAN3cAGdOkop3kWZKGZAGn4jDsn7ZQzsIsjQM12S
         qAr1mfvzadcSOBlXvtrjWEKuLNIkz4HkXJ+qIhvWdiq5IgOGzYXM+FO1EH/Btqs06y
         y7HOKWgYQyqzvEqCDKOSChyI2HgrOxF6sgUC+sxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Letu Ren <fantasquex@gmail.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/177] igbvf: fix double free in `igbvf_probe`
Date:   Mon, 20 Dec 2021 15:34:05 +0100
Message-Id: <20211220143043.299769210@linuxfoundation.org>
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

From: Letu Ren <fantasquex@gmail.com>

[ Upstream commit b6d335a60dc624c0d279333b22c737faa765b028 ]

In `igbvf_probe`, if register_netdev() fails, the program will go to
label err_hw_init, and then to label err_ioremap. In free_netdev() which
is just below label err_ioremap, there is `list_for_each_entry_safe` and
`netif_napi_del` which aims to delete all entries in `dev->napi_list`.
The program has added an entry `adapter->rx_ring->napi` which is added by
`netif_napi_add` in igbvf_alloc_queues(). However, adapter->rx_ring has
been freed below label err_hw_init. So this a UAF.

In terms of how to patch the problem, we can refer to igbvf_remove() and
delete the entry before `adapter->rx_ring`.

The KASAN logs are as follows:

[   35.126075] BUG: KASAN: use-after-free in free_netdev+0x1fd/0x450
[   35.127170] Read of size 8 at addr ffff88810126d990 by task modprobe/366
[   35.128360]
[   35.128643] CPU: 1 PID: 366 Comm: modprobe Not tainted 5.15.0-rc2+ #14
[   35.129789] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[   35.131749] Call Trace:
[   35.132199]  dump_stack_lvl+0x59/0x7b
[   35.132865]  print_address_description+0x7c/0x3b0
[   35.133707]  ? free_netdev+0x1fd/0x450
[   35.134378]  __kasan_report+0x160/0x1c0
[   35.135063]  ? free_netdev+0x1fd/0x450
[   35.135738]  kasan_report+0x4b/0x70
[   35.136367]  free_netdev+0x1fd/0x450
[   35.137006]  igbvf_probe+0x121d/0x1a10 [igbvf]
[   35.137808]  ? igbvf_vlan_rx_add_vid+0x100/0x100 [igbvf]
[   35.138751]  local_pci_probe+0x13c/0x1f0
[   35.139461]  pci_device_probe+0x37e/0x6c0
[   35.165526]
[   35.165806] Allocated by task 366:
[   35.166414]  ____kasan_kmalloc+0xc4/0xf0
[   35.167117]  foo_kmem_cache_alloc_trace+0x3c/0x50 [igbvf]
[   35.168078]  igbvf_probe+0x9c5/0x1a10 [igbvf]
[   35.168866]  local_pci_probe+0x13c/0x1f0
[   35.169565]  pci_device_probe+0x37e/0x6c0
[   35.179713]
[   35.179993] Freed by task 366:
[   35.180539]  kasan_set_track+0x4c/0x80
[   35.181211]  kasan_set_free_info+0x1f/0x40
[   35.181942]  ____kasan_slab_free+0x103/0x140
[   35.182703]  kfree+0xe3/0x250
[   35.183239]  igbvf_probe+0x1173/0x1a10 [igbvf]
[   35.184040]  local_pci_probe+0x13c/0x1f0

Fixes: d4e0fe01a38a0 (igbvf: add new driver to support 82576 virtual functions)
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index d32e72d953c8d..d051918dfdff9 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2861,6 +2861,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_hw_init:
+	netif_napi_del(&adapter->rx_ring->napi);
 	kfree(adapter->tx_ring);
 	kfree(adapter->rx_ring);
 err_sw_init:
-- 
2.33.0



