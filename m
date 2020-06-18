Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3F21FF593
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgFROr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:47:56 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:35231 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbgFROrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:47:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E30D477A;
        Thu, 18 Jun 2020 10:47:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7n8OUI
        WbM7WpF3JVWQw1wnTDu/75DW46efrGy7KRXtA=; b=bnlwFZjfmXjyQ2fACoYBjp
        bnoE90czb+27C5yb9Mg+vybITChZV5dSuRTUBtQ6H67JzRUc0P5t82Em+m3j0eDJ
        IJhJicuGdmA6oYMGXItYap4z/qF+J8U7RUvxqjAma9myu766Za8Xwv65RfSFsqfC
        f6cgZUBwV6pX/GMoVcMp7pdqUvXPvGxzHaoYp7XCBEGriuOG5A2zd+IwinJw7Hrv
        +qqZflzjOcd8idq3EkvkXoffff8pcRKIEdy57Jeo1UNxDdxYKz0hhZhQiP5NbY8r
        iDQ/CvuOEZ6RpE1o7sv0VvdiTTqwssupFoLvig4TjCbJMEfdF539HswNyqKPE7Uw
        ==
X-ME-Sender: <xms:ln7rXi7Y1Q-vk9mGjP6TcIEy8oyiCWNq7m9UDOQA69MTYhiL_mKYZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ln7rXr57pFSqds06mccXfQUuN4yAaQRM73uZ_H-pfWybmsxQ-AZH0g>
    <xmx:ln7rXhe8vZ-4jI9bfFobLQpmKh-Hk7TXxMXLaPBOXpopqCv4wXM_ew>
    <xmx:ln7rXvIr3Rbtg7UWRNfa514EZ7HBauyX_KwPaa5g92FKakNpK3ClSQ>
    <xmx:ln7rXlkoSWa8nhn3JWN2-8N7u8YLz0DgoQTSKR4_W3Plg11zlMx3eLibsis>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 28ED23062499;
        Thu, 18 Jun 2020 10:47:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix wrong file range cleanup after an error filling" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 16:47:35 +0200
Message-ID: <15924916552315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From e2c8e92d1140754073ad3799eb6620c76bab2078 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 27 May 2020 11:15:53 +0100
Subject: [PATCH] btrfs: fix wrong file range cleanup after an error filling
 dealloc range

If an error happens while running dellaloc in COW mode for a range, we can
end up calling extent_clear_unlock_delalloc() for a range that goes beyond
our range's end offset by 1 byte, which affects 1 extra page. This results
in clearing bits and doing page operations (such as a page unlock) outside
our target range.

Fix that by calling extent_clear_unlock_delalloc() with an inclusive end
offset, instead of an exclusive end offset, at cow_file_range().

Fixes: a315e68f6e8b30 ("Btrfs: fix invalid attempt to free reserved space on failure to cow range")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4583f0763571..1b6cd937f214 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1141,7 +1141,7 @@ static noinline int cow_file_range(struct inode *inode,
 	 */
 	if (extent_reserved) {
 		extent_clear_unlock_delalloc(inode, start,
-					     start + cur_alloc_size,
+					     start + cur_alloc_size - 1,
 					     locked_page,
 					     clear_bits,
 					     page_ops);

