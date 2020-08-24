Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF14E24F889
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgHXItc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbgHXItb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:49:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB3802074D;
        Mon, 24 Aug 2020 08:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258971;
        bh=43LJd02YGIGlFXYgShUKYJBdC/ln2Mu9tLSPDO1OTh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8yGd8OuSWElVqVGmmBi6XgIsu2P4LIo3l2EcP9xeLrRBYNGEVzq8dBVhH+8zUwXL
         zk7401ssPrXQ6kiiOoHQpEfTG/AiXVHgGOPXYIqib7MN/v5aM+vZdKqolQ25ApD3Sz
         3W1PIe9BBGeKk5ANlvEz3gtFtLjwL8Fu/V5thcd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 105/107] do_epoll_ctl(): clean the failure exits up a bit
Date:   Mon, 24 Aug 2020 10:31:11 +0200
Message-Id: <20200824082410.285233358@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2195,10 +2195,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 			mutex_lock(&epmutex);
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
@@ -2227,8 +2225,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 			error = ep_insert(ep, &epds, tf.file, fd, full_check);
 		} else
 			error = -EEXIST;
-		if (full_check)
-			clear_tfile_check_list();
 		break;
 	case EPOLL_CTL_DEL:
 		if (epi)
@@ -2251,8 +2247,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
-	if (full_check)
+	if (full_check) {
+		clear_tfile_check_list();
 		mutex_unlock(&epmutex);
+	}
 
 	fdput(tf);
 error_fput:


