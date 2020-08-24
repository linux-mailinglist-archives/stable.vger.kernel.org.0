Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB05324F512
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgHXIoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbgHXIoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:44:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 073292074D;
        Mon, 24 Aug 2020 08:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258655;
        bh=z9X8XAf5pNu5xFYsewaUK9xluow/ICaWKL8M9zLZUyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uH7+wHZKGgk2+76z6yO/ApNzBBq9+die6sfZxl6isAdNMFiU3Cvi+lrGqlY/6Odq8
         gwNWYjNAlkvVsikx9NhzIbWUwwLovB0dJ4cl/NK/HQnk/CY4mYzBa6Ma2HhC7/ZqJe
         jxfzevcEAwXJwn70B1j0b41EcN9naAHRx+IMDJFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.7 123/124] do_epoll_ctl(): clean the failure exits up a bit
Date:   Mon, 24 Aug 2020 10:30:57 +0200
Message-Id: <20200824082415.455961148@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 52c479697c9b73f628140dcdfcd39ea302d05482 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2203,29 +2203,22 @@ int do_epoll_ctl(int epfd, int op, int f
 			full_check = 1;
 			if (is_file_epoll(tf.file)) {
 				error = -ELOOP;
-				if (ep_loop_check(ep, tf.file) != 0) {
-					clear_tfile_check_list();
+				if (ep_loop_check(ep, tf.file) != 0)
 					goto error_tgt_fput;
-				}
 			} else {
 				get_file(tf.file);
 				list_add(&tf.file->f_tfile_llink,
 							&tfile_check_list);
 			}
 			error = epoll_mutex_lock(&ep->mtx, 0, nonblock);
-			if (error) {
-out_del:
-				list_del(&tf.file->f_tfile_llink);
-				if (!is_file_epoll(tf.file))
-					fput(tf.file);
+			if (error)
 				goto error_tgt_fput;
-			}
 			if (is_file_epoll(tf.file)) {
 				tep = tf.file->private_data;
 				error = epoll_mutex_lock(&tep->mtx, 1, nonblock);
 				if (error) {
 					mutex_unlock(&ep->mtx);
-					goto out_del;
+					goto error_tgt_fput;
 				}
 			}
 		}
@@ -2246,8 +2239,6 @@ out_del:
 			error = ep_insert(ep, epds, tf.file, fd, full_check);
 		} else
 			error = -EEXIST;
-		if (full_check)
-			clear_tfile_check_list();
 		break;
 	case EPOLL_CTL_DEL:
 		if (epi)
@@ -2270,8 +2261,10 @@ out_del:
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
-	if (full_check)
+	if (full_check) {
+		clear_tfile_check_list();
 		mutex_unlock(&epmutex);
+	}
 
 	fdput(tf);
 error_fput:


