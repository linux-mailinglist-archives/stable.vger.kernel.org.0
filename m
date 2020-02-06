Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED09154C32
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBFTZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:25:05 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41981 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:25:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 94BE622083;
        Thu,  6 Feb 2020 14:25:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:25:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CBlQF8
        iLdlQIOABRbrXefHh8I6rpd3TACTXiKdZYbVU=; b=crpNP5tkiLsU7RuuU4Nn2G
        z6VH9UcZCwVGjvTvBqjvf0q1QdyMcK9JWeiDCN0dmjnmvYX+3OBYlfFJR/6hn3yf
        F+nvEym1UGkUO7cFoESdQiLWq5baZE+NLeo0cfHi+rPuWbEkzpMzcMAzwcl6LBFX
        a7qiG4myWk5W1JBMLxerjxa8TL6STIMTvPFRoXB//WLIFPjTz15Nk+a7cEtKsC6S
        rkT6BNszyO/e/+EDlrAMF1AgZLd8/9xJB28Re7BbSnuWokiTGY4vloPM4u41e59P
        5Kg4sTq4BSUP4ZQMJ5RXXvHCGoCD5ZK4vjP7/PJhd6PhIiHPRXNsGdy5ygWYCsyQ
        ==
X-ME-Sender: <xms:EGg8XnWkZze0IvcvfBTjVxUsRfyy6MZDN9zWNauhEfjZxU049JUfCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EGg8Xl5nfJu8MrUGaYimh4Fb5BDg-Xe9T2GSICfd-8C3I5yQNlzTJQ>
    <xmx:EGg8XgHOtt1zgK-V2aC6-8B7m9oBZPKTBABe3l5XdLQzX1Hib95Z6Q>
    <xmx:EGg8Xg8VjmJ495gsUnwnafnsNUtai5DzdFPTjblvJ7cZoU_RupUZIw>
    <xmx:EGg8XpC8VaXmgIwX_Avgv-55QHwJ1wGuhLleVvTxMsjzMoVvN_DmiQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3129C30606E9;
        Thu,  6 Feb 2020 14:25:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: don't trigger assertion on invalid no-key filename" failed to apply to 4.14-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:14:22 +0100
Message-ID: <158101646257220@kroah.com>
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

From f0d07a98a070bb5e443df19c3aa55693cbca9341 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Mon, 20 Jan 2020 14:31:59 -0800
Subject: [PATCH] ubifs: don't trigger assertion on invalid no-key filename

If userspace provides an invalid fscrypt no-key filename which encodes a
hash value with any of the UBIFS node type bits set (i.e. the high 3
bits), gracefully report ENOENT rather than triggering ubifs_assert().

Test case with kvm-xfstests shell:

    . fs/ubifs/config
    . ~/xfstests/common/encrypt
    dev=$(__blkdev_to_ubi_volume /dev/vdc)
    ubiupdatevol $dev -t
    mount $dev /mnt -t ubifs
    mkdir /mnt/edir
    xfs_io -c set_encpolicy /mnt/edir
    rm /mnt/edir/_,,,,,DAAAAAAAAAAAAAAAAAAAAAAAAAA

With the bug, the following assertion fails on the 'rm' command:

    [   19.066048] UBIFS error (ubi0:0 pid 379): ubifs_assert_failed: UBIFS assert failed: !(hash & ~UBIFS_S_KEY_HASH_MASK), in fs/ubifs/key.h:170

Fixes: f4f61d2cc6d8 ("ubifs: Implement encrypted filenames")
Cc: <stable@vger.kernel.org> # v4.10+
Link: https://lore.kernel.org/r/20200120223201.241390-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 636c3222c230..5f937226976a 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -228,6 +228,8 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
 	if (nm.hash) {
 		ubifs_assert(c, fname_len(&nm) == 0);
 		ubifs_assert(c, fname_name(&nm) == NULL);
+		if (nm.hash & ~UBIFS_S_KEY_HASH_MASK)
+			goto done; /* ENOENT */
 		dent_key_init_hash(c, &key, dir->i_ino, nm.hash);
 		err = ubifs_tnc_lookup_dh(c, &key, dent, nm.minor_hash);
 	} else {

