Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B505425CB
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382751AbiFHBPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837548AbiFHAAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:00:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B5827CCCE;
        Tue,  7 Jun 2022 12:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4A84609D0;
        Tue,  7 Jun 2022 19:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B513BC385A5;
        Tue,  7 Jun 2022 19:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629960;
        bh=+cCPHyDiE6bNC1DR+IBdCXwECQlqi81MVWn1zojPDGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08b5ShS7wl4naBnwHKIFQJwgwZ2g9j5YdYoeOH4m/ApgApT0CJKdJcHcsfTgJ/JR+
         DCUX56wHsWeIv3HyN4nV+m2OmJ020jThBa2jqqsCzxWra+gXJOO2gKBU743ns4hl+G
         FqEvgCdb5S5UTdO6ozzxbGb+B8RCcoNlDKc1eoTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d0e94b65ac259c29ce7a@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.18 878/879] macsec: fix UAF bug for real_dev
Date:   Tue,  7 Jun 2022 19:06:36 +0200
Message-Id: <20220607165028.341154150@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 196a888ca6571deb344468e1d7138e3273206335 upstream.

Create a new macsec device but not get reference to real_dev. That can
not ensure that real_dev is freed after macsec. That will trigger the
UAF bug for real_dev as following:

==================================================================
BUG: KASAN: use-after-free in macsec_get_iflink+0x5f/0x70 drivers/net/macsec.c:3662
Call Trace:
 ...
 macsec_get_iflink+0x5f/0x70 drivers/net/macsec.c:3662
 dev_get_iflink+0x73/0xe0 net/core/dev.c:637
 default_operstate net/core/link_watch.c:42 [inline]
 rfc2863_policy+0x233/0x2d0 net/core/link_watch.c:54
 linkwatch_do_dev+0x2a/0x150 net/core/link_watch.c:161

Allocated by task 22209:
 ...
 alloc_netdev_mqs+0x98/0x1100 net/core/dev.c:10549
 rtnl_create_link+0x9d7/0xc00 net/core/rtnetlink.c:3235
 veth_newlink+0x20e/0xa90 drivers/net/veth.c:1748

Freed by task 8:
 ...
 kfree+0xd6/0x4d0 mm/slub.c:4552
 kvfree+0x42/0x50 mm/util.c:615
 device_release+0x9f/0x240 drivers/base/core.c:2229
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 netdev_run_todo+0x72e/0x10b0 net/core/dev.c:10327

After commit faab39f63c1f ("net: allow out-of-order netdev unregistration")
and commit e5f80fcf869a ("ipv6: give an IPv6 dev to blackhole_netdev"), we
can add dev_hold_track() in macsec_dev_init() and dev_put_track() in
macsec_free_netdev() to fix the problem.

Fixes: 2bce1ebed17d ("macsec: fix refcnt leak in module exit routine")
Reported-by: syzbot+d0e94b65ac259c29ce7a@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/r/20220531074500.1272846-1-william.xuanziyang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -99,6 +99,7 @@ struct pcpu_secy_stats {
  * struct macsec_dev - private data
  * @secy: SecY config
  * @real_dev: pointer to underlying netdevice
+ * @dev_tracker: refcount tracker for @real_dev reference
  * @stats: MACsec device stats
  * @secys: linked list of SecY's on the underlying device
  * @gro_cells: pointer to the Generic Receive Offload cell
@@ -107,6 +108,7 @@ struct pcpu_secy_stats {
 struct macsec_dev {
 	struct macsec_secy secy;
 	struct net_device *real_dev;
+	netdevice_tracker dev_tracker;
 	struct pcpu_secy_stats __percpu *stats;
 	struct list_head secys;
 	struct gro_cells gro_cells;
@@ -3459,6 +3461,9 @@ static int macsec_dev_init(struct net_de
 	if (is_zero_ether_addr(dev->broadcast))
 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
 
+	/* Get macsec's reference to real_dev */
+	dev_hold_track(real_dev, &macsec->dev_tracker, GFP_KERNEL);
+
 	return 0;
 }
 
@@ -3704,6 +3709,8 @@ static void macsec_free_netdev(struct ne
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
+	/* Get rid of the macsec's reference to real_dev */
+	dev_put_track(macsec->real_dev, &macsec->dev_tracker);
 }
 
 static void macsec_setup(struct net_device *dev)


