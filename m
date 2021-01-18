Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3130C2FA2B9
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392712AbhAROKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390603AbhARLpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51B20222BB;
        Mon, 18 Jan 2021 11:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970278;
        bh=llYrbwoXARxKbaa/+bdrGsDF2sOqLAHc+Z+MoSTFUrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fb36PbxdvWX+UbA6Fs4ICLu8mN8Pu59wCIwdsq11Wxrb9lTuFlduoKFYsLVowUc8l
         iAdag6gf2NeQkQdXLN8wW6exizMFMIqwYgvh19ZysPaG348TmKnznWu9O3VPzUdkt9
         YX3HSeW/daD7VmSka3fkxIspGfQcoKIkkGHh7X3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 5.10 113/152] dump_common_audit_data(): fix racy accesses to ->d_name
Date:   Mon, 18 Jan 2021 12:34:48 +0100
Message-Id: <20210118113358.146724921@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
@@ -278,7 +278,9 @@ static void dump_common_audit_data(struc
 		struct inode *inode;
 
 		audit_log_format(ab, " name=");
+		spin_lock(&a->u.dentry->d_lock);
 		audit_log_untrustedstring(ab, a->u.dentry->d_name.name);
+		spin_unlock(&a->u.dentry->d_lock);
 
 		inode = d_backing_inode(a->u.dentry);
 		if (inode) {
@@ -297,8 +299,9 @@ static void dump_common_audit_data(struc
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


