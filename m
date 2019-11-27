Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5AA10BB0A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732831AbfK0VJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732830AbfK0VJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:09:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D803A2086A;
        Wed, 27 Nov 2019 21:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888941;
        bh=vma1+y/i0t67aijisSoim2RvjrLDgcUc1DDG8Q+KHnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00l+IL/YJKwfoteIfu0SLLHiNrxD3AdOMp2gQugZYZsZuEGc9poRRywfynGSViyWh
         BhRue8+Ba06jRjBd0rxp6sF4LJEPe8e+9lrS4JsGvrtfdnBjoOr/4QO7LUVzFLg15M
         Wqnev/OraOPNtHErH22dTc9aA+Rso+RUW8jT1D4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.3 22/95] fork: fix pidfd_poll()s return type
Date:   Wed, 27 Nov 2019 21:31:39 +0100
Message-Id: <20191127202850.552050279@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

commit 9e77716a75bc6cf54965e5ec069ba7c02b32251c upstream.

pidfd_poll() is defined as returning 'unsigned int' but the
.poll method is declared as returning '__poll_t', a bitwise type.

Fix this by using the proper return type and using the EPOLL
constants instead of the POLL ones, as required for __poll_t.

Fixes: b53b0b9d9a61 ("pidfd: add polling support")
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: stable@vger.kernel.org # 5.3
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20191120003320.31138-1-luc.vanoostenryck@gmail.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1713,11 +1713,11 @@ static void pidfd_show_fdinfo(struct seq
 /*
  * Poll support for process exit notification.
  */
-static unsigned int pidfd_poll(struct file *file, struct poll_table_struct *pts)
+static __poll_t pidfd_poll(struct file *file, struct poll_table_struct *pts)
 {
 	struct task_struct *task;
 	struct pid *pid = file->private_data;
-	int poll_flags = 0;
+	__poll_t poll_flags = 0;
 
 	poll_wait(file, &pid->wait_pidfd, pts);
 
@@ -1729,7 +1729,7 @@ static unsigned int pidfd_poll(struct fi
 	 * group, then poll(2) should block, similar to the wait(2) family.
 	 */
 	if (!task || (task->exit_state && thread_group_empty(task)))
-		poll_flags = POLLIN | POLLRDNORM;
+		poll_flags = EPOLLIN | EPOLLRDNORM;
 	rcu_read_unlock();
 
 	return poll_flags;


