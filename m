Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537D124F5B7
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbgHXIwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbgHXIwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:52:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ADF62075B;
        Mon, 24 Aug 2020 08:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259142;
        bh=AFq2eiQEON9yvH4IRXSOgBm1oiC5Gj5b7q5M/mEJfy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjRQxXwkaN7uTmf4KxZOMSeLNhfEBoMba1CjfUE53EQHuZAPkNUGAHjMGgAPLui7Z
         XwMmalrVXLZn561DYOU4b5Y/Ox6tLo04HJD/zG3Oo37h/W93LQtAwdBd/JTaMZ3y2J
         kafU7K6gx4xydqA9mKwMgYYFWc/jkmc0fRhUtG8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.9 36/39] epoll: Keep a reference on files added to the check list
Date:   Mon, 24 Aug 2020 10:31:35 +0200
Message-Id: <20200824082350.379244679@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082348.445866152@linuxfoundation.org>
References: <20200824082348.445866152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit a9ed4a6560b8562b7e2e2bed9527e88001f7b682 upstream.

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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1747,9 +1747,11 @@ static int ep_loop_check_proc(void *priv
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
@@ -1793,6 +1795,7 @@ static void clear_tfile_check_list(void)
 		file = list_first_entry(&tfile_check_list, struct file,
 					f_tfile_llink);
 		list_del_init(&file->f_tfile_llink);
+		fput(file);
 	}
 	INIT_LIST_HEAD(&tfile_check_list);
 }
@@ -1947,9 +1950,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 					clear_tfile_check_list();
 					goto error_tgt_fput;
 				}
-			} else
+			} else {
+				get_file(tf.file);
 				list_add(&tf.file->f_tfile_llink,
 							&tfile_check_list);
+			}
 			mutex_lock_nested(&ep->mtx, 0);
 			if (is_file_epoll(tf.file)) {
 				tep = tf.file->private_data;


