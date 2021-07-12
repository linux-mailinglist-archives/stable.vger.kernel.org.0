Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751B13C4BF0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbhGLHAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242680AbhGLHAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F6761156;
        Mon, 12 Jul 2021 06:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073053;
        bh=qS50egKAp8vEr3qpIuMYt0weiZiMDCcr9XlfK1nfdTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TX66cKIPLv6zab7tfveSGefynVmbnXl68PE6kePuAT0CqCb1V+FgeHwmGgcaY3Wcy
         Sf2hc/+91Grc2g1cLv4smLVhP1y2+0WQV/7GJpj6CtRHUeniXZH5MKK6NcuO92bFIl
         KW+/CG9hJPLw9NszIG345OzCXTEYYYlRBhqEqiec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.12 110/700] evm: Execute evm_inode_init_security() only when an HMAC key is loaded
Date:   Mon, 12 Jul 2021 08:03:13 +0200
Message-Id: <20210712060940.336064840@linuxfoundation.org>
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

commit 9eea2904292c2d8fa98df141d3bf7c41ec9dc1b5 upstream.

evm_inode_init_security() requires an HMAC key to calculate the HMAC on
initial xattrs provided by LSMs. However, it checks generically whether a
key has been loaded, including also public keys, which is not correct as
public keys are not suitable to calculate the HMAC.

Originally, support for signature verification was introduced to verify a
possibly immutable initial ram disk, when no new files are created, and to
switch to HMAC for the root filesystem. By that time, an HMAC key should
have been loaded and usable to calculate HMACs for new files.

More recently support for requiring an HMAC key was removed from the
kernel, so that signature verification can be used alone. Since this is a
legitimate use case, evm_inode_init_security() should not return an error
when no HMAC key has been loaded.

This patch fixes this problem by replacing the evm_key_loaded() check with
a check of the EVM_INIT_HMAC flag in evm_initialized.

Fixes: 26ddabfe96b ("evm: enable EVM when X509 certificate is loaded")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org # 4.5.x
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/evm/evm_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -521,7 +521,7 @@ void evm_inode_post_setattr(struct dentr
 }
 
 /*
- * evm_inode_init_security - initializes security.evm
+ * evm_inode_init_security - initializes security.evm HMAC value
  */
 int evm_inode_init_security(struct inode *inode,
 				 const struct xattr *lsm_xattr,
@@ -530,7 +530,8 @@ int evm_inode_init_security(struct inode
 	struct evm_xattr *xattr_data;
 	int rc;
 
-	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
+	if (!(evm_initialized & EVM_INIT_HMAC) ||
+	    !evm_protected_xattr(lsm_xattr->name))
 		return 0;
 
 	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);


