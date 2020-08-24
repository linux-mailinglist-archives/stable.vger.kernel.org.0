Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E1C24F65B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgHXI5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730263AbgHXI5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:57:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69073204FD;
        Mon, 24 Aug 2020 08:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259458;
        bh=CCOg6YcDob3vQqntrLoC6A5RQVbfcFciQ4LH6jL9ox8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMw4IdQXPrtaNX0MP3IqgmCcx+DA2IRdA1H0LccH6LlQTMH59Va80Hb8pAXF8x2gY
         +MUZ0lk5zBjm8jhlDTsAiXjrISsdJSzdDc2+PM7e74ensNE6z3pEysrI0GPTRqjnCO
         YgPDaqbQIqqh1L4qcROhskwzkDjj5CHYYWXp7/hE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 67/71] epoll: Keep a reference on files added to the check list
Date:   Mon, 24 Aug 2020 10:31:58 +0200
Message-Id: <20200824082359.318904388@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
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
@@ -1890,9 +1890,11 @@ static int ep_loop_check_proc(void *priv
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
@@ -1936,6 +1938,7 @@ static void clear_tfile_check_list(void)
 		file = list_first_entry(&tfile_check_list, struct file,
 					f_tfile_llink);
 		list_del_init(&file->f_tfile_llink);
+		fput(file);
 	}
 	INIT_LIST_HEAD(&tfile_check_list);
 }
@@ -2095,9 +2098,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
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


