Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CE635BF34
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239622AbhDLJDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239841AbhDLJB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0091261352;
        Mon, 12 Apr 2021 08:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217975;
        bh=rIfBsSWBp2hokukKdB/kDmnPN6eSBqY7QD82IhB0D3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0juz90fTS4J4Knbge4I8LG9mmMA44ctC+8DOHbGjCPoDuQhm56VAz3UOBg61wdujc
         ni+R6Q02yORSuAuGUoGJkLF6OEKXbkofk0lP9hr0BoGvmYW6lZPKC2hPcuenEU6g4W
         RqmcIOYHw+klyEjvqSOUAizoqeGbM1VsEMROBB+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 026/210] cifs: On cifs_reconnect, resolve the hostname again.
Date:   Mon, 12 Apr 2021 10:38:51 +0200
Message-Id: <20210412084016.880086689@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 4e456b30f78c429b183db420e23b26cde7e03a78 upstream.

On cifs_reconnect, make sure that DNS resolution happens again.
It could be the cause of connection to go dead in the first place.

This also contains the fix for a build issue identified by Intel bot.
Reported-by: kernel test robot <lkp@intel.com>

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: <stable@vger.kernel.org> # 5.11+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/Kconfig   |    3 +--
 fs/cifs/Makefile  |    5 +++--
 fs/cifs/connect.c |   17 ++++++++++++++++-
 3 files changed, 20 insertions(+), 5 deletions(-)

--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -18,6 +18,7 @@ config CIFS
 	select CRYPTO_AES
 	select CRYPTO_LIB_DES
 	select KEYS
+	select DNS_RESOLVER
 	help
 	  This is the client VFS module for the SMB3 family of NAS protocols,
 	  (including support for the most recent, most secure dialect SMB3.1.1)
@@ -112,7 +113,6 @@ config CIFS_WEAK_PW_HASH
 config CIFS_UPCALL
 	bool "Kerberos/SPNEGO advanced session setup"
 	depends on CIFS
-	select DNS_RESOLVER
 	help
 	  Enables an upcall mechanism for CIFS which accesses userspace helper
 	  utilities to provide SPNEGO packaged (RFC 4178) Kerberos tickets
@@ -179,7 +179,6 @@ config CIFS_DEBUG_DUMP_KEYS
 config CIFS_DFS_UPCALL
 	bool "DFS feature support"
 	depends on CIFS
-	select DNS_RESOLVER
 	help
 	  Distributed File System (DFS) support is used to access shares
 	  transparently in an enterprise name space, even if the share
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -10,13 +10,14 @@ cifs-y := trace.o cifsfs.o cifssmb.o cif
 	  cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o smb1ops.o unc.o winucase.o \
 	  smb2ops.o smb2maperror.o smb2transport.o \
-	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o
+	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
+	  dns_resolve.o
 
 cifs-$(CONFIG_CIFS_XATTR) += xattr.o
 
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 
-cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o dfs_cache.o
+cifs-$(CONFIG_CIFS_DFS_UPCALL) += cifs_dfs_ref.o dfs_cache.o
 
 cifs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o cifs_swn.o
 
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -87,7 +87,6 @@ static void cifs_prune_tlinks(struct wor
  *
  * This should be called with server->srv_mutex held.
  */
-#ifdef CONFIG_CIFS_DFS_UPCALL
 static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 {
 	int rc;
@@ -124,6 +123,7 @@ static int reconn_set_ipaddr_from_hostna
 	return !rc ? -1 : 0;
 }
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
 /* These functions must be called with server->srv_mutex held */
 static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
 				       struct cifs_sb_info *cifs_sb,
@@ -321,14 +321,29 @@ cifs_reconnect(struct TCP_Server_Info *s
 #endif
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
+		if (cifs_sb && cifs_sb->origin_fullpath)
 			/*
 			 * Set up next DFS target server (if any) for reconnect. If DFS
 			 * feature is disabled, then we will retry last server we
 			 * connected to before.
 			 */
 			reconn_set_next_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
+		else {
+#endif
+			/*
+			 * Resolve the hostname again to make sure that IP address is up-to-date.
+			 */
+			rc = reconn_set_ipaddr_from_hostname(server);
+			if (rc) {
+				cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
+						__func__, rc);
+			}
+
+#ifdef CONFIG_CIFS_DFS_UPCALL
+		}
 #endif
 
+
 #ifdef CONFIG_CIFS_SWN_UPCALL
 		}
 #endif


