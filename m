Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7137445BE7F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbhKXMrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:47:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344789AbhKXMpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:45:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 699336142A;
        Wed, 24 Nov 2021 12:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756806;
        bh=zVC7uIJA1A2M9ngdkg+5hMkX9mJwdNK37ujEA8LwYMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zpy81sPlmgzLsMBmI9mgJaUvuovMZm4pLSpswI1+wrDaWqni56S5xcpmEZQUWPqR9
         +Q+MFMKLm4VvCEXLdIDZQHTxKzXRSR+9f9nObyXWj1O8VNYo/EmVpZdwPidxxNgQw8
         cyJAPnLeHDYPrSWntSHsnh+lQIk0Rq+hxjUNQx38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 181/251] net: vlan: fix a UAF in vlan_dev_real_dev()
Date:   Wed, 24 Nov 2021 12:57:03 +0100
Message-Id: <20211124115716.547727004@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 563bcbae3ba233c275c244bfce2efe12938f5363 ]

The real_dev of a vlan net_device may be freed after
unregister_vlan_dev(). Access the real_dev continually by
vlan_dev_real_dev() will trigger the UAF problem for the
real_dev like following:

==================================================================
BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120
Call Trace:
 kasan_report.cold+0x83/0xdf
 vlan_dev_real_dev+0xf9/0x120
 is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0
 is_eth_port_of_netdev_filter+0x28/0x40
 ib_enum_roce_netdev+0x1a3/0x300
 ib_enum_all_roce_netdevs+0xc7/0x140
 netdevice_event_work_handler+0x9d/0x210
...

Freed by task 9288:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0xfc/0x130
 slab_free_freelist_hook+0xdd/0x240
 kfree+0xe4/0x690
 kvfree+0x42/0x50
 device_release+0x9f/0x240
 kobject_put+0x1c8/0x530
 put_device+0x1b/0x30
 free_netdev+0x370/0x540
 ppp_destroy_interface+0x313/0x3d0
...

Move the put_device(real_dev) to vlan_dev_free(). Ensure
real_dev not be freed before vlan_dev unregistered.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c     | 3 ---
 net/8021q/vlan_dev.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 0efdf83f78e7a..a8cee80e07a70 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -112,9 +112,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 	}
 
 	vlan_vid_del(real_dev, vlan->vlan_proto, vlan_id);
-
-	/* Get rid of the vlan's reference to real_dev */
-	dev_put(real_dev);
 }
 
 int vlan_check_real_dev(struct net_device *real_dev,
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ed3717dc2d201..d28c22e59996c 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -814,6 +814,9 @@ static void vlan_dev_free(struct net_device *dev)
 
 	free_percpu(vlan->vlan_pcpu_stats);
 	vlan->vlan_pcpu_stats = NULL;
+
+	/* Get rid of the vlan's reference to real_dev */
+	dev_put(vlan->real_dev);
 }
 
 void vlan_setup(struct net_device *dev)
-- 
2.33.0



