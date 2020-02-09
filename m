Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C6C156A52
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBINBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:01:15 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60613 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:01:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C62B821E97;
        Sun,  9 Feb 2020 08:01:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:01:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iPX40N
        6j7ojTzJPGEXvo6MbLPWn8a6LGrQKlPgTISkI=; b=REnkx1qyZ95jEU1X4OQmE6
        bM3OffAgqrRuUGO1MB8q0FyKqE46T+ieWReluOTTkAArDS5j2lk4n6zZKTX3IJLm
        4bpcA6ZstdwTKxj1VjXfu80EA6yTqadqKMp4ZbwaW0r9hXI5tM7joCJtsXhCrq47
        zV8591XKzlU/Igidvd8VP5ne96mz3Z9BUAdtFIcZ06R2v8dU/c/l+hL7KtUto7pu
        pb4cHp1Dvw8rE6IURjK2eoFWVNN7S7WwB+8QrtO94UTzyzmhkQT76Zo1XRT60yIT
        yqdvgkCn/uI0U2HlpGLXWD+hhgplV9+Luh8VHI8Gs/KsL/8/lpMFTcjSghEWqJcw
        ==
X-ME-Sender: <xms:mQJAXrSRRQRYd6cMyLOi5mDC1NHRd6Fpho_ELmGgcKUhKPOE3w8FjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepgeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mQJAXo3Ku-dajIkeYf1uPRK99ADYI08ogPeqMHKPed-JiuMiMSvC1Q>
    <xmx:mQJAXmymivmEguYs1pJONgXR9pNRIvapJcfxA71M9n2skyoHPBE3vg>
    <xmx:mQJAXr_xb9uRZwp8pyM7kZaBznuHbuC-ahRYYKllBb63ObxocFdiQw>
    <xmx:mQJAXqbnyf94DIVQX80Amx_9yEbc_b8u6WDMlwYRMGeMIRXpy0YMEw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 677573060272;
        Sun,  9 Feb 2020 08:01:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not zero f_bavail if we have available space" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, martin@lichtvoll.de,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:33:41 +0100
Message-ID: <158124802120462@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 31 Jan 2020 09:31:05 -0500
Subject: [PATCH] btrfs: do not zero f_bavail if we have available space

There was some logic added a while ago to clear out f_bavail in statfs()
if we did not have enough free metadata space to satisfy our global
reserve.  This was incorrect at the time, however didn't really pose a
problem for normal file systems because we would often allocate chunks
if we got this low on free metadata space, and thus wouldn't really hit
this case unless we were actually full.

Fast forward to today and now we are much better about not allocating
metadata chunks all of the time.  Couple this with d792b0f19711 ("btrfs:
always reserve our entire size for the global reserve") which now means
we'll easily have a larger global reserve than our free space, we are
now more likely to trip over this while still having plenty of space.

Fix this by skipping this logic if the global rsv's space_info is not
full.  space_info->full is 0 unless we've attempted to allocate a chunk
for that space_info and that has failed.  If this happens then the space
for the global reserve is definitely sacred and we need to report
b_avail == 0, but before then we can just use our calculated b_avail.

Reported-by: Martin Steigerwald <martin@lichtvoll.de>
Fixes: ca8a51b3a979 ("btrfs: statfs: report zero available if metadata are exhausted")
CC: stable@vger.kernel.org # 4.5+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Tested-By: Martin Steigerwald <martin@lichtvoll.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a906315efd19..0616a5434793 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2135,7 +2135,15 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 */
 	thresh = SZ_4M;
 
-	if (!mixed && total_free_meta - thresh < block_rsv->size)
+	/*
+	 * We only want to claim there's no available space if we can no longer
+	 * allocate chunks for our metadata profile and our global reserve will
+	 * not fit in the free metadata space.  If we aren't ->full then we
+	 * still can allocate chunks and thus are fine using the currently
+	 * calculated f_bavail.
+	 */
+	if (!mixed && block_rsv->space_info->full &&
+	    total_free_meta - thresh < block_rsv->size)
 		buf->f_bavail = 0;
 
 	buf->f_type = BTRFS_SUPER_MAGIC;

