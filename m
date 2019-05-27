Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F163E2B730
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 16:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfE0OCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 10:02:55 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48639 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbfE0OCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 10:02:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C3E824FF;
        Mon, 27 May 2019 10:02:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 27 May 2019 10:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8fCfOa
        Ead/+I53qT12vIoubNrHdD6sRg6+ajfEyOcuk=; b=tI29OX1s9S1nO2nrxEDtYK
        xRNlz+iH/Ya4/gObyoKrRFe8f6oQHmGr4KmhS1ixEj2KyLGabnjOPznVGWRq8XeA
        GntMx1T69E4/wRrO4iQfZTFhiKVOEJwX9az0KhBmADtPSB518Ln7YnF6d5+8c9lu
        ePZzEaiJE/zH9bv2Wb0aASk3Kc/4L7fTsfBzbRxTq8Fk4LbeP/4MBN9IjHlnBQyu
        KefuxrPpG813kpxG06w/d1elKK/4MUq91G70wc2fWpWMsJ6/4CvI/7Q4WWi1s/NG
        1NV007YEL37gKACqPTdqG7oqXBEt/2LHccDAMhdkhlNV6rKR5SewxCjE9s/4fdOw
        ==
X-ME-Sender: <xms:DO7rXAj50s1hLEUbtJc8KSFCwG4vl6u_TzhHfike8IftZ_dOBh-Kqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:DO7rXMGrph-WX0PgKtnBg45ZztSV-KW5I-0zhm63PpszJ9RpLNshSw>
    <xmx:DO7rXAR74DWk_Z0h1tiabt359RfzfCDtb4A0sCyQRhKabQzSu1F_Cw>
    <xmx:DO7rXFHJj2DLwtd6OvmtIp5fuVGIjiswA7Gc8xZB6Bs5ygDuwT1E4g>
    <xmx:De7rXHGbKbbCIzN2RvKn0Z38Qwjb9Y4f4WU4icxytH3McMqE0UUpcQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 72785380083;
        Mon, 27 May 2019 10:02:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: sysfs: Fix error path kobject memory leak" failed to apply to 4.4-stable tree
To:     tobin@kernel.org, dsterba@suse.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 May 2019 16:02:50 +0200
Message-ID: <1558965770160137@kroah.com>
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

From 450ff8348808a89cc27436771aa05c2b90c0eef1 Mon Sep 17 00:00:00 2001
From: "Tobin C. Harding" <tobin@kernel.org>
Date: Mon, 13 May 2019 13:39:11 +1000
Subject: [PATCH] btrfs: sysfs: Fix error path kobject memory leak

If a call to kobject_init_and_add() fails we must call kobject_put()
otherwise we leak memory.

Calling kobject_put() when kobject_init_and_add() fails drops the
refcount back to 0 and calls the ktype release method (which in turn
calls the percpu destroy and kfree).

Add call to kobject_put() in the error path of call to
kobject_init_and_add().

Cc: stable@vger.kernel.org # v4.4+
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tobin C. Harding <tobin@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f79e477a378e..9bcb3570750e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3882,8 +3882,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 				    info->space_info_kobj, "%s",
 				    alloc_name(space_info->flags));
 	if (ret) {
-		percpu_counter_destroy(&space_info->total_bytes_pinned);
-		kfree(space_info);
+		kobject_put(&space_info->kobj);
 		return ret;
 	}
 

