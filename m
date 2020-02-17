Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BCE161B3D
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgBQTIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:08:51 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39971 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728448AbgBQTIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:08:51 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 85B8620D7C;
        Mon, 17 Feb 2020 14:08:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:08:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vAHxg3
        8KBczME1N0b/51N5pbjoOtAiaIHVcbSPVfWbI=; b=C5CN78cNse8E6bZzu38wNW
        yeucOEMwgcZPYZsp0yFImdCYXIsFvp9RZAXf3lIOuRlIrbJbxDzLzXeNL5Hv3LcW
        ljKce02ihJUldIT/fSjNbZb91cJryVuhm2KNj0NjoteGjwiSFgZD+8KaEoRQ/9eJ
        9jLef2gzfd+2yTdqfIUS7XOOvZ+GoK4D8h4KyGUjXahfHF2s+K3UxeiyvmOyTiFo
        cnc+EzczZac0awdgIUk66h3unPt3BR6gT+bp9ey9CsYReCX6IV5goiRDf7MHYRwr
        UP4hY9eQ9rNWwMq9DyArGHTQ025NVHyb1GTmT47o6xML2P73W15hlg0g+Z68I9MA
        ==
X-ME-Sender: <xms:weRKXiN1I2_VhkzIXqLLrQ0e5-yN9noOp3U1Hs8JMqIhLO9lGQS7EQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:weRKXuFnD44UcURVONX53eAA6gp0uxx1VUh0hn2AP6Sv4y8sc_zPhg>
    <xmx:weRKXptIwNPApF_sUGx7VkdAcYB_pqKrTXsujhVXCEVrcexKYdl-4Q>
    <xmx:weRKXjut195xK36vD6LPtSP4PS-qgi8JyAeo1rXP3xjtcDtDAkSB6A>
    <xmx:wuRKXrJMtX3_AKV9URHB1PN1fL1J4gPcg_So5bjmVFzXxw_IeqeYaw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB8233060D1A;
        Mon, 17 Feb 2020 14:08:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: print message when tree-log replay starts" failed to apply to 4.4-stable tree
To:     dsterba@suse.com, anand.jain@oracle.com,
        johannes.thumshirn@wdc.com, lists@colorremedies.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:08:48 +0100
Message-ID: <158196652852170@kroah.com>
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

From e8294f2f6aa6208ed0923aa6d70cea3be178309a Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Wed, 5 Feb 2020 17:12:16 +0100
Subject: [PATCH] btrfs: print message when tree-log replay starts

There's no logged information about tree-log replay although this is
something that points to previous unclean unmount. Other filesystems
report that as well.

Suggested-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7fa9bb79ad08..89422aa8e9d1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3164,6 +3164,7 @@ int __cold open_ctree(struct super_block *sb,
 	/* do not make disk changes in broken FS or nologreplay is given */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
+		btrfs_info(fs_info, "start tree-log replay");
 		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
 			err = ret;

