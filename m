Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D65324F383
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgHXICV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgHXICT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:02:19 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F6E62072D;
        Mon, 24 Aug 2020 08:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598256138;
        bh=e2RoZayN2eWtP+1hSS+BMbgq9BRrRXwPNN4hVRZog2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htSnrJUZBxFsaco+o5K8B4XdPfCeFZLze8Hz2fsrXjq7mhaQLsURlVaEi6lpZTrdp
         GRX6zlltf2Z0Z5v3kFyXNbqsUcYPG5qRxNIvKUbLtEQfnrayTSdBOD346skdOIGK5o
         MWrnfwMuMhuDo2Yh62IYbH7SdhM6NHIhWqZa63Ro=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kA7Qm-0067fK-RO; Mon, 24 Aug 2020 09:02:16 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 1/2] epoll: Keep a reference on files added to the check list
Date:   Mon, 24 Aug 2020 09:02:10 +0100
Message-Id: <20200824080211.1037550-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200824080211.1037550-1-maz@kernel.org>
References: <20200824080211.1037550-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: stable@vger.kernel.org, gregkh@linuxfoundation.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a9ed4a6560b8562b7e2e2bed9527e88001f7b682 upstream.

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
---
 fs/eventpoll.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 6307c1d883e0..b53ae571f064 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1991,9 +1991,11 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
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
@@ -2037,6 +2039,7 @@ static void clear_tfile_check_list(void)
 		file = list_first_entry(&tfile_check_list, struct file,
 					f_tfile_llink);
 		list_del_init(&file->f_tfile_llink);
+		fput(file);
 	}
 	INIT_LIST_HEAD(&tfile_check_list);
 }
@@ -2196,9 +2199,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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
-- 
2.27.0

