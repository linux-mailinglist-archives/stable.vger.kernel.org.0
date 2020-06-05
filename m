Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A3E1EFA8D
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgFEOSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgFEOSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1502086A;
        Fri,  5 Jun 2020 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366719;
        bh=prOMc/RStpaK3YUH4KzHyr5ESVXotKLWP1/xmvu8a7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n69pkJ77yeQXmJ60SjfnFp//PA6Vik0r0AKKc72PfZkkv2DYlqT5G6LKT31BfaYDG
         zqUFMsjQTrfrI3yEfnRf2A1V0YNPP+/Qb9Zmd+lGoGqSMFqTfYTIISamd2SSUT32TU
         NnrUakBlicuFSvDRl59l6+w4spW9W16toKDqOVrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/38] evm: Fix RCU list related warnings
Date:   Fri,  5 Jun 2020 16:15:09 +0200
Message-Id: <20200605140254.133441606@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 770f60586d2af0590be263f55fd079226313922c ]

This patch fixes the following warning and few other instances of
traversal of evm_config_xattrnames list:

[   32.848432] =============================
[   32.848707] WARNING: suspicious RCU usage
[   32.848966] 5.7.0-rc1-00006-ga8d5875ce5f0b #1 Not tainted
[   32.849308] -----------------------------
[   32.849567] security/integrity/evm/evm_main.c:231 RCU-list traversed in non-reader section!!

Since entries are only added to the list and never deleted, use
list_for_each_entry_lockless() instead of list_for_each_entry_rcu for
traversing the list.  Also, add a relevant comment in evm_secfs.c to
indicate this fact.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org> (RCU viewpoint)
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 2 +-
 security/integrity/evm/evm_main.c   | 4 ++--
 security/integrity/evm/evm_secfs.c  | 9 ++++++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index cc826c2767a3..fbc2ee6d46fc 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -209,7 +209,7 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 	data->hdr.length = crypto_shash_digestsize(desc->tfm);
 
 	error = -ENODATA;
-	list_for_each_entry_rcu(xattr, &evm_config_xattrnames, list) {
+	list_for_each_entry_lockless(xattr, &evm_config_xattrnames, list) {
 		bool is_ima = false;
 
 		if (strcmp(xattr->name, XATTR_NAME_IMA) == 0)
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index f9a81b187fae..a2c393385db0 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -99,7 +99,7 @@ static int evm_find_protected_xattrs(struct dentry *dentry)
 	if (!(inode->i_opflags & IOP_XATTR))
 		return -EOPNOTSUPP;
 
-	list_for_each_entry_rcu(xattr, &evm_config_xattrnames, list) {
+	list_for_each_entry_lockless(xattr, &evm_config_xattrnames, list) {
 		error = __vfs_getxattr(dentry, inode, xattr->name, NULL, 0);
 		if (error < 0) {
 			if (error == -ENODATA)
@@ -230,7 +230,7 @@ static int evm_protected_xattr(const char *req_xattr_name)
 	struct xattr_list *xattr;
 
 	namelen = strlen(req_xattr_name);
-	list_for_each_entry_rcu(xattr, &evm_config_xattrnames, list) {
+	list_for_each_entry_lockless(xattr, &evm_config_xattrnames, list) {
 		if ((strlen(xattr->name) == namelen)
 		    && (strncmp(req_xattr_name, xattr->name, namelen) == 0)) {
 			found = 1;
diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
index c11c1f7b3ddd..0f37ef27268d 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -234,7 +234,14 @@ static ssize_t evm_write_xattrs(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	/* Guard against races in evm_read_xattrs */
+	/*
+	 * xattr_list_mutex guards against races in evm_read_xattrs().
+	 * Entries are only added to the evm_config_xattrnames list
+	 * and never deleted. Therefore, the list is traversed
+	 * using list_for_each_entry_lockless() without holding
+	 * the mutex in evm_calc_hmac_or_hash(), evm_find_protected_xattrs()
+	 * and evm_protected_xattr().
+	 */
 	mutex_lock(&xattr_list_mutex);
 	list_for_each_entry(tmp, &evm_config_xattrnames, list) {
 		if (strcmp(xattr->name, tmp->name) == 0) {
-- 
2.25.1



