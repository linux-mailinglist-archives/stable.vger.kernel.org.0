Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A642161B3B
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgBQTHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:07:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55427 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727300AbgBQTHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:07:52 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3060A22006;
        Mon, 17 Feb 2020 14:07:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LhZhwX
        7t0jDp2mRQ//wh0BwELoQECWA8PCe7Rc5/ewY=; b=Z5IFtZbkrgLELVG3/88EUB
        ialp1HidjuBa3NmIZhCUW1KtEI8ukrllCZ6aV6o9GQnzVG1roWDODnGCRPrF/pIR
        gYYcaXKLNet8rZeH6g5zSwWgnOUgkHjxMaAcASdRvMmcSf1ooxRdftEXZok6NQ10
        asJ5/9JKWIufhBCb64j2Ym1qnenzAz6ZpnpgwEQXaXhE3FwB8D1jsMbQjr+4t8Ic
        XcY/brfjUv+u5QCnrWjCvfjfQH7b0pLGnYzABh9zYsvz8CU9ngfHAZIranu/c8IM
        iGRP8u+vjcszaIxeyXgLg40L3Jzs1OGuBC49KF+7eMAgrmmt810NtKnToBguIIgg
        ==
X-ME-Sender: <xms:huRKXnbkCnBVrP-Vp8XiWC9n8Ct4WtRr3S59mI8L55XV7xaT-LDKSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:huRKXnJOdfFZLbPPdp2MaSeV362iVtUzRhWdwuUZeUrv6E3KqpCGfw>
    <xmx:huRKXpnj9bIidytAPaSejBfBCPP_3e-mV_g72CTpKIvtHzvOxCl9iw>
    <xmx:huRKXm3lpZvD3chE9gep8ZDAh3ldXG2n-cmNea6yynGclXDZSW5y4Q>
    <xmx:h-RKXi0g6V8Z7qTXrG5EKY-Vu3Eeo1fpCsu3n54PJmYf9R6myU8H7A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3A723060C28;
        Mon, 17 Feb 2020 14:07:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: simplify checking quota limits in ext4_statfs()" failed to apply to 5.5-stable tree
To:     jack@suse.cz, scan-admin@coverity.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:07:40 +0100
Message-ID: <1581966460247127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 46d36880d1c6f9b9a0cbaf90235355ea1f4cab96 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 30 Jan 2020 12:11:48 +0100
Subject: [PATCH] ext4: simplify checking quota limits in ext4_statfs()

Coverity reports that conditions checking quota limits in ext4_statfs()
contain dead code. Indeed it is right and current conditions can be
simplified.

Link: https://lore.kernel.org/r/20200130111148.10766-1-jack@suse.cz
Reported-by: Coverity <scan-admin@coverity.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 88b213bd32bc..f23367a779e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5585,10 +5585,7 @@ static int ext4_statfs_project(struct super_block *sb,
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_bsoftlimit &&
-	    (!limit || dquot->dq_dqb.dqb_bsoftlimit < limit))
-		limit = dquot->dq_dqb.dqb_bsoftlimit;
+	limit = dquot->dq_dqb.dqb_bsoftlimit;
 	if (dquot->dq_dqb.dqb_bhardlimit &&
 	    (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
 		limit = dquot->dq_dqb.dqb_bhardlimit;
@@ -5603,10 +5600,7 @@ static int ext4_statfs_project(struct super_block *sb,
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_isoftlimit &&
-	    (!limit || dquot->dq_dqb.dqb_isoftlimit < limit))
-		limit = dquot->dq_dqb.dqb_isoftlimit;
+	limit = dquot->dq_dqb.dqb_isoftlimit;
 	if (dquot->dq_dqb.dqb_ihardlimit &&
 	    (!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
 		limit = dquot->dq_dqb.dqb_ihardlimit;

