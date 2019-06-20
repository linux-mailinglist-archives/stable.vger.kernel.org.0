Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95094D73D
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbfFTSRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbfFTSRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:17:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB55E2084E;
        Thu, 20 Jun 2019 18:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054623;
        bh=LCuOsWiv7WF+Oe5V31rsGOh6q0ch6ErTxkreM7dz9f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzXs7zCk0s/KU6LcdVxIXTZby33LdUkp0mkSdQ6XH9U6la0OMQ1XSzIwWV+onk859
         pRqUKZdigz0HmVLrbWJgHhxAhPUDq+pxD4evNhjspTwMESHnU5O6aksz7X2ML/SR8L
         mVVjrdMqlzu1e747q+CN5FIM5nqwd3AEIWIDfKGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Tobin C. Harding" <tobin@kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 93/98] ocfs2: fix error path kobject memory leak
Date:   Thu, 20 Jun 2019 19:58:00 +0200
Message-Id: <20190620174354.065965164@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b9fba67b3806e21b98bd5a98dc3921a8e9b42d61 ]

If a call to kobject_init_and_add() fails we should call kobject_put()
otherwise we leak memory.

Add call to kobject_put() in the error path of call to
kobject_init_and_add().  Please note, this has the side effect that the
release method is called if kobject_init_and_add() fails.

Link: http://lkml.kernel.org/r/20190513033458.2824-1-tobin@kernel.org
Signed-off-by: Tobin C. Harding <tobin@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/filecheck.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index f65f2b2f594d..1906cc962c4d 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -193,6 +193,7 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
 	ret = kobject_init_and_add(&entry->fs_kobj, &ocfs2_ktype_filecheck,
 					NULL, "filecheck");
 	if (ret) {
+		kobject_put(&entry->fs_kobj);
 		kfree(fcheck);
 		return ret;
 	}
-- 
2.20.1



