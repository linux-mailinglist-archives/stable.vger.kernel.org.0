Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023A360FEA7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbiJ0RHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiJ0RHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:07:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7627219C06E;
        Thu, 27 Oct 2022 10:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15CCF623F7;
        Thu, 27 Oct 2022 17:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE921C433C1;
        Thu, 27 Oct 2022 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890427;
        bh=KnqdBqXpwjnoczNNin28/Qu7T5+d3J3wqw/aPVgwV5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6gkwDRq0ZzW/1wjsK67lKou40T33TVnreVpyu07Srkg2xJGTGA9FB1KrmtyIVOKA
         rSp0/RiFPQ9T5igRiiYFZ8Xe5FTQNSX1hJC+/r83GuFjNS8SlzrZ6GXEtmSWuDpSLR
         f/xEYcoJCYAy853/om+k78fumLtbSSuciB4dmKDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 67/79] fcntl: make F_GETOWN(EX) return 0 on dead owner task
Date:   Thu, 27 Oct 2022 18:56:17 +0200
Message-Id: <20221027165056.588648208@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

[ Upstream commit cc4a3f885e8f2bc3c86a265972e94fef32d68f67 ]

Currently there is no way to differentiate the file with alive owner
from the file with dead owner but pid of the owner reused. That's why
CRIU can't actually know if it needs to restore file owner or not,
because if it restores owner but actual owner was dead, this can
introduce unexpected signals to the "false"-owner (which reused the
pid).

Let's change the api, so that F_GETOWN(EX) returns 0 in case actual
owner is dead already. This comports with the POSIX spec, which
states that a PID of 0 indicates that no signal will be sent.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: f671a691e299 ("fcntl: fix potential deadlocks for &fown_struct.lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 71b43538fa44..5a56351f1fc3 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -148,11 +148,15 @@ void f_delown(struct file *filp)
 
 pid_t f_getown(struct file *filp)
 {
-	pid_t pid;
+	pid_t pid = 0;
 	read_lock(&filp->f_owner.lock);
-	pid = pid_vnr(filp->f_owner.pid);
-	if (filp->f_owner.pid_type == PIDTYPE_PGID)
-		pid = -pid;
+	rcu_read_lock();
+	if (pid_task(filp->f_owner.pid, filp->f_owner.pid_type)) {
+		pid = pid_vnr(filp->f_owner.pid);
+		if (filp->f_owner.pid_type == PIDTYPE_PGID)
+			pid = -pid;
+	}
+	rcu_read_unlock();
 	read_unlock(&filp->f_owner.lock);
 	return pid;
 }
@@ -200,11 +204,14 @@ static int f_setown_ex(struct file *filp, unsigned long arg)
 static int f_getown_ex(struct file *filp, unsigned long arg)
 {
 	struct f_owner_ex __user *owner_p = (void __user *)arg;
-	struct f_owner_ex owner;
+	struct f_owner_ex owner = {};
 	int ret = 0;
 
 	read_lock(&filp->f_owner.lock);
-	owner.pid = pid_vnr(filp->f_owner.pid);
+	rcu_read_lock();
+	if (pid_task(filp->f_owner.pid, filp->f_owner.pid_type))
+		owner.pid = pid_vnr(filp->f_owner.pid);
+	rcu_read_unlock();
 	switch (filp->f_owner.pid_type) {
 	case PIDTYPE_PID:
 		owner.type = F_OWNER_TID;
-- 
2.35.1



