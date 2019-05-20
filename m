Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76409230BC
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 11:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732361AbfETJvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 05:51:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56789 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732378AbfETJvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 05:51:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 441BB24477;
        Mon, 20 May 2019 05:51:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 20 May 2019 05:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R+p/yb
        hNGX2n3EdSgt6ycoMmMCFkgmKRxxVYzDxxRSs=; b=nWpMPht8B7pd26BqxqoCp5
        3Oo0mYCTTypSgzh/b16A0eMAeOhneMg1O5HSsjBvrC7ZICrPhWTa6unAdJAxWp69
        Y6UzTKBGkWOEEgdhbsUhyHL4Jg59n9uIcEoY8okRLcrR8ASIcwrU4gO6nnAru6dj
        bJyOaP7vA88zyk2tnTGG3dV+da8w2RBxT8SSSE7xxTwPawv3wWka7WQ16jlXh9fk
        vHVrf97mmrB8lFQsjar9BBvImHd8HUob9Kqg5v3G0IZSVkeTheY7AN8+KqEAiwsS
        ZqUrJvG2e7xVykSLGzvrhz74z5H/RLyB9AwoYiZovxXWMbt4tlkONSJ5mBqOA1Pg
        ==
X-ME-Sender: <xms:sXjiXN1fRGe1VykIhBlqGUgNQM1udOc-DSqx-4cKBBTJSxuSWKY_6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:sXjiXC-GaW9PtkdcYic76U2Xuy6fihB4pXvcp_oMzNOF1LgfkBjDsw>
    <xmx:sXjiXOTnRpnW-6tMn6p-msfbPax1wRt2hrIYrdBxxDyHD506JIFXjw>
    <xmx:sXjiXP2c_KA3V8S8l-gxNTal0D0IP22kM8Px7KRdva1nDiARAODc9A>
    <xmx:sXjiXNg-qPfNg9XqLwP7YxVS1sImF_oSLHa5-II7ozNVGnfsfgsDzg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 940978005C;
        Mon, 20 May 2019 05:51:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix use-after-free in dx_release()" failed to apply to 4.4-stable tree
To:     stummala@codeaurora.org, adilger@dilger.ca, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 11:51:42 +0200
Message-ID: <1558345902195242@kroah.com>
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

From 08fc98a4d6424af66eb3ac4e2cedd2fc927ed436 Mon Sep 17 00:00:00 2001
From: Sahitya Tummala <stummala@codeaurora.org>
Date: Fri, 10 May 2019 22:00:33 -0400
Subject: [PATCH] ext4: fix use-after-free in dx_release()

The buffer_head (frames[0].bh) and it's corresping page can be
potentially free'd once brelse() is done inside the for loop
but before the for loop exits in dx_release(). It can be free'd
in another context, when the page cache is flushed via
drop_caches_sysctl_handler(). This results into below data abort
when accessing info->indirect_levels in dx_release().

Unable to handle kernel paging request at virtual address ffffffc17ac3e01e
Call trace:
 dx_release+0x70/0x90
 ext4_htree_fill_tree+0x2d4/0x300
 ext4_readdir+0x244/0x6f8
 iterate_dir+0xbc/0x160
 SyS_getdents64+0x94/0x174

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Cc: stable@kernel.org

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e917830eae84..ac7457fef9e6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -872,12 +872,15 @@ static void dx_release(struct dx_frame *frames)
 {
 	struct dx_root_info *info;
 	int i;
+	unsigned int indirect_levels;
 
 	if (frames[0].bh == NULL)
 		return;
 
 	info = &((struct dx_root *)frames[0].bh->b_data)->info;
-	for (i = 0; i <= info->indirect_levels; i++) {
+	/* save local copy, "info" may be freed after brelse() */
+	indirect_levels = info->indirect_levels;
+	for (i = 0; i <= indirect_levels; i++) {
 		if (frames[i].bh == NULL)
 			break;
 		brelse(frames[i].bh);

