Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E15224F384
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgHXICU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgHXICT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:02:19 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917CE2075B;
        Mon, 24 Aug 2020 08:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598256138;
        bh=0elixhzmaMFF9JGEi2NLWPA1js6+d7kekWDxJYOz/Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIJiG3yC+dNCEYpHxlj3JYlqfkZNR/++lpbZLCNY5WZlWHLsCI7pnhhFZ4BLS1Mq0
         nLs8dFlVG1E6Vulp/0dH25eLjQXBbsVAjaQkLItsMDVglqlIWGcRd7zD90bjPtu7kO
         dbzLt6TYFnhYtRY0Qfq0O0ZEnUcjnJadXbX/zoRQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kA7Qn-0067fK-5K; Mon, 24 Aug 2020 09:02:17 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 2/2] do_epoll_ctl(): clean the failure exits up a bit
Date:   Mon, 24 Aug 2020 09:02:11 +0100
Message-Id: <20200824080211.1037550-3-maz@kernel.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

Commit 52c479697c9b73f628140dcdfcd39ea302d05482 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 fs/eventpoll.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index b53ae571f064..0d9b1e2b9da7 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2195,10 +2195,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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
@@ -2227,8 +2225,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 			error = ep_insert(ep, &epds, tf.file, fd, full_check);
 		} else
 			error = -EEXIST;
-		if (full_check)
-			clear_tfile_check_list();
 		break;
 	case EPOLL_CTL_DEL:
 		if (epi)
@@ -2251,8 +2247,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
-	if (full_check)
+	if (full_check) {
+		clear_tfile_check_list();
 		mutex_unlock(&epmutex);
+	}
 
 	fdput(tf);
 error_fput:
-- 
2.27.0

