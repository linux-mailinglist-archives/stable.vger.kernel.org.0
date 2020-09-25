Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B252787A0
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgIYMtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgIYMtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD3EC21741;
        Fri, 25 Sep 2020 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038144;
        bh=/Qli6mlea/rvplNg3Pt7zNC2rJ8lTL+hBOrt0jde4hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdWNaIMRkClDrEhTPuSdVBdPEtq1HCYoOLd8QPFz1UZHbpbWiZrivqPOg6gLQS5HF
         8AZ7/z7Z6R5qhdRFxFSo7mSiNj2XhHZXdpQpi8UiGbXEgxREL7z2xtvLAb6h3hmCsM
         KzUYDVQq67WulWPHuM+CYIww6epXoBJ4AhdCFQPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.8 20/56] net/mlx5: Fix FTE cleanup
Date:   Fri, 25 Sep 2020 14:48:10 +0200
Message-Id: <20200925124730.848483640@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit cefc23554fc259114e78a7b0908aac4610ee18eb ]

Currently, when an FTE is allocated, its refcount is decreased to 0
with the purpose it will not be a stand alone steering object and every
rule (destination) of the FTE would increase the refcount.
When mlx5_cleanup_fs is called while not all rules were deleted by the
steering users, it hit refcount underflow on the FTE once clean_tree
calls to tree_remove_node after the deleted rules already decreased
the refcount to 0.

FTE is no longer destroyed implicitly when the last rule (destination)
is deleted. mlx5_del_flow_rules avoids it by increasing the refcount on
the FTE and destroy it explicitly after all rules were deleted. So we
can avoid the refcount underflow by making FTE as stand alone object.
In addition need to set del_hw_func to FTE so the HW object will be
destroyed when the FTE is deleted from the cleanup_tree flow.

refcount_t: underflow; use-after-free.
WARNING: CPU: 2 PID: 15715 at lib/refcount.c:28 refcount_warn_saturate+0xd9/0xe0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Call Trace:
 tree_put_node+0xf2/0x140 [mlx5_core]
 clean_tree+0x4e/0xf0 [mlx5_core]
 clean_tree+0x4e/0xf0 [mlx5_core]
 clean_tree+0x4e/0xf0 [mlx5_core]
 clean_tree+0x5f/0xf0 [mlx5_core]
 clean_tree+0x4e/0xf0 [mlx5_core]
 clean_tree+0x5f/0xf0 [mlx5_core]
 mlx5_cleanup_fs+0x26/0x270 [mlx5_core]
 mlx5_unload+0x2e/0xa0 [mlx5_core]
 mlx5_unload_one+0x51/0x120 [mlx5_core]
 mlx5_devlink_reload_down+0x51/0x90 [mlx5_core]
 devlink_reload+0x39/0x120
 ? devlink_nl_cmd_reload+0x43/0x220
 genl_rcv_msg+0x1e4/0x420
 ? genl_family_rcv_msg_attrs_parse+0x100/0x100
 netlink_rcv_skb+0x47/0x110
 genl_rcv+0x24/0x40
 netlink_unicast+0x217/0x2f0
 netlink_sendmsg+0x30f/0x430
 sock_sendmsg+0x30/0x40
 __sys_sendto+0x10e/0x140
 ? handle_mm_fault+0xc4/0x1f0
 ? do_page_fault+0x33f/0x630
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x48/0x130
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 718ce4d601db ("net/mlx5: Consolidate update FTE for all removal changes")
Fixes: bd71b08ec2ee ("net/mlx5: Support multiple updates of steering rules in parallel")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -655,7 +655,7 @@ static struct fs_fte *alloc_fte(struct m
 	fte->action = *flow_act;
 	fte->flow_context = spec->flow_context;
 
-	tree_init_node(&fte->node, NULL, del_sw_fte);
+	tree_init_node(&fte->node, del_hw_fte, del_sw_fte);
 
 	return fte;
 }
@@ -1792,7 +1792,6 @@ skip_search:
 		up_write_ref_node(&g->node, false);
 		rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte);
 		up_write_ref_node(&fte->node, false);
-		tree_put_node(&fte->node, false);
 		return rule;
 	}
 	rule = ERR_PTR(-ENOENT);
@@ -1891,7 +1890,6 @@ search_again_locked:
 	up_write_ref_node(&g->node, false);
 	rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte);
 	up_write_ref_node(&fte->node, false);
-	tree_put_node(&fte->node, false);
 	tree_put_node(&g->node, false);
 	return rule;
 
@@ -2001,7 +1999,9 @@ void mlx5_del_flow_rules(struct mlx5_flo
 		up_write_ref_node(&fte->node, false);
 	} else {
 		del_hw_fte(&fte->node);
-		up_write(&fte->node.lock);
+		/* Avoid double call to del_hw_fte */
+		fte->node.del_hw_func = NULL;
+		up_write_ref_node(&fte->node, false);
 		tree_put_node(&fte->node, false);
 	}
 	kfree(handle);


