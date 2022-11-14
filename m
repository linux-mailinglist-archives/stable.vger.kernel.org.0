Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9FC62809C
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbiKNNH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbiKNNHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681772B19E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20028B80EC0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61695C433D7;
        Mon, 14 Nov 2022 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431237;
        bh=2wjpGQVKKOxrr3sUS4nXXtwqeXGJDnYBenpxkqmsfhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPXw3wPSAH8upzUQxyAWVfDZwgHIdz9Q8AqJW+JxhomZlnqcrE7a8FqJQ5jtt+9yG
         X66KucoGo/DChYv9oe+ldEY4lSoSr3XkeZAB/bfJ4+AXsFNAEPv0k9+q+wpWDnPLir
         hGUANmIhnZeSUzhttjlDszVEVgYxUMNFm1GF/PFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roger Quadros <rogerq@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Stable@vger.kernel.org
Subject: [PATCH 6.0 152/190] net: ethernet: ti: am65-cpsw: Fix segmentation fault at module unload
Date:   Mon, 14 Nov 2022 13:46:16 +0100
Message-Id: <20221114124505.467482493@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@kernel.org>

commit 1a0c016a4831ea29be09bbc8162d4a2a0690b4b8 upstream.

Move am65_cpsw_nuss_phylink_cleanup() call to after
am65_cpsw_nuss_cleanup_ndev() so phylink is still valid
to prevent the below Segmentation fault on module remove when
first slave link is up.

[   31.652944] Unable to handle kernel paging request at virtual address 00040008000005f4
[   31.684627] Mem abort info:
[   31.687446]   ESR = 0x0000000096000004
[   31.704614]   EC = 0x25: DABT (current EL), IL = 32 bits
[   31.720663]   SET = 0, FnV = 0
[   31.723729]   EA = 0, S1PTW = 0
[   31.740617]   FSC = 0x04: level 0 translation fault
[   31.756624] Data abort info:
[   31.759508]   ISV = 0, ISS = 0x00000004
[   31.776705]   CM = 0, WnR = 0
[   31.779695] [00040008000005f4] address between user and kernel address ranges
[   31.808644] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[   31.814928] Modules linked in: wlcore_sdio wl18xx wlcore mac80211 libarc4 cfg80211 rfkill crct10dif_ce phy_gmii_sel ti_am65_cpsw_nuss(-) sch_fq_codel ipv6
[   31.828776] CPU: 0 PID: 1026 Comm: modprobe Not tainted 6.1.0-rc2-00012-gfabfcf7dafdb-dirty #160
[   31.837547] Hardware name: Texas Instruments AM625 (DT)
[   31.842760] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   31.849709] pc : phy_stop+0x18/0xf8
[   31.853202] lr : phylink_stop+0x38/0xf8
[   31.857031] sp : ffff80000a0839f0
[   31.860335] x29: ffff80000a0839f0 x28: ffff000000de1c80 x27: 0000000000000000
[   31.867462] x26: 0000000000000000 x25: 0000000000000000 x24: ffff80000a083b98
[   31.874589] x23: 0000000000000800 x22: 0000000000000001 x21: ffff000001bfba90
[   31.881715] x20: ffff0000015ee000 x19: 0004000800000200 x18: 0000000000000000
[   31.888842] x17: ffff800076c45000 x16: ffff800008004000 x15: 000058e39660b106
[   31.895969] x14: 0000000000000144 x13: 0000000000000144 x12: 0000000000000000
[   31.903095] x11: 000000000000275f x10: 00000000000009e0 x9 : ffff80000a0837d0
[   31.910222] x8 : ffff000000de26c0 x7 : ffff00007fbd6540 x6 : ffff00007fbd64c0
[   31.917349] x5 : ffff00007fbd0b10 x4 : ffff00007fbd0b10 x3 : ffff00007fbd3920
[   31.924476] x2 : d0a07fcff8b8d500 x1 : 0000000000000000 x0 : 0004000800000200
[   31.931603] Call trace:
[   31.934042]  phy_stop+0x18/0xf8
[   31.937177]  phylink_stop+0x38/0xf8
[   31.940657]  am65_cpsw_nuss_ndo_slave_stop+0x28/0x1e0 [ti_am65_cpsw_nuss]
[   31.947452]  __dev_close_many+0xa4/0x140
[   31.951371]  dev_close_many+0x84/0x128
[   31.955115]  unregister_netdevice_many+0x130/0x6d0
[   31.959897]  unregister_netdevice_queue+0x94/0xd8
[   31.964591]  unregister_netdev+0x24/0x38
[   31.968504]  am65_cpsw_nuss_cleanup_ndev.isra.0+0x48/0x70 [ti_am65_cpsw_nuss]
[   31.975637]  am65_cpsw_nuss_remove+0x58/0xf8 [ti_am65_cpsw_nuss]

Cc: <Stable@vger.kernel.org> # v5.18+
Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2791,7 +2791,6 @@ static int am65_cpsw_nuss_remove(struct
 	if (ret < 0)
 		return ret;
 
-	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpsw_unregister_devlink(common);
 	am65_cpsw_unregister_notifiers(common);
 
@@ -2799,6 +2798,7 @@ static int am65_cpsw_nuss_remove(struct
 	 * dma_deconfigure(dev) before devres_release_all(dev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
+	am65_cpsw_nuss_phylink_cleanup(common);
 
 	of_platform_device_destroy(common->mdio_dev, NULL);
 


