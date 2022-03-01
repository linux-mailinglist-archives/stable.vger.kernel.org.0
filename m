Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E12C4C97DC
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 22:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiCAVn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 16:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiCAVnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 16:43:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDF214096
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 13:42:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4CBD612B7
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 21:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07E7C340EE;
        Tue,  1 Mar 2022 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646170963;
        bh=pnfjf3nYp1iN4Ft51p9x5DkuodmJo9kvJlwxsr4Cl/g=;
        h=Subject:To:From:Date:From;
        b=MoxZfSXh8hWw1u1RHQDOrqQkzVdp92tXVkkWjAN2irK/vSy2uHNyFSvNEmV0ENzvN
         fxYNQmQZ3gEjh+Db/mLDkdQ855iluvqCc5pz1H7cc0sYJGmzoIIMqllAx3jZzmmMke
         upcl6AbV4kljAHdaXC/byU3pTuaqZpnFSwz56ASI=
Subject: patch "staging: gdm724x: fix use after free in gdm_lte_rx()" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        lkp@intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 01 Mar 2022 22:42:40 +0100
Message-ID: <164617096019938@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: gdm724x: fix use after free in gdm_lte_rx()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fc7f750dc9d102c1ed7bbe4591f991e770c99033 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 28 Feb 2022 10:43:31 +0300
Subject: staging: gdm724x: fix use after free in gdm_lte_rx()

The netif_rx_ni() function frees the skb so we can't dereference it to
save the skb->len.

Fixes: 61e121047645 ("staging: gdm7240: adding LTE USB driver")
Cc: stable <stable@vger.kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220228074331.GA13685@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gdm724x/gdm_lte.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index 493ed4821515..0d8d8fed283d 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -76,14 +76,15 @@ static void tx_complete(void *arg)
 
 static int gdm_lte_rx(struct sk_buff *skb, struct nic *nic, int nic_type)
 {
-	int ret;
+	int ret, len;
 
+	len = skb->len + ETH_HLEN;
 	ret = netif_rx_ni(skb);
 	if (ret == NET_RX_DROP) {
 		nic->stats.rx_dropped++;
 	} else {
 		nic->stats.rx_packets++;
-		nic->stats.rx_bytes += skb->len + ETH_HLEN;
+		nic->stats.rx_bytes += len;
 	}
 
 	return 0;
-- 
2.35.1


