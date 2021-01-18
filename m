Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497192F9E78
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390588AbhARLjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390582AbhARLjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:39:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05FDF229F0;
        Mon, 18 Jan 2021 11:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969950;
        bh=uiFtAoy1X5FbQVW0lmtDN1898APkv7jDRkAxircn1FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA/QThyGByu3e6KIrcMzWDJX1PMB0MPQsmoqQXPFyeJvetSQqxwmNepNR7bhUmaKh
         biWQyp4D+qsRnWOmajtxTIerKdsdQgZkA174mQtTWtn6sKVF15rxIB5ozFgl7C7ws1
         tEihnj9XqVavnYqiB+OV3UTSa7ghR3fMwROWCv3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 5.4 50/76] dump_common_audit_data(): fix racy accesses to ->d_name
Date:   Mon, 18 Jan 2021 12:34:50 +0100
Message-Id: <20210118113343.381925098@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit d36a1dd9f77ae1e72da48f4123ed35627848507d upstream.

We are not guaranteed the locking environment that would prevent
dentry getting renamed right under us.  And it's possible for
old long name to be freed after rename, leading to UAF here.

Cc: stable@kernel.org # v2.6.2+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/lsm_audit.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -274,7 +274,9 @@ static void dump_common_audit_data(struc
 		struct inode *inode;
 
 		audit_log_format(ab, " name=");
+		spin_lock(&a->u.dentry->d_lock);
 		audit_log_untrustedstring(ab, a->u.dentry->d_name.name);
+		spin_unlock(&a->u.dentry->d_lock);
 
 		inode = d_backing_inode(a->u.dentry);
 		if (inode) {
@@ -292,8 +294,9 @@ static void dump_common_audit_data(struc
 		dentry = d_find_alias(inode);
 		if (dentry) {
 			audit_log_format(ab, " name=");
-			audit_log_untrustedstring(ab,
-					 dentry->d_name.name);
+			spin_lock(&dentry->d_lock);
+			audit_log_untrustedstring(ab, dentry->d_name.name);
+			spin_unlock(&dentry->d_lock);
 			dput(dentry);
 		}
 		audit_log_format(ab, " dev=");


