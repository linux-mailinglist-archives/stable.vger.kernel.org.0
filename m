Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387D2230BE
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 11:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbfETJvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 05:51:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57797 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729875AbfETJvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 05:51:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1F99524094;
        Mon, 20 May 2019 05:51:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 20 May 2019 05:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HFGycu
        eIGSbsLTHUchGbsseOKRnl1PukTj9AR14pRSg=; b=54G47oqKsQU0DNungmg1zU
        8jMakVSPs2RCgdfXqSBwbaDXGfd0lyTqbtGasq0PNegQuhXGcyk3e8GziXvAuE9E
        l0vDx8xRyHUN3GVFAwanEPy3EczpS42RzcZ1QKd+Qk1ErsKLTa5ksrczMeyHb2WV
        tjUyBUDMCV/1iSEQxgb2PL4jeW3a1l646DVVZgfsv3p5XiHh1SfWkx0OO6bU+DQP
        NI1GK1OgAhUzgvgGe8Vu8L+BQommlpSeQrOryn0s/1RVubgVv61j4Zn3Z7y6nrh8
        zcn5Y5Utb1iF5i2T6lrtImOnYO6zITncIdorSTUfF0DV60RDaPbIfFDPSAnXrcHw
        ==
X-ME-Sender: <xms:uHjiXD-4lf4iEajnqt5lGD3LPVqzfbFk8zaLqBAUZFNsRWRrB1II6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:uHjiXMD5BicA3HlD8WslYHO3Hj_OGnlVjC2xWU0DaZlUnVv0d9K5Cg>
    <xmx:uHjiXDzgWa6sXRjvZRsSpmmUWi1D6hsWTyaP0sGYG6z4VXdw0BVhkA>
    <xmx:uHjiXBQBnpOc1woPpB7xVifARXrYtS5o1LUHmccH1FRHB7LrubD62A>
    <xmx:uXjiXLslBFbnFthVzRC-HyZoFT3LMmjUC5nDZ5xSXpWTp0-FZe3mCg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7870F10379;
        Mon, 20 May 2019 05:51:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix use-after-free in dx_release()" failed to apply to 4.9-stable tree
To:     stummala@codeaurora.org, adilger@dilger.ca, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 11:51:43 +0200
Message-ID: <1558345903156139@kroah.com>
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

