Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6908A4B42C5
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 08:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbiBNHYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 02:24:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiBNHYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 02:24:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DA4593A2
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 23:24:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0786261298
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 07:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5662C340EB;
        Mon, 14 Feb 2022 07:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644823452;
        bh=Fdhw5ZI/TuN65Vb558ADMZLS2X8cgxsvid8woJmNVaU=;
        h=Subject:To:Cc:From:Date:From;
        b=1g4xsfkpte9qkl9fi8SCvMba3e1rJG3GUQBTalHtrEENzp2JwdD6bk7d0tvnGe3D5
         wsZ6mDMo1U1JmmskoJmF4G6zTzLQngPa1H3n7QiapSho5Y8gkpok/0OGKLtZbV3eZe
         dlPHax0q1Hm9vqQlOMzMnpoBkeLLUaCS8K6z7g00=
Subject: FAILED: patch "[PATCH] vlan: move dev_put into vlan_dev_uninit" failed to apply to 5.4-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net, shuali@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 08:24:09 +0100
Message-ID: <164482344917747@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d6ff94afd90b0ce8d1715f8ef77d4347d7a7f2c0 Mon Sep 17 00:00:00 2001
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 9 Feb 2022 03:19:56 -0500
Subject: [PATCH] vlan: move dev_put into vlan_dev_uninit

Shuang Li reported an QinQ issue by simply doing:

  # ip link add dummy0 type dummy
  # ip link add link dummy0 name dummy0.1 type vlan id 1
  # ip link add link dummy0.1 name dummy0.1.2 type vlan id 2
  # rmmod 8021q

 unregister_netdevice: waiting for dummy0.1 to become free. Usage count = 1

When rmmods 8021q, all vlan devs are deleted from their real_dev's vlan grp
and added into list_kill by unregister_vlan_dev(). dummy0.1 is unregistered
before dummy0.1.2, as it's using for_each_netdev() in __rtnl_kill_links().

When unregisters dummy0.1, dummy0.1.2 is not unregistered in the event of
NETDEV_UNREGISTER, as it's been deleted from dummy0.1's vlan grp. However,
due to dummy0.1.2 still holding dummy0.1, dummy0.1 will keep waiting in
netdev_wait_allrefs(), while dummy0.1.2 will never get unregistered and
release dummy0.1, as it delays dev_put until calling dev->priv_destructor,
vlan_dev_free().

This issue was introduced by Commit 563bcbae3ba2 ("net: vlan: fix a UAF in
vlan_dev_real_dev()"), and this patch is to fix it by moving dev_put() into
vlan_dev_uninit(), which is called after NETDEV_UNREGISTER event but before
netdev_wait_allrefs().

Fixes: 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e5d23e75572a..d1902828a18a 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -638,7 +638,12 @@ void vlan_dev_free_egress_priority(const struct net_device *dev)
 
 static void vlan_dev_uninit(struct net_device *dev)
 {
+	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+
 	vlan_dev_free_egress_priority(dev);
+
+	/* Get rid of the vlan's reference to real_dev */
+	dev_put_track(vlan->real_dev, &vlan->dev_tracker);
 }
 
 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
@@ -851,9 +856,6 @@ static void vlan_dev_free(struct net_device *dev)
 
 	free_percpu(vlan->vlan_pcpu_stats);
 	vlan->vlan_pcpu_stats = NULL;
-
-	/* Get rid of the vlan's reference to real_dev */
-	dev_put_track(vlan->real_dev, &vlan->dev_tracker);
 }
 
 void vlan_setup(struct net_device *dev)

