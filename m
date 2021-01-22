Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535D4300D3B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbhAVT7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbhAVORg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E30B23A6A;
        Fri, 22 Jan 2021 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324825;
        bh=LRsymFWRyAlciZDqiRWK/ntSKv42t36TUPbsZRWPdvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7c4Eje1we7tgQMuVqewxCVJZ3YXHCYmf+yNa42wLhJD/GZPwDfiW+mEmUC4hhSPZ
         yEqvDoSoOkRuHprz9RA/w54o420pYdmgB4XyGeZhsT8MV7DyteFN+o7YaNMEAe0kTE
         mWUEK4Xzw2Mu5wiPitUHhviI7sJuDmCSNCBWXyyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 4.14 20/50] dump_common_audit_data(): fix racy accesses to ->d_name
Date:   Fri, 22 Jan 2021 15:12:01 +0100
Message-Id: <20210122135736.006725726@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
@@ -277,7 +277,9 @@ static void dump_common_audit_data(struc
 		struct inode *inode;
 
 		audit_log_format(ab, " name=");
+		spin_lock(&a->u.dentry->d_lock);
 		audit_log_untrustedstring(ab, a->u.dentry->d_name.name);
+		spin_unlock(&a->u.dentry->d_lock);
 
 		inode = d_backing_inode(a->u.dentry);
 		if (inode) {
@@ -295,8 +297,9 @@ static void dump_common_audit_data(struc
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


