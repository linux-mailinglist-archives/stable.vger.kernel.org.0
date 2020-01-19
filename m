Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC545141ED2
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgASPUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:20:06 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33429 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbgASPUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 10:20:06 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 64A1E603;
        Sun, 19 Jan 2020 10:20:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 10:20:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=F+D/+8
        2MQByWMjgOygN0dW9fN+w3vp8Bi+MvCZBUY18=; b=JoJuWHSHApPzWEW4jL1OCT
        8CyQ/F3RP9RFxMlmuFC5yuWx2Ai8BOse1x/Als0s2uIRKAEHUTlAlb96whU58KUu
        KuyTYoTkDmE6BOZhjiaf3D4d/8FQyjwpd1QE1BhOBueWjtLkVdFPzeX3VozTC6nd
        oXlWW4PnWajzAr/yZ/E2IMk7NLBritddHio0WUIHzdZC5xvmIk9BORuOQfWL+/dp
        Ll66XphIrYU0H6jQrfAQsfEVkDoOBoRWUeE4unGcWwwzJJ4f6EKpamRJ/26HbHf3
        Ddo+yCabPPx7HjNUbsfo4XDXAcjm+b/U8tiuL+vw5Kr3cJuycS+caOHJR7e6Iwbg
        ==
X-ME-Sender: <xms:pHMkXtnG17vT9UzSmX1H57NfeL_uGiy1evwazjHdNj2iiPhtifTCzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:pHMkXtGVt_a0AhpLZm-xm3bffgkztdL0DOy1LVn7cyVXJEpvg8Gz0Q>
    <xmx:pHMkXup8GxljdLO25ExM5D154xlkyMGOJ4SpTz2vnKEfzjyF1OaJ6g>
    <xmx:pHMkXh51pYVOPGXsRAe4xdCfCXpCO1RbsRECYx_w8vweq_FEfy3LQg>
    <xmx:pXMkXp5fUMNwkx9tA71qZWj5NNQ-NLzRZTcBa2krMzgPE9DYiLzv7A>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 190B380062;
        Sun, 19 Jan 2020 10:20:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not delete mismatched root refs" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 16:20:00 +0100
Message-ID: <1579447200198127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 423a716cd7be16fb08690760691befe3be97d3fc Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Dec 2019 17:20:29 -0500
Subject: [PATCH] btrfs: do not delete mismatched root refs

btrfs_del_root_ref() will simply WARN_ON() if the ref doesn't match in
any way, and then continue to delete the reference.  This shouldn't
happen, we have these values because there's more to the reference than
the original root and the sub root.  If any of these checks fail, return
-ENOENT.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 3b17b647d002..612411c74550 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -376,11 +376,13 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		leaf = path->nodes[0];
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_root_ref);
-
-		WARN_ON(btrfs_root_ref_dirid(leaf, ref) != dirid);
-		WARN_ON(btrfs_root_ref_name_len(leaf, ref) != name_len);
 		ptr = (unsigned long)(ref + 1);
-		WARN_ON(memcmp_extent_buffer(leaf, name, ptr, name_len));
+		if ((btrfs_root_ref_dirid(leaf, ref) != dirid) ||
+		    (btrfs_root_ref_name_len(leaf, ref) != name_len) ||
+		    memcmp_extent_buffer(leaf, name, ptr, name_len)) {
+			err = -ENOENT;
+			goto out;
+		}
 		*sequence = btrfs_root_ref_sequence(leaf, ref);
 
 		ret = btrfs_del_item(trans, tree_root, path);

