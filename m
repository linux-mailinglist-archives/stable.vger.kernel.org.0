Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C666376800
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbhEGPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:32:01 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:51751 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237834AbhEGPcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:32:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4B4621941A19;
        Fri,  7 May 2021 11:31:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 07 May 2021 11:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6JJVdL
        KN2z0i4YfQcufhI7TfIqYzj7+s2NtNsdMLVT4=; b=Z4Eg9tu2lu0cneic+lApL7
        ci4kNHMZIzMotjCDdZhtO5PzYmOPTuRZq3dPyB6vOvgCBQzcxEo5SAC95P10ouyr
        2w9lINw9kUsP1yBeqgwCwQ7l/3gZ0x2hZj1lyfhX01AZCcLojYrwen1mzupzGNz2
        gXXjltPpL8wkP0gbs5etCRYiP16CDpHVb9LfSyl/seFLF9atYAODGYZUsD1XCSlE
        RCHfaK7OfUNS//QmPFYrzgMYUQAxMRp4As6otzGxMeoZ2r4h+ROnTFl7EQ28ZKFw
        xc/gl+7ArCV0RQhhjl2ljau0cjeVIku4WYiGF860yMXA/x3/p+m8qu/B+KTG4P9g
        ==
X-ME-Sender: <xms:M12VYJRDvjCCMEoljq9mM9VIdvLe5FdIIlbk9sfEdZQfk-n2bkaGHw>
    <xme:M12VYCzaH55Q864lwELBnggzx1kCMLv7FBCTmCiyhVE0mQKnbo0jq23ydrkaIe91K
    MP1z0xz4z94ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:M12VYO3EgzGficKqYrCsgt8EV9s3pT9LeTlD8s1NMimKrtD8uI9XMg>
    <xmx:M12VYBAzZ82uW52XJIveL0ROzu881l8g1fT6usT5hmqlCzW9HyMylQ>
    <xmx:M12VYCji1FsciEXrFoVWw1hJt-1TS7yoBLatVowd369xgfwB6TYS-w>
    <xmx:NF2VYDsOYXU2E51yYiGlts_7Hy0F9yRIvAOt2Vmm_Sfq52GLZfywoQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 11:30:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix a potential hole punching failure" failed to apply to 4.19-stable tree
To:     bingjingc@synology.com, cccheng@synology.com, dsterba@suse.com,
        fdmanana@suse.com, robbieko@synology.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 17:30:32 +0200
Message-ID: <16204014321252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3227788cd369d734d2d3cd94f8af7536b60fa552 Mon Sep 17 00:00:00 2001
From: BingJing Chang <bingjingc@synology.com>
Date: Thu, 25 Mar 2021 09:56:22 +0800
Subject: [PATCH] btrfs: fix a potential hole punching failure

In commit d77815461f04 ("btrfs: Avoid trucating page or punching hole
in a already existed hole."), existing holes can be skipped by calling
find_first_non_hole() to adjust start and len. However, if the given len
is invalid and large, when an EXTENT_MAP_HOLE extent is found, len will
not be set to zero because (em->start + em->len) is less than
(start + len). Then the ret will be 1 but len will not be set to 0.
The propagated non-zero ret will result in fallocate failure.

In the while-loop of btrfs_replace_file_extents(), len is not updated
every time before it calls find_first_non_hole(). That is, after
btrfs_drop_extents() successfully drops the last non-hole file extent,
it may fail with ENOSPC when attempting to drop a file extent item
representing a hole. The problem can happen. After it calls
find_first_non_hole(), the cur_offset will be adjusted to be larger
than or equal to end. However, since the len is not set to zero, the
break-loop condition (ret && !len) will not be met. After it leaves the
while-loop, fallocate will return 1, which is an unexpected return
value.

We're not able to construct a reproducible way to let
btrfs_drop_extents() fail with ENOSPC after it drops the last non-hole
file extent but with remaining holes left. However, it's quite easy to
fix. We just need to update and check the len every time before we call
find_first_non_hole(). To make the while loop more readable, we also
pull the variable updates to the bottom of loop like this:
  while (cur_offset < end) {
	  ...
	  // update cur_offset & len
	  // advance cur_offset & len in hole-punching case if needed
  }

Reported-by: Robbie Ko <robbieko@synology.com>
Fixes: d77815461f04 ("btrfs: Avoid trucating page or punching hole in a already existed hole.")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: BingJing Chang <bingjingc@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 42634658815f..864c08d08a35 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2730,8 +2730,6 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 			extent_info->file_offset += replace_len;
 		}
 
-		cur_offset = drop_args.drop_end;
-
 		ret = btrfs_update_inode(trans, root, inode);
 		if (ret)
 			break;
@@ -2751,7 +2749,9 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 		BUG_ON(ret);	/* shouldn't happen */
 		trans->block_rsv = rsv;
 
-		if (!extent_info) {
+		cur_offset = drop_args.drop_end;
+		len = end - cur_offset;
+		if (!extent_info && len) {
 			ret = find_first_non_hole(inode, &cur_offset, &len);
 			if (unlikely(ret < 0))
 				break;

