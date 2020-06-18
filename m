Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202AA1FF592
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFROrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:47:52 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36957 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730950AbgFROrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:47:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 4870D69B;
        Thu, 18 Jun 2020 10:47:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Z9vgg1
        S6DA+hJGL8fQylCTUxu4/q9Kns/G1itQdJQ/U=; b=N9Q41zriFurVIWQh3zx1m8
        aWDtJgDLnDFSh2YmZ9ZAFTIdZVGGowElYmidDtCUQmvSEiJSf1YNV/DMXjZKyHJO
        Y3iPQzOiooTDB6DNijvMmV9Uv/bIEUgfOyL5rIoQSgo8E/yzmaIg+l2Ql+ElHE/g
        9kilVBK80F7XQAuys2YjFvZ9UWT7dQ9XCOwGsCCZi1vdIO/3FFrDjzsUHJz0rxQS
        R7IFzwmiPtU3LCqfykD63ExgQt+Uvw61/i4qrtbX9fGREK4+Yq2N3zNPWfNEPoWW
        l+XMOKswRpa1FpEOYpv1w3NWDblJdG4ZRR/TZbkwSPATBPfzmyYq/flGOiWzQh2g
        ==
X-ME-Sender: <xms:jX7rXgst171vYAb2vxoS_XTzhNZTmEVhjYgeyZtO9GQ0O1K2iUHgWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:jX7rXtcrMH8_0jjmoeSV8Njba7dGJgEugXYhLggCKqKFt3VqsHOaWg>
    <xmx:jX7rXrwsekLMYbJ9DZOv0O91Vqqicw6F6Gzxdassgy_kslMCN5KJKQ>
    <xmx:jX7rXjNgaZxeg0mPLri8NZE0lCZmbCwPNFFxHHdD77a33zHPu3X29g>
    <xmx:jX7rXpJiR59Sz4tZfeTFB-A3gVdSDs3KALymXxS2JvWiHNIkrLeO3qDIepo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 70B6D3062499;
        Thu, 18 Jun 2020 10:47:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix wrong file range cleanup after an error filling" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 16:47:35 +0200
Message-ID: <159249165512742@kroah.com>
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

