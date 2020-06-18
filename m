Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF971FE14C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732273AbgFRBx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731637AbgFRB0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:26:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB052088E;
        Thu, 18 Jun 2020 01:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443577;
        bh=zBzG+XQLAb/qyuKQzJ5OOYujuxtJFnwnJn8P+8Fyby0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYzqLJvoa/GoeuUAzWUQxp0JkurlxjUlTMTh8l5LnEUwdF089xiPvY/L7Qa2VLSGg
         AN/gqQZXsKOaggIxxpuoCWzLzeBCa1BMbkqJMrFzLvSmOXDug8B5IKQqJ5/2HKwj7E
         DC3T/GVKlXCbiv9tpetAFa8hW9FroT/m7WKC2S34=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Hillf Danton <hdanton@sina.com>,
        syzbot+bfdd4a2f07be52351350@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 013/108] Smack: slab-out-of-bounds in vsscanf
Date:   Wed, 17 Jun 2020 21:24:25 -0400
Message-Id: <20200618012600.608744-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit 84e99e58e8d1e26f04c097f4266e431a33987f36 ]

Add barrier to soob. Return -EOVERFLOW if the buffer
is exceeded.

Suggested-by: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+bfdd4a2f07be52351350@syzkaller.appspotmail.com
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index f6482e53d55a..371ae368da35 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -906,11 +906,21 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	else
 		rule += strlen(skp->smk_known) + 1;
 
+	if (rule > data + count) {
+		rc = -EOVERFLOW;
+		goto out;
+	}
+
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
 		goto out;
 
 	rule += SMK_DIGITLEN;
+	if (rule > data + count) {
+		rc = -EOVERFLOW;
+		goto out;
+	}
+
 	ret = sscanf(rule, "%d", &catlen);
 	if (ret != 1 || catlen > SMACK_CIPSO_MAXCATNUM)
 		goto out;
-- 
2.25.1

