Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77892E66C7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgL1NRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731528AbgL1NRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:17:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10B89207CF;
        Mon, 28 Dec 2020 13:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161420;
        bh=jtUNsOUZ5vABG6kent2Hwsx8WvaniRysXjh/JP2XXyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A//vHyDZwcHyUgA5DHAQIoB5yT1vaUOW2YCeC22fblWRR4GZ2VQmuOtQ5jygspSWJ
         lj1cFJSX6X0dxhxCV7YJpHHKsNi2xmmH8xR1LVcdyovPEmD3ahxivAUAE0ts5kR6ha
         HSjt8Qa88wY1hqTBAdz+e7uouqeFH00LUotgtm+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Herv=C3=A9=20Guillemet?= <herve@guillemet.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Serge Hallyn <shallyn@cisco.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        James Morris <jamorris@linux.microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 178/242] [SECURITY] fix namespaced fscaps when !CONFIG_SECURITY
Date:   Mon, 28 Dec 2020 13:49:43 +0100
Message-Id: <20201228124913.445936891@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Hallyn <shallyn@cisco.com>

[ Upstream commit ed9b25d1970a4787ac6a39c2091e63b127ecbfc1 ]

Namespaced file capabilities were introduced in 8db6c34f1dbc .
When userspace reads an xattr for a namespaced capability, a
virtualized representation of it is returned if the caller is
in a user namespace owned by the capability's owning rootid.
The function which performs this virtualization was not hooked
up if CONFIG_SECURITY=n.  Therefore in that case the original
xattr was shown instead of the virtualized one.

To test this using libcap-bin (*1),

$ v=$(mktemp)
$ unshare -Ur setcap cap_sys_admin-eip $v
$ unshare -Ur setcap -v cap_sys_admin-eip $v
/tmp/tmp.lSiIFRvt8Y: OK

"setcap -v" verifies the values instead of setting them, and
will check whether the rootid value is set.  Therefore, with
this bug un-fixed, and with CONFIG_SECURITY=n, setcap -v will
fail:

$ v=$(mktemp)
$ unshare -Ur setcap cap_sys_admin=eip $v
$ unshare -Ur setcap -v cap_sys_admin=eip $v
nsowner[got=1000, want=0],/tmp/tmp.HHDiOOl9fY differs in []

Fix this bug by calling cap_inode_getsecurity() in
security_inode_getsecurity() instead of returning
-EOPNOTSUPP, when CONFIG_SECURITY=n.

*1 - note, if libcap is too old for getcap to have the '-n'
option, then use verify-caps instead.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=209689
Cc: Hervé Guillemet <herve@guillemet.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Serge Hallyn <shallyn@cisco.com>
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/security.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ce6265960d6c4..dab093af4ee8d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -780,7 +780,7 @@ static inline int security_inode_killpriv(struct dentry *dentry)
 
 static inline int security_inode_getsecurity(struct inode *inode, const char *name, void **buffer, bool alloc)
 {
-	return -EOPNOTSUPP;
+	return cap_inode_getsecurity(inode, name, buffer, alloc);
 }
 
 static inline int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
-- 
2.27.0



