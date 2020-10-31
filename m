Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250592A1B26
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 00:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgJaXNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 19:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgJaXNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 19:13:04 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC14E208B6;
        Sat, 31 Oct 2020 23:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604185983;
        bh=5YTncnfxoiRc+Gm3gLawwFHq1F8Nr63JtIwvhMbDln0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYVLm8TGbc/oHq4jfcNvT6eqaZiEPw5eUZauowUvu6cuHnDuVPBi4FeFkNXQD1lSg
         TToeokDPVFnlpy5cfblQBbhQlhOWRHuMpIXZJAQga5CuDxXBLmtF1829KBsVD5oQiB
         cbbWzEuf+J82q5dY4f4BNAiWYr07arhzXdv7zhB8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.9 2/2] fscrypt: use EEXIST when file already uses different policy
Date:   Sat, 31 Oct 2020 16:11:24 -0700
Message-Id: <20201031231124.1199710-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201031231124.1199710-1-ebiggers@kernel.org>
References: <20201031231124.1199710-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 8488cd96ff88966ccb076e4f3654f59d84ba686d upstream.

As part of an effort to clean up fscrypt-related error codes, make
FS_IOC_SET_ENCRYPTION_POLICY fail with EEXIST when the file already uses
a different encryption policy.  This is more descriptive than EINVAL,
which was ambiguous with some of the other error cases.

I am not aware of any users who might be relying on the previous error
code of EINVAL, which was never documented anywhere.

This failure case will be exercised by an xfstest.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/crypto/policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index a89e50331deb6..2bf6e0a2a57ca 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -131,7 +131,7 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 		printk(KERN_WARNING
 		       "%s: Policy inconsistent with encryption context\n",
 		       __func__);
-		ret = -EINVAL;
+		ret = -EEXIST;
 	}
 
 	inode_unlock(inode);
-- 
2.29.1

