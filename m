Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A33024F30D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 09:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHXHYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 03:24:17 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:41421 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725850AbgHXHYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 03:24:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A387F19405E5;
        Mon, 24 Aug 2020 03:24:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Aug 2020 03:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=E0gI4D
        fHcOpkZs/c6y9/L5jqkYvrbaGR4VbUo+zYt44=; b=fC05dsYbP+An8aARP4Go5N
        mYJu+p3q3dflqaTQT8XDo+0cFcd+Lp36+Ba8ueXS5hs59l3EqaGVLfH1P0lW9gP/
        6Lz1fTdK1r5mqNp9RxHzHRVGgivcrRhVfMuo3aOr/yfm+VHWlp8a9aeTgXyx29RL
        RUMOiAEq7xBkHKnc2daHnf3j+YcGyUaBzG6xV8eInfaG+3KmndA7CvwRv9bdszqW
        etbCHvvBOFFOVVnAcSA/jRZldJ652XNplI1Tt+H2IKgEF3VfcLmng88hfbQuCSPs
        pDCCGsazWLvlKy07fkpzTTGyy2RGxpBaw7gxD+YrJHVtUf6S8exFqam1Zf92KcHA
        ==
X-ME-Sender: <xms:H2tDX8DMP2MoAlTBt-OvqVG-p1vXCpY3OWts30XGn_jmmYRb5ewOvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddujedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:H2tDX-jJFB3ePxKBHN06lYkO6dQmtSERndXaPniZ-QYlfARTftyQGg>
    <xmx:H2tDX_m_gFijhBIMpWjk1zShvPWLuWrvSpTtdnkRPPcx6Noa1REyog>
    <xmx:H2tDXyzfuofYwPLdC1Q-pjbAAgjZ4CIghylf4l87g4bKIfzCyfxz8Q>
    <xmx:H2tDX8NRYV_VsldAokf52IarcpseovWm-KcJIfDZeFWpx_wcVC5g7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 39E0A30600A9;
        Mon, 24 Aug 2020 03:24:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] epoll: Keep a reference on files added to the check list" failed to apply to 4.19-stable tree
To:     maz@kernel.org, viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Aug 2020 09:24:31 +0200
Message-ID: <1598253871248251@kroah.com>
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

