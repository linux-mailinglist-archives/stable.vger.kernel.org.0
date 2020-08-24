Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A2C24F30F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 09:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgHXHYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 03:24:21 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51631 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725850AbgHXHYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 03:24:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 832FB1940E80;
        Mon, 24 Aug 2020 03:24:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 24 Aug 2020 03:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=me5Y/p
        N/z6Z2Bv4yZP0vT/1F8KOxQ+YgDNiooH4mGf0=; b=u2UhrDIgHprnTsgkGtkJR6
        //36Ftrof2OXIqhND5M1W83E8CXUyOSdmpfPvuDyLO1vmdvowJR4sf4tvVnuOBJP
        m7B7uKs8C9RZbMBD9F1FAChNo5BHPM3KF2VCtbCXuJY0LLx91AGITjoCP5sOUt2M
        XbYAInfsr0/QxLazR2LZ8lhVCrzA19luMEPDDz+lDjoWkZsvgOUq4U/9CzRt0E9B
        35RJZbbxDN6gAvlH1SN5sRb49iB+/LTwcD3MPV7sKKVpKGi9EtcIppi/ELxJi91h
        4LyCRwBNX4DdCWg5o3HSNzfLkbHnvn6kgkGAQFRBcV/PKlPEftjh2vOlHHlKtdfw
        ==
X-ME-Sender: <xms:I2tDXxIpQ4OCPbBS0r-BYVprECb77zoX85zWV9CoOsUky6mI91W2jQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddujedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:I2tDX9LEDPvK-WPejlbn48m2aDjp815bcZHxeMSjg4muBrzQYQh7ag>
    <xmx:I2tDX5vRPOL2JRO6tdPdZjC2lk5efBC0t29cuOmNVWumjJ4nGc_wVg>
    <xmx:I2tDXybt_eHVFbWi3l1DNsp2k-rCkBqM8LOWYtZjaSuZZdySJYG-KQ>
    <xmx:I2tDX-3_AZukzUwUU2lsAf0VFJ0rR6qYf5KyW8hrpHvluYcyTO9vBA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1268C3280065;
        Mon, 24 Aug 2020 03:24:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] epoll: Keep a reference on files added to the check list" failed to apply to 4.4-stable tree
To:     maz@kernel.org, viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Aug 2020 09:24:33 +0200
Message-ID: <15982538739623@kroah.com>
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

From a9ed4a6560b8562b7e2e2bed9527e88001f7b682 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Wed, 19 Aug 2020 17:12:17 +0100
Subject: [PATCH] epoll: Keep a reference on files added to the check list

When adding a new fd to an epoll, and that this new fd is an
epoll fd itself, we recursively scan the fds attached to it
to detect cycles, and add non-epool files to a "check list"
that gets subsequently parsed.

However, this check list isn't completely safe when deletions
can happen concurrently. To sidestep the issue, make sure that
a struct file placed on the check list sees its f_count increased,
ensuring that a concurrent deletion won't result in the file
disapearing from under our feet.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 12eebcdea9c8..196003d9242c 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1994,9 +1994,11 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 			 * not already there, and calling reverse_path_check()
 			 * during ep_insert().
 			 */
-			if (list_empty(&epi->ffd.file->f_tfile_llink))
+			if (list_empty(&epi->ffd.file->f_tfile_llink)) {
+				get_file(epi->ffd.file);
 				list_add(&epi->ffd.file->f_tfile_llink,
 					 &tfile_check_list);
+			}
 		}
 	}
 	mutex_unlock(&ep->mtx);
@@ -2040,6 +2042,7 @@ static void clear_tfile_check_list(void)
 		file = list_first_entry(&tfile_check_list, struct file,
 					f_tfile_llink);
 		list_del_init(&file->f_tfile_llink);
+		fput(file);
 	}
 	INIT_LIST_HEAD(&tfile_check_list);
 }
@@ -2204,13 +2207,17 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 					clear_tfile_check_list();
 					goto error_tgt_fput;
 				}
-			} else
+			} else {
+				get_file(tf.file);
 				list_add(&tf.file->f_tfile_llink,
 							&tfile_check_list);
+			}
 			error = epoll_mutex_lock(&ep->mtx, 0, nonblock);
 			if (error) {
 out_del:
 				list_del(&tf.file->f_tfile_llink);
+				if (!is_file_epoll(tf.file))
+					fput(tf.file);
 				goto error_tgt_fput;
 			}
 			if (is_file_epoll(tf.file)) {

