Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5031BC861
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgD1ScI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbgD1ScH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 331AB20B80;
        Tue, 28 Apr 2020 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098726;
        bh=eVdIKm2kuMC/roZW1kDDMJeJ4ns4NVmx3rwtzKl9sLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSm2oS/m8hmj5BrgdTZQIq2Ss5cofwWeBWijgG08G4qCCmkS1qQCkUR+dNt8IomZK
         25b2OB6Q86kXmLvNxitQe/Rj4Iz/owMochRUJSgk8JgE6GejbCovmZ2GSos76mge/u
         6jSHErqhGfrHqBnGZCIMgx4v6Tw01CUdA+vOAlto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, NeilBrown <neilb@suse.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/131] ipc/util.c: sysvipc_find_ipc() should increase position index
Date:   Tue, 28 Apr 2020 20:23:54 +0200
Message-Id: <20200428182227.882110386@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 89163f93c6f969da5811af5377cc10173583123b ]

If seq_file .next function does not change position index, read after
some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/b7a20945-e315-8bb0-21e6-3875c14a8494@virtuozzo.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/util.c b/ipc/util.c
index 0af05752969f1..b111e792b3125 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -735,13 +735,13 @@ static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
 			total++;
 	}
 
+	*new_pos = pos + 1;
 	if (total >= ids->in_use)
 		return NULL;
 
 	for (; pos < IPCMNI; pos++) {
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
-			*new_pos = pos + 1;
 			rcu_read_lock();
 			ipc_lock_object(ipc);
 			return ipc;
-- 
2.20.1



