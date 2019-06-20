Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1697D4D79D
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbfFTSNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbfFTSNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:13:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D48F205F4;
        Thu, 20 Jun 2019 18:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054411;
        bh=0CgCchADOBaHHioHCcaH5lWzVgjsVrqsQTGCDsq1Ajs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvqpdV2+uvzviraZBhVdNNmtgYabxcHwWo92j9EdiyHZ16ZsTsueX77BdRH629Y0Z
         DBC+661fH98cNNlCqcLiHQdtawqDNEspFKILQQp8I6wnp9xek+IfhnLk2awqGmiXZg
         N1Nj8NeyKwGeGt4C8UE4lmwZ7+SLn6bw/QS9b+iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 09/98] net: openvswitch: do not free vport if register_netdevice() is failed.
Date:   Thu, 20 Jun 2019 19:56:36 +0200
Message-Id: <20190620174349.784586254@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 309b66970ee2abf721ecd0876a48940fa0b99a35 ]

In order to create an internal vport, internal_dev_create() is used and
that calls register_netdevice() internally.
If register_netdevice() fails, it calls dev->priv_destructor() to free
private data of netdev. actually, a private data of this is a vport.

Hence internal_dev_create() should not free and use a vport after failure
of register_netdevice().

Test command
    ovs-dpctl add-dp bonding_masters

Splat looks like:
[ 1035.667767] kasan: GPF could be caused by NULL-ptr deref or user memory access
[ 1035.675958] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[ 1035.676916] CPU: 1 PID: 1028 Comm: ovs-vswitchd Tainted: G    B             5.2.0-rc3+ #240
[ 1035.676916] RIP: 0010:internal_dev_create+0x2e5/0x4e0 [openvswitch]
[ 1035.676916] Code: 48 c1 ea 03 80 3c 02 00 0f 85 9f 01 00 00 4c 8b 23 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 60 05 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 86 01 00 00 49 8b bc 24 60 05 00 00 e8 e4 68 f4
[ 1035.713720] RSP: 0018:ffff88810dcb7578 EFLAGS: 00010206
[ 1035.713720] RAX: dffffc0000000000 RBX: ffff88810d13fe08 RCX: ffffffff84297704
[ 1035.713720] RDX: 00000000000000ac RSI: 0000000000000000 RDI: 0000000000000560
[ 1035.713720] RBP: 00000000ffffffef R08: fffffbfff0d3b881 R09: fffffbfff0d3b881
[ 1035.713720] R10: 0000000000000001 R11: fffffbfff0d3b880 R12: 0000000000000000
[ 1035.768776] R13: 0000607ee460b900 R14: ffff88810dcb7690 R15: ffff88810dcb7698
[ 1035.777709] FS:  00007f02095fc980(0000) GS:ffff88811b400000(0000) knlGS:0000000000000000
[ 1035.777709] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1035.777709] CR2: 00007ffdf01d2f28 CR3: 0000000108258000 CR4: 00000000001006e0
[ 1035.777709] Call Trace:
[ 1035.777709]  ovs_vport_add+0x267/0x4f0 [openvswitch]
[ 1035.777709]  new_vport+0x15/0x1e0 [openvswitch]
[ 1035.777709]  ovs_vport_cmd_new+0x567/0xd10 [openvswitch]
[ 1035.777709]  ? ovs_dp_cmd_dump+0x490/0x490 [openvswitch]
[ 1035.777709]  ? __kmalloc+0x131/0x2e0
[ 1035.777709]  ? genl_family_rcv_msg+0xa54/0x1030
[ 1035.777709]  genl_family_rcv_msg+0x63a/0x1030
[ 1035.777709]  ? genl_unregister_family+0x630/0x630
[ 1035.841681]  ? debug_show_all_locks+0x2d0/0x2d0
[ ... ]

Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Greg Rose <gvrose8192@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/vport-internal_dev.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -170,7 +170,9 @@ static struct vport *internal_dev_create
 {
 	struct vport *vport;
 	struct internal_dev *internal_dev;
+	struct net_device *dev;
 	int err;
+	bool free_vport = true;
 
 	vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
 	if (IS_ERR(vport)) {
@@ -178,8 +180,9 @@ static struct vport *internal_dev_create
 		goto error;
 	}
 
-	vport->dev = alloc_netdev(sizeof(struct internal_dev),
-				  parms->name, NET_NAME_USER, do_setup);
+	dev = alloc_netdev(sizeof(struct internal_dev),
+			   parms->name, NET_NAME_USER, do_setup);
+	vport->dev = dev;
 	if (!vport->dev) {
 		err = -ENOMEM;
 		goto error_free_vport;
@@ -200,8 +203,10 @@ static struct vport *internal_dev_create
 
 	rtnl_lock();
 	err = register_netdevice(vport->dev);
-	if (err)
+	if (err) {
+		free_vport = false;
 		goto error_unlock;
+	}
 
 	dev_set_promiscuity(vport->dev, 1);
 	rtnl_unlock();
@@ -211,11 +216,12 @@ static struct vport *internal_dev_create
 
 error_unlock:
 	rtnl_unlock();
-	free_percpu(vport->dev->tstats);
+	free_percpu(dev->tstats);
 error_free_netdev:
-	free_netdev(vport->dev);
+	free_netdev(dev);
 error_free_vport:
-	ovs_vport_free(vport);
+	if (free_vport)
+		ovs_vport_free(vport);
 error:
 	return ERR_PTR(err);
 }


