Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0713BB041
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhGDXIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhGDXHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 845AA611ED;
        Sun,  4 Jul 2021 23:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439913;
        bh=LX8MytkC20dE/E1lNwDIxGB7QpmzBK0Wy9YYqWHXUwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1/ZAXX01hOAkSgQIfxnvOwfnc+BRwY4ZfbiVX7JdGywLYoZFXFha+juxIfT16UGh
         e8LgM39SUFPVVbXv/F1mxbX1oCx9hWJSSSKFNKl9QYZ4zR+X8nC0F5dwbPXEp2Ur+9
         ttnI3216eDstiTCFzPAdt4hYokupiKfn86AMyWJrYa/vG8FbvqlQ1A4GQO3LAyfhMf
         uxhG3vhylW7b8pyFifuwEvIdHWtsmYqVvBUQkSZ5JDVyG+tHT2BpTL1Bt2Rp7Xsu5V
         yX9RcUympoDkQNO7TeD6Zyi6K66hqStKhXvtDos8ECd+Uzp2hP/Yn57G3sGMZzkD4p
         ePFEFDbzJqK+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 38/85] ima: Don't remove security.ima if file must not be appraised
Date:   Sun,  4 Jul 2021 19:03:33 -0400
Message-Id: <20210704230420.1488358-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit ed1b472fc15aeaa20ddeeb93fd25190014e50d17 ]

Files might come from a remote source and might have xattrs, including
security.ima. It should not be IMA task to decide whether security.ima
should be kept or not. This patch removes the removexattr() system
call in ima_inode_post_setattr().

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_appraise.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 4e5eb0236278..55dac618f2a1 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -522,8 +522,6 @@ void ima_inode_post_setattr(struct user_namespace *mnt_userns,
 		return;
 
 	action = ima_must_appraise(mnt_userns, inode, MAY_ACCESS, POST_SETATTR);
-	if (!action)
-		__vfs_removexattr(&init_user_ns, dentry, XATTR_NAME_IMA);
 	iint = integrity_iint_find(inode);
 	if (iint) {
 		set_bit(IMA_CHANGE_ATTR, &iint->atomic_flags);
-- 
2.30.2

