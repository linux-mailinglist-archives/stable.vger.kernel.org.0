Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5AD615842
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiKBCsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiKBCsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:48:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665EB2183C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FF32B81FF9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4C8C433D6;
        Wed,  2 Nov 2022 02:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357288;
        bh=Zvks/8pnIdeqOngehfCjSfDOnZRkU7yjf+UnTlKXjRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsIVobyv5FR4ClqNghGtNGJ/UvnuMF8XL3pcmfP3UnQapETKVk6uaIdgwV4QWzTtM
         upYBAaQTw6IADThYOZPa55RYCYBZVvNJ/neq92ZJg+RkSOWYZ4HD/WJNE+9rtkNQoI
         heuPwyjbywd4RRkzqaCAQPIlE+SqJaBYMHANHpiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Han Xu <han.xu@nxp.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 144/240] mtd: core: add missing of_node_get() in dynamic partitions code
Date:   Wed,  2 Nov 2022 03:31:59 +0100
Message-Id: <20221102022114.633127298@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 12b58961de0bd88b3c7dfa5d21f6d67f4678b780 ]

This fixes unbalanced of_node_put():
[    1.078910] 6 cmdlinepart partitions found on MTD device gpmi-nand
[    1.085116] Creating 6 MTD partitions on "gpmi-nand":
[    1.090181] 0x000000000000-0x000008000000 : "nandboot"
[    1.096952] 0x000008000000-0x000009000000 : "nandfit"
[    1.103547] 0x000009000000-0x00000b000000 : "nandkernel"
[    1.110317] 0x00000b000000-0x00000c000000 : "nanddtb"
[    1.115525] ------------[ cut here ]------------
[    1.120141] refcount_t: addition on 0; use-after-free.
[    1.125328] WARNING: CPU: 0 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0xdc/0x148
[    1.133528] Modules linked in:
[    1.136589] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc7-next-20220930-04543-g8cf3f7
[    1.146342] Hardware name: Freescale i.MX8DXL DDR3L EVK (DT)
[    1.151999] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    1.158965] pc : refcount_warn_saturate+0xdc/0x148
[    1.163760] lr : refcount_warn_saturate+0xdc/0x148
[    1.168556] sp : ffff800009ddb080
[    1.171866] x29: ffff800009ddb080 x28: ffff800009ddb35a x27: 0000000000000002
[    1.179015] x26: ffff8000098b06ad x25: ffffffffffffffff x24: ffff0a00ffffff05
[    1.186165] x23: ffff00001fdf6470 x22: ffff800009ddb367 x21: 0000000000000000
[    1.193314] x20: ffff00001fdfebe8 x19: ffff00001fdfec50 x18: ffffffffffffffff
[    1.200464] x17: 0000000000000000 x16: 0000000000000118 x15: 0000000000000004
[    1.207614] x14: 0000000000000fff x13: ffff800009bca248 x12: 0000000000000003
[    1.214764] x11: 00000000ffffefff x10: c0000000ffffefff x9 : 4762cb2ccb52de00
[    1.221914] x8 : 4762cb2ccb52de00 x7 : 205d313431303231 x6 : 312e31202020205b
[    1.229063] x5 : ffff800009d55c1f x4 : 0000000000000001 x3 : 0000000000000000
[    1.236213] x2 : 0000000000000000 x1 : ffff800009954be6 x0 : 000000000000002a
[    1.243365] Call trace:
[    1.245806]  refcount_warn_saturate+0xdc/0x148
[    1.250253]  kobject_get+0x98/0x9c
[    1.253658]  of_node_get+0x20/0x34
[    1.257072]  of_fwnode_get+0x3c/0x54
[    1.260652]  fwnode_get_nth_parent+0xd8/0xf4
[    1.264926]  fwnode_full_name_string+0x3c/0xb4
[    1.269373]  device_node_string+0x498/0x5b4
[    1.273561]  pointer+0x41c/0x5d0
[    1.276793]  vsnprintf+0x4d8/0x694
[    1.280198]  vprintk_store+0x164/0x528
[    1.283951]  vprintk_emit+0x98/0x164
[    1.287530]  vprintk_default+0x44/0x6c
[    1.291284]  vprintk+0xf0/0x134
[    1.294428]  _printk+0x54/0x7c
[    1.297486]  of_node_release+0xe8/0x128
[    1.301326]  kobject_put+0x98/0xfc
[    1.304732]  of_node_put+0x1c/0x28
[    1.308137]  add_mtd_device+0x484/0x6d4
[    1.311977]  add_mtd_partitions+0xf0/0x1d0
[    1.316078]  parse_mtd_partitions+0x45c/0x518
[    1.320439]  mtd_device_parse_register+0xb0/0x274
[    1.325147]  gpmi_nand_probe+0x51c/0x650
[    1.329074]  platform_probe+0xa8/0xd0
[    1.332740]  really_probe+0x130/0x334
[    1.336406]  __driver_probe_device+0xb4/0xe0
[    1.340681]  driver_probe_device+0x3c/0x1f8
[    1.344869]  __driver_attach+0xdc/0x1a4
[    1.348708]  bus_for_each_dev+0x80/0xcc
[    1.352548]  driver_attach+0x24/0x30
[    1.356127]  bus_add_driver+0x108/0x1f4
[    1.359967]  driver_register+0x78/0x114
[    1.363807]  __platform_driver_register+0x24/0x30
[    1.368515]  gpmi_nand_driver_init+0x1c/0x28
[    1.372798]  do_one_initcall+0xbc/0x238
[    1.376638]  do_initcall_level+0x94/0xb4
[    1.380565]  do_initcalls+0x54/0x94
[    1.384058]  do_basic_setup+0x1c/0x28
[    1.387724]  kernel_init_freeable+0x110/0x188
[    1.392084]  kernel_init+0x20/0x1a0
[    1.395578]  ret_from_fork+0x10/0x20
[    1.399157] ---[ end trace 0000000000000000 ]---
[    1.403782] ------------[ cut here ]------------

Reported-by: Han Xu <han.xu@nxp.com>
Fixes: ad9b10d1eaada169 ("mtd: core: introduce of support for dynamic partitions")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Tested-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221018051822.28685-1-zajec5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index a9b8be9f40dc..477707bcad97 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -562,7 +562,7 @@ static void mtd_check_of_node(struct mtd_info *mtd)
 	if (!mtd_is_partition(mtd))
 		return;
 	parent = mtd->parent;
-	parent_dn = dev_of_node(&parent->dev);
+	parent_dn = of_node_get(dev_of_node(&parent->dev));
 	if (!parent_dn)
 		return;
 
-- 
2.35.1



