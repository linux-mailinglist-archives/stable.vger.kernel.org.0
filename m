Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD10549319
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383877AbiFMO1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383894AbiFMOYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CE64739B;
        Mon, 13 Jun 2022 04:45:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C919613CA;
        Mon, 13 Jun 2022 11:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85096C34114;
        Mon, 13 Jun 2022 11:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120744;
        bh=K5oy88MNnXZLvRi7kD0q2ll6e8fK9uVKVb+SELR6S2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YROmxDVxvYtwdkzNyDHl60DHnSJgH/Pd2/l4NjDCDYktukBbiwis2I/G5DHpJmDQE
         Dh/r8r+rgM/5uEphbxYPE0/NznYmQg7JOraLuZarnymfm6QVyHSJx5W5EYihlep91c
         D3GH5RkpLG3Qt6Z5RD2QNOw2Zg1xCb/CXMC+wOmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d0e94b65ac259c29ce7a@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 118/298] macsec: fix UAF bug for real_dev
Date:   Mon, 13 Jun 2022 12:10:12 +0200
Message-Id: <20220613094928.522805735@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

[ Upstream commit 196a888ca6571deb344468e1d7138e3273206335 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3d0874331763..b901acca098b 100644
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
@@ -3459,6 +3461,9 @@ static int macsec_dev_init(struct net_device *dev)
 	if (is_zero_ether_addr(dev->broadcast))
 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
 
+	/* Get macsec's reference to real_dev */
+	dev_hold_track(real_dev, &macsec->dev_tracker, GFP_KERNEL);
+
 	return 0;
 }
 
@@ -3704,6 +3709,8 @@ static void macsec_free_netdev(struct net_device *dev)
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
+	/* Get rid of the macsec's reference to real_dev */
+	dev_put_track(macsec->real_dev, &macsec->dev_tracker);
 }
 
 static void macsec_setup(struct net_device *dev)
-- 
2.35.1



