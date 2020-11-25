Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490482C43C9
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbgKYPg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730852AbgKYPg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E166A21D7F;
        Wed, 25 Nov 2020 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318616;
        bh=O1tKLJVHTcRcu8Y1X7W3kleGKRcftokeYEDlZR3ix8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDgsZ12EvHGKFtgiZV9svIbJ4MzlvrUXyFsxrXFgKzwCIjOwHfg0FryTOpfDFlT+y
         CH+aqulb9+AcCdFoLzmsUK8ZvGgdAbBUP9EYVC2lB0hRY+aBxkquVC66jVUd0Zh0Vn
         BqzaiquFtIobhD8SsijEzNCbJfRkEE0ByRFxVQFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/23] proc: don't allow async path resolution of /proc/self components
Date:   Wed, 25 Nov 2020 10:36:28 -0500
Message-Id: <20201125153638.810419-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153638.810419-1-sashal@kernel.org>
References: <20201125153638.810419-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 8d4c3e76e3be11a64df95ddee52e99092d42fc19 ]

If this is attempted by a kthread, then return -EOPNOTSUPP as we don't
currently support that. Once we can get task_pid_ptr() doing the right
thing, then this can go away again.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/self.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/proc/self.c b/fs/proc/self.c
index 32af065397f80..582336862d258 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -16,6 +16,13 @@ static const char *proc_self_get_link(struct dentry *dentry,
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name;
 
+	/*
+	 * Not currently supported. Once we can inherit all of struct pid,
+	 * we can allow this.
+	 */
+	if (current->flags & PF_KTHREAD)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!tgid)
 		return ERR_PTR(-ENOENT);
 	/* max length of unsigned int in decimal + NULL term */
-- 
2.27.0

