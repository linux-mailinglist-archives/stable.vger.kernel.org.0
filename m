Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C78141ED3
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgASPUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:20:09 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57151 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbgASPUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 10:20:09 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D676F5E5;
        Sun, 19 Jan 2020 10:20:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 10:20:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LsyrxL
        qGsbwTOfI1+QVY/Slbi3H2StlxJhSFEKTqEZY=; b=YLiusYW+9jl82UNmk4RCw5
        Bf1Wd8B3iCVRxzcOrlUVSjQgNyLsq/Dfy81RRj5RbCdfn3Xfu6Y3yneSpru5Iwv6
        JJKGLY3M1dF5UtTGh6VgrqQ0HS2uWVF2CCtSrOU7xnkVVmWBF6EU0tA+WtzjDuW1
        lfzohUwnEqt+Gznq9LGKcLgsThsDsIKuIzebs9WWQXG0jzpD2PROYgrXosR4+4WA
        Cygk9WroFV3AJnZn1mo87P/CrAngwbRvc0i+gArsFpiZi6YfQbrjBZ3Y6RVeDvk9
        HdtdqxtG4vbD5MtTclW0V2apezPMgQ2FrhcA+dx1OSBAyj6l2IIjdi5lb5kT2AqQ
        ==
X-ME-Sender: <xms:p3MkXuvGvvmpZVzUAo3MkPD1Kys2bhhRsu3G6RB3mLl91vdjZ6ki2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:p3MkXrSP5gWrjv7DEm_6Il605c-FDgLZ_8h1t0r76ObfkIFIg2KONA>
    <xmx:p3MkXlKAe6RZUeJqhCuXVZ9W1V6hHABgRUQry9Nl97a8UmpiUJoqXg>
    <xmx:p3MkXjCnO5BCuVrZs7Oep6za3e6FQ-2ywJAZMZko7NUPk3LgbcB1ag>
    <xmx:p3MkXlduY6k4P6W1P4ljKxLr--Jz8SvclMeXAVqHU8j_Kf7I0JHXiw>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2ECC30607B4;
        Sun, 19 Jan 2020 10:20:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not delete mismatched root refs" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 16:20:02 +0100
Message-ID: <157944720280143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

