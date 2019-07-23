Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675E3718A3
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389992AbfGWMuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:50:03 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:57835 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbfGWMuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:50:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 815E15EB;
        Tue, 23 Jul 2019 08:50:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wdS8yu
        66wzc+Z3FoSEQu9/NIx5RKuYyOrU7oe8j0iSY=; b=XEofBSEmqN8hopgkGSTuMf
        4S+dtjHDyUw0MB0XOkfj60KXa30Le2kJrD4x0h8UbXokjvg+mudFyEJn5NqpgeJA
        shjbxdkIFdi+TrWsc9KGOx78E9IW1XEjr4oji/bmm6KeGQQrBWS86rGVqhlyAtYC
        799djBgTIrnkgvvqnWvNBAStBK3UibUnAH+c9v0CNJ012xi1jGb71Y87i/gnZk97
        MZzYccaun8DOcDszpEMOQH5GBTpS1TKrxCnEquJXdBwmj3pbLJ4l6MQySkjPeJK0
        Tbi9uwN+tMaeftqkoXHzbLTPzik1u0QxkbUZCeOGq+o6tgavD4XzvIsWshnAtAIw
        ==
X-ME-Sender: <xms:eAI3XVlZl-hT4xxxM0nDYnFp9qjJp6CJDoMUnkzrXAeU3NlEtM5mpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:eAI3XbscvwT_fcG1JOKYsFarst2tReWyYc62rn_VP46jN8EeKCrLDQ>
    <xmx:eAI3XV2J-TC0A00vVI0OAGELr5Zm1fILSfyR-RKIgBqbOzwWpC4Kag>
    <xmx:eAI3XXRIZCNyT6PKlwnuB18cOpnhXlHCT1dfmHbqZDZfNfIJ9T79vQ>
    <xmx:eQI3XZiQgF3WP6rkrX6MP2eD3QKTcWTASdvmyT0-wpnrIBdACjDt_A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 714E980060;
        Tue, 23 Jul 2019 08:50:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: add missing inode version, ctime and mtime updates" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:49:58 +0200
Message-ID: <1563886198209236@kroah.com>
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

From 179006688a7e888cbff39577189f2e034786d06a Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 19 Jun 2019 13:05:50 +0100
Subject: [PATCH] Btrfs: add missing inode version, ctime and mtime updates
 when punching hole

If the range for which we are punching a hole covers only part of a page,
we end up updating the inode item but we skip the update of the inode's
iversion, mtime and ctime. Fix that by ensuring we update those properties
of the inode.

A patch for fstests test case generic/059 that tests this as been sent
along with this fix.

Fixes: 2aaa66558172b0 ("Btrfs: add hole punching")
Fixes: e8c1c76e804b18 ("Btrfs: add missing inode update when punching hole")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5370152ea7e3..b455bdf46faa 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2711,6 +2711,11 @@ out_only_mutex:
 		 * for detecting, at fsync time, if the inode isn't yet in the
 		 * log tree or it's there but not up to date.
 		 */
+		struct timespec64 now = current_time(inode);
+
+		inode_inc_iversion(inode);
+		inode->i_mtime = now;
+		inode->i_ctime = now;
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
 			err = PTR_ERR(trans);

