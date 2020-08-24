Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB2524F85F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgHXJav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgHXIuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:50:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B612A2075B;
        Mon, 24 Aug 2020 08:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259037;
        bh=6CWT5yFJGbIhKo0odsI5tP10yt8cR+KoeyWEK6OjVoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGBsNAsQsNoZHA27Zj50RSev44yX+5B+4JEVx8XEfI0nDK341tWveSkYU2gcFKxn7
         NL4FsAQ17rZoP58OmPEusDKys9Hs5noByZ8cg0bVQuT76E0MkenwaWfAP/CF62uCG9
         FeuhIStSBptY3GGrbDfVWwnF0ILDk4htPKR/qc5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.4 30/33] do_epoll_ctl(): clean the failure exits up a bit
Date:   Mon, 24 Aug 2020 10:31:26 +0200
Message-Id: <20200824082348.042955499@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082346.498653578@linuxfoundation.org>
References: <20200824082346.498653578@linuxfoundation.org>
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
@@ -1905,10 +1905,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
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
@@ -1937,8 +1935,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 			error = ep_insert(ep, &epds, tf.file, fd, full_check);
 		} else
 			error = -EEXIST;
-		if (full_check)
-			clear_tfile_check_list();
 		break;
 	case EPOLL_CTL_DEL:
 		if (epi)
@@ -1959,8 +1955,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
-	if (full_check)
+	if (full_check) {
+		clear_tfile_check_list();
 		mutex_unlock(&epmutex);
+	}
 
 	fdput(tf);
 error_fput:


