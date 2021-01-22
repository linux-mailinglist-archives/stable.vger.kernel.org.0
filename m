Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0C9300D0D
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbhAVT6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbhAVOM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:12:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9F923A5B;
        Fri, 22 Jan 2021 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324606;
        bh=L7KD2YZnVZgDTlPWg6WQ7CLV51ceygQBrjWfU8zGEQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRUMUu/4kq+7ZtUPZaIAf49AL28Uy6fLDbRMvi/VGOs86Ude9Qyf5//UfRbVQL9/J
         AuMpNqhy9ezN0DKDoLoTL0xOI1TXcB7f7oV6M25c6lGbTIhsr6zUmwT4psEzVTVGqO
         pVzTWP8N9JWgT0kIRJ1MKrR8METa1CWPo0+akWds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 4.4 13/31] dump_common_audit_data(): fix racy accesses to ->d_name
Date:   Fri, 22 Jan 2021 15:08:27 +0100
Message-Id: <20210122135732.407970754@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
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
@@ -264,7 +264,9 @@ static void dump_common_audit_data(struc
 		struct inode *inode;
 
 		audit_log_format(ab, " name=");
+		spin_lock(&a->u.dentry->d_lock);
 		audit_log_untrustedstring(ab, a->u.dentry->d_name.name);
+		spin_unlock(&a->u.dentry->d_lock);
 
 		inode = d_backing_inode(a->u.dentry);
 		if (inode) {
@@ -282,8 +284,9 @@ static void dump_common_audit_data(struc
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


