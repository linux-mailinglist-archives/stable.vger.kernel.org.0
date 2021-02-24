Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AD4323E1A
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhBXNYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236137AbhBXNOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:14:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D44FD64FB5;
        Wed, 24 Feb 2021 12:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171356;
        bh=5VmWWceF1TbTD1rVIItF0Gcu6QVggeJ57R1GjusCtR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEhiw6cxqAC2VxQXkMMRtHhx4BF7PoBUzk5BFrZBMLVC3iq0lQtOJokqgvecdKiVu
         EBmda6dhhdQmOfZaE9KJIZZn7ACEU1ItYaBz/mEM0j221inFrLz/tZvTTGUs162n2v
         eI+j76JQP5/tIvuNY6w3tOkZwxN9JzIw4Qc66stojRH4WeJP8+1Wmbwp1Ekzf06yao
         0323K+8TZmmUiEarq7qh6nbxAY4RbCfvpaGD8VVqWT5YD7galMEePZaV45xMVS7kIy
         oDGboYgycIYi3njAU4HTEMvNlDXNa8mSP9LTPdHhPGvRhV8qvV9oHlsyCXUxI2nbhb
         X9LzjlJpUYEkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        syzbot+a71a442385a0b2815497@syzkaller.appspotmail.com,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/12] smackfs: restrict bytes count in smackfs write functions
Date:   Wed, 24 Feb 2021 07:55:40 -0500
Message-Id: <20210224125540.484221-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125540.484221-1-sashal@kernel.org>
References: <20210224125540.484221-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

[ Upstream commit 7ef4c19d245f3dc233fd4be5acea436edd1d83d8 ]

syzbot found WARNINGs in several smackfs write operations where
bytes count is passed to memdup_user_nul which exceeds
GFP MAX_ORDER. Check count size if bigger than PAGE_SIZE.

Per smackfs doc, smk_write_net4addr accepts any label or -CIPSO,
smk_write_net6addr accepts any label or -DELETE. I couldn't find
any general rule for other label lengths except SMK_LABELLEN,
SMK_LONGLABEL, SMK_CIPSOMAX which are documented.

Let's constrain, in general, smackfs label lengths for PAGE_SIZE.
Although fuzzer crashes write to smackfs/netlabel on 0x400000 length.

Here is a quick way to reproduce the WARNING:
python -c "print('A' * 0x400000)" > /sys/fs/smackfs/netlabel

Reported-by: syzbot+a71a442385a0b2815497@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 4aecdc8f74b2a..04a53cdb409fa 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1186,7 +1186,7 @@ static ssize_t smk_write_net4addr(struct file *file, const char __user *buf,
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_NETLBLADDRMIN)
+	if (count < SMK_NETLBLADDRMIN || count > PAGE_SIZE - 1)
 		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
@@ -1446,7 +1446,7 @@ static ssize_t smk_write_net6addr(struct file *file, const char __user *buf,
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_NETLBLADDRMIN)
+	if (count < SMK_NETLBLADDRMIN || count > PAGE_SIZE - 1)
 		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
@@ -1853,6 +1853,10 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	/* Enough data must be present */
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2024,6 +2028,9 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	if (count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2111,6 +2118,9 @@ static ssize_t smk_write_unconfined(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	if (count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2664,6 +2674,10 @@ static ssize_t smk_write_syslog(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	/* Enough data must be present */
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2756,10 +2770,13 @@ static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
 		return -EPERM;
 
 	/*
+	 * No partial write.
 	 * Enough data must be present.
 	 */
 	if (*ppos != 0)
 		return -EINVAL;
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
-- 
2.27.0

