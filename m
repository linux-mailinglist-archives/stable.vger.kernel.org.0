Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1A639DA2
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfFHLma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbfFHLm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C57042166E;
        Sat,  8 Jun 2019 11:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994148;
        bh=EkM2IxcFl4jf8hTxdFG9OcyBo5zAazPHULjwbj7FpBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yeEWeJSa2frBPsxTHomabRblxBpzKtEfX/jMPgm/yZfvuqniI2lSKgQK976dhTAs4
         fHAxdkkQuPbFY8HNQ1EczhN0FjTy5KlDKoHm1/44LOACOi79JP/X+9QT9gnOYfeJcz
         DNdqCVyVxN81iJnEBbBNbb4GeXzb0Npia01UmO4E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 70/70] ocfs2: fix error path kobject memory leak
Date:   Sat,  8 Jun 2019 07:39:49 -0400
Message-Id: <20190608113950.8033-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tobin C. Harding" <tobin@kernel.org>

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

