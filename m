Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC83C4C58
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhGLHD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240724AbhGLHCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4720061106;
        Mon, 12 Jul 2021 06:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073181;
        bh=RTHPMxZCVJCPRLhGtXbla3CWUL8925mLsVAzTkaWzv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMxEtds5MspBsJZfaU/hAAKPyDDYowJ6iecM2mGDtAl1UzJK4PLL26RQZc4sOll0l
         ogmtwmUyCdlkKcJ8bBsgKAsfNlmcGCukYMDxdxfb/YK0yNMk1t1fmN9trF0wITeyvk
         cboWOlfJkBriokGQks1ACzkRxL7FSwCg3XyNqFQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 153/700] ima: Dont remove security.ima if file must not be appraised
Date:   Mon, 12 Jul 2021 08:03:56 +0200
Message-Id: <20210712060947.198137314@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 565e33ff19d0..d7cc6f897746 100644
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



