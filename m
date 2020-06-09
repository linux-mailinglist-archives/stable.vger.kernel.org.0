Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C651F4481
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbgFISF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbgFIRvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:51:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034A62074B;
        Tue,  9 Jun 2020 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725102;
        bh=ckNLh2n+Dc7ckEahQ8OUPixQxq1QJCpN7sdro1EuQFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNW2Wy1MZedKYxX/48bBsTPPSlc1iqyz7vYiTzbb9RAtgDUnaIMf8wq42T1Wos0zx
         m3QCoR5lf/YliQBEXs3IrSWQ4+T78hfPBcaC7JlI4a6xEFow9vMQ0o7+9Jv2//b03O
         xxvEAze8MkRaomPL10CEW+aJeNsVCnwSML8I6t/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 25/25] Revert "net/mlx5: Annotate mutex destroy for root ns"
Date:   Tue,  9 Jun 2020 19:45:15 +0200
Message-Id: <20200609174051.624603139@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174048.576094775@linuxfoundation.org>
References: <20200609174048.576094775@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 95fde2e46860c183f6f47a99381a3b9bff488bd5 which is
commit 9ca415399dae133b00273a4283ef31d003a6818d upstream.

It was backported incorrectly, Paul writes at:
	https://lore.kernel.org/r/20200607203425.GD23662@windriver.com

	I happened to notice this commit:

	9ca415399dae - "net/mlx5: Annotate mutex destroy for root ns"

	...was backported to 4.19 and 5.4 and v5.6 in linux-stable.

	It patches del_sw_root_ns() - which only exists after v5.7-rc7 from:

	6eb7a268a99b - "net/mlx5: Don't maintain a case of del_sw_func being
	null"

	which creates the one line del_sw_root_ns stub function around
	kfree(node) by breaking it out of tree_put_node().

	In the absense of del_sw_root_ns - the backport finds an identical one
	line kfree stub fcn - named del_sw_prio from this earlier commit:

	139ed6c6c46a - "net/mlx5: Fix steering memory leak"  [in v4.15-rc5]

	and then puts the mutex_destroy() into that (wrong) function, instead of
	putting it into tree_put_node where the root ns case used to be hand

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Roi Dayan <roid@mellanox.com>
Cc: Mark Bloch <markb@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -364,12 +364,6 @@ static void del_sw_ns(struct fs_node *no
 
 static void del_sw_prio(struct fs_node *node)
 {
-	struct mlx5_flow_root_namespace *root_ns;
-	struct mlx5_flow_namespace *ns;
-
-	fs_get_obj(ns, node);
-	root_ns = container_of(ns, struct mlx5_flow_root_namespace, ns);
-	mutex_destroy(&root_ns->chain_lock);
 	kfree(node);
 }
 


