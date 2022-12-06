Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2236448EE
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbiLFQN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbiLFQNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:13:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39F83FB9D
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 08:08:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F1C1617C3
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 16:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DED7C433C1;
        Tue,  6 Dec 2022 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670342899;
        bh=XhKvtqIAW3jIvR9xpgI4OUFxuwCF7cUPJlI+b2Q+zuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IcTNwjIbTSp+/9u7bHkv/vwYz8fPGr5bUPg0vOZvltEYBouE7sQgSseZ3T362qWjx
         53CUtF2SGbbpBoev+oN1tqlOFy7fD6TktcC+hnGfdV6BdlbkK5VO4GJbhTjqDmmboq
         khSjnfFjDfC0vis3QjcC1CMr7WY8/8eWKMtF5mi8=
Date:   Tue, 6 Dec 2022 17:08:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     olteanv@gmail.com, stable@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: sja1105: fix new_retagging table size
Message-ID: <Y49o8Zei2aYsy/hr@kroah.com>
References: <20221206135104.734446-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206135104.734446-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 03:51:04PM +0200, Radu Nicolae Pirea (OSS) wrote:
> Allocate more memory for the new_retagging table according to its size.
> 
> Kernel log:
> [  208.509460] sja1105 spi5.0: Probed switch chip: SJA1105Q
> [  208.647821] ==================================================================
> [  208.647854] BUG: KASAN: slab-out-of-bounds in sja1105_build_vlan_table+0x1b8/0x1b14
> [  208.647928] Write of size 8 at addr ffffff88081cf630 by task kworker/2:5/247
> [  208.647955]
> [  208.647972] CPU: 2 PID: 247 Comm: kworker/2:5 Tainted: G           O      5.10.145-rt74 #18
> [  208.648003] Hardware name: NXP S32G2XXX-EVB (DT)
> [  208.648024] Workqueue: events deferred_probe_work_func
> [  208.648080] Call trace:
> [  208.648089]  dump_backtrace+0x0/0x2b4
> [  208.648137]  show_stack+0x18/0x24
> [  208.648178]  dump_stack+0xfc/0x168
> [  208.648224]  print_address_description.constprop.0+0x70/0x468
> [  208.648276]  kasan_report+0x118/0x200
> [  208.648321]  __asan_store8+0x98/0xd0
> [  208.648363]  sja1105_build_vlan_table+0x1b8/0x1b14
> [  208.648405]  sja1105_dsa_8021q_vlan_add+0x60/0x80
> [  208.648446]  dsa_8021q_vid_apply.isra.0+0x11c/0x140
> [  208.648501]  dsa_8021q_setup+0x224/0x610
> [  208.648545]  sja1105_setup+0x398/0x13b4
> [  208.648581]  dsa_register_switch+0xad8/0x1430
> [  208.648620]  sja1105_probe+0x50c/0x744
> [  208.648654]  spi_drv_probe+0xb0/0x110
> [  208.648696]  really_probe+0x150/0x6d4
> [  208.648734]  driver_probe_device+0x78/0xec
> [  208.648773]  __device_attach_driver+0xe8/0x17c
> [  208.648813]  bus_for_each_drv+0xf4/0x15c
> [  208.648847]  __device_attach+0x120/0x26c
> [  208.648883]  device_initial_probe+0x14/0x20
> [  208.648921]  bus_probe_device+0xec/0x100
> [  208.648956]  deferred_probe_work_func+0xe8/0x130
> [  208.648995]  process_one_work+0x3b8/0x650
> [  208.649031]  worker_thread+0xa0/0x72c
> [  208.649062]  kthread+0x23c/0x244
> [  208.649101]  ret_from_fork+0x10/0x38
> [  208.649134]
> [  208.649141] Allocated by task 247:
> [  208.649155]  kasan_save_stack+0x28/0x60
> [  208.649195]  __kasan_kmalloc.constprop.0+0xc8/0xf0
> [  208.649237]  kasan_kmalloc+0x10/0x20
> [  208.649275]  __kmalloc+0xd0/0x180
> [  208.649307]  sja1105_build_vlan_table+0x160/0x1b14
> [  208.649347]  sja1105_dsa_8021q_vlan_add+0x60/0x80
> [  208.649386]  dsa_8021q_vid_apply.isra.0+0x11c/0x140
> [  208.649435]  dsa_8021q_setup+0x224/0x610
> [  208.649479]  sja1105_setup+0x398/0x13b4
> [  208.649513]  dsa_register_switch+0xad8/0x1430
> [  208.649550]  sja1105_probe+0x50c/0x744
> [  208.649583]  spi_drv_probe+0xb0/0x110
> [  208.649619]  really_probe+0x150/0x6d4
> [  208.649654]  driver_probe_device+0x78/0xec
> [  208.649691]  __device_attach_driver+0xe8/0x17c
> [  208.649729]  bus_for_each_drv+0xf4/0x15c
> [  208.649762]  __device_attach+0x120/0x26c
> [  208.649797]  device_initial_probe+0x14/0x20
> [  208.649834]  bus_probe_device+0xec/0x100
> [  208.649868]  deferred_probe_work_func+0xe8/0x130
> [  208.649906]  process_one_work+0x3b8/0x650
> [  208.649938]  worker_thread+0xa0/0x72c
> [  208.649967]  kthread+0x23c/0x244
> [  208.650003]  ret_from_fork+0x10/0x38
> [  208.650034]
> [  208.650041] The buggy address belongs to the object at ffffff88081cf000
> [  208.650041]  which belongs to the cache kmalloc-2k of size 2048
> [  208.650068] The buggy address is located 1584 bytes inside of
> [  208.650068]  2048-byte region [ffffff88081cf000, ffffff88081cf800)
> [  208.650099] The buggy address belongs to the page:
> [  208.650114] page:000000002c3ceac6 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8881cf
> [  208.650145] flags: 0x8000000000000200(slab)
> [  208.650192] raw: 8000000000000200 ffffffff1bfc6518 ffffffff1bfd36a8 ffffff8800000400
> [  208.650221] raw: 0000000000000000 ffffff88081cf000 0000000100000001
> [  208.650237] page dumped because: kasan: bad access detected
> [  208.650250]
> [  208.650257] Memory state around the buggy address:
> [  208.650275]  ffffff88081cf500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [  208.650299]  ffffff88081cf580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [  208.650325] >ffffff88081cf600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [  208.650341]                                      ^
> [  208.650359]  ffffff88081cf680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [  208.650383]  ffffff88081cf700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [  208.650400] ==================================================================
> 
> Signed-off-by: Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Should be applied on top of 5.10.157.
> It is not relevant for newer LTS kernels.

Why not?

Please describe in HUGE detail why that is the case, what commit changed
the tree to prevent this, and why only this one tree needs this specific
change.  We almost never want to take patches that are not in Linus's
tree so the justification to do so is a much much higher level.

And properly get the needed network maintainers ack as well.

thanks,

greg k-h
