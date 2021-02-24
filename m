Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A59323CE5
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhBXM6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235364AbhBXMzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56CF64F21;
        Wed, 24 Feb 2021 12:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171092;
        bh=R4poMJ4fqkaGI0hkPtLCQ7VrOdVEnFDmP8jSHKmXElc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uz1g2I9QEJnoyKAQwtpXRnuzFfsDazEiqJpI5tv5xP6IqufPJuh0YKYHTzqVEC2XS
         neKBcQGI8WQYvu0j88L/Z+57KLSM8pJF07qXlPsRXIjnm2IgTUiCiU098HE8GrTx93
         2+pdJCEZBcQfUtx8EtE+QQNU2D79XrcAZtODFQGYRGylpgjCCA5orliadaxTt7HXwy
         f4V4WaQjYX6Y8WAruuJrNcbm22EdCP4axauQSV4FhVNt3zuBso6bXsmAG2IINebJ9l
         RhrbEo8DPizCDcDdPO5/+fUh/mnR6jcqPc3DH8RqT10CUvaHuYvVySN/yJOUMGez7T
         XUC3FDbLL78tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        syzbot+a71a442385a0b2815497@syzkaller.appspotmail.com,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 49/67] smackfs: restrict bytes count in smackfs write functions
Date:   Wed, 24 Feb 2021 07:50:07 -0500
Message-Id: <20210224125026.481804-49-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index 5d44b7d258ef0..22ded2c26089c 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1167,7 +1167,7 @@ static ssize_t smk_write_net4addr(struct file *file, const char __user *buf,
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_NETLBLADDRMIN)
+	if (count < SMK_NETLBLADDRMIN || count > PAGE_SIZE - 1)
 		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
@@ -1427,7 +1427,7 @@ static ssize_t smk_write_net6addr(struct file *file, const char __user *buf,
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_NETLBLADDRMIN)
+	if (count < SMK_NETLBLADDRMIN || count > PAGE_SIZE - 1)
 		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
@@ -1834,6 +1834,10 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	/* Enough data must be present */
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2005,6 +2009,9 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	if (count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2092,6 +2099,9 @@ static ssize_t smk_write_unconfined(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	if (count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2648,6 +2658,10 @@ static ssize_t smk_write_syslog(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	/* Enough data must be present */
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2740,10 +2754,13 @@ static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
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

