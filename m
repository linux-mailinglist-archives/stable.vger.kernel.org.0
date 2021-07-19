Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE663CE23C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347889AbhGSP3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348135AbhGSPYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447B76144D;
        Mon, 19 Jul 2021 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710524;
        bh=J1th7C9HG/X0LcpDYWeqEFrYfzYdJkQ5/rMLUqiVnu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnsYUNCxgqcx3JxB0+i+ChknV2iEBEOPKqyhs3QrUgSB+vLG7qZqeeA/75qvsRHpo
         KpXPwIlgEA5krS0rB0as/U5Pe2vKejfbx4mCqlJNuuX1EU6Uq0gvJuOHXbiiSC57pl
         /nMQ5hEzU0QKJkJ/oGAENRvMzebbdV8CuIfdvIk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 001/351] cifs: use the expiry output of dns_query to schedule next resolution
Date:   Mon, 19 Jul 2021 16:49:07 +0200
Message-Id: <20210719144944.587174591@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 506c1da44fee32ba1d3a70413289ad58c772bba6 upstream.

We recently fixed DNS resolution of the server hostname during reconnect.
However, server IP address may change, even when the old one continues
to server (although sub-optimally).

We should schedule the next DNS resolution based on the TTL of
the DNS record used for the last resolution. This way, we resolve the
server hostname again when a DNS record expires.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_dfs_ref.c |    2 -
 fs/cifs/cifsglob.h     |    4 +++
 fs/cifs/connect.c      |   55 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/dns_resolve.c  |   10 +++++---
 fs/cifs/dns_resolve.h  |    2 -
 fs/cifs/misc.c         |    2 -
 6 files changed, 65 insertions(+), 10 deletions(-)

--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -173,7 +173,7 @@ char *cifs_compose_mount_options(const c
 		}
 	}
 
-	rc = dns_resolve_server_name_to_ip(name, &srvIP);
+	rc = dns_resolve_server_name_to_ip(name, &srvIP, NULL);
 	if (rc < 0) {
 		cifs_dbg(FYI, "%s: Failed to resolve server part of %s to IP: %d\n",
 			 __func__, name, rc);
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -84,6 +84,9 @@
 #define SMB_ECHO_INTERVAL_MAX 600
 #define SMB_ECHO_INTERVAL_DEFAULT 60
 
+/* dns resolution interval in seconds */
+#define SMB_DNS_RESOLVE_INTERVAL_DEFAULT 600
+
 /* maximum number of PDUs in one compound */
 #define MAX_COMPOUND 5
 
@@ -654,6 +657,7 @@ struct TCP_Server_Info {
 	/* point to the SMBD connection if RDMA is used instead of socket */
 	struct smbd_connection *smbd_conn;
 	struct delayed_work	echo; /* echo ping workqueue job */
+	struct delayed_work	resolve; /* dns resolution workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
 	/* Total size of this PDU. Only valid from cifs_demultiplex_thread */
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -90,6 +90,8 @@ static int reconn_set_ipaddr_from_hostna
 	int rc;
 	int len;
 	char *unc, *ipaddr = NULL;
+	time64_t expiry, now;
+	unsigned long ttl = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
 
 	if (!server->hostname)
 		return -EINVAL;
@@ -103,13 +105,13 @@ static int reconn_set_ipaddr_from_hostna
 	}
 	scnprintf(unc, len, "\\\\%s", server->hostname);
 
-	rc = dns_resolve_server_name_to_ip(unc, &ipaddr);
+	rc = dns_resolve_server_name_to_ip(unc, &ipaddr, &expiry);
 	kfree(unc);
 
 	if (rc < 0) {
 		cifs_dbg(FYI, "%s: failed to resolve server part of %s to IP: %d\n",
 			 __func__, server->hostname, rc);
-		return rc;
+		goto requeue_resolve;
 	}
 
 	spin_lock(&cifs_tcp_ses_lock);
@@ -118,7 +120,45 @@ static int reconn_set_ipaddr_from_hostna
 	spin_unlock(&cifs_tcp_ses_lock);
 	kfree(ipaddr);
 
-	return !rc ? -1 : 0;
+	/* rc == 1 means success here */
+	if (rc) {
+		now = ktime_get_real_seconds();
+		if (expiry && expiry > now)
+			/*
+			 * To make sure we don't use the cached entry, retry 1s
+			 * after expiry.
+			 */
+			ttl = (expiry - now + 1);
+	}
+	rc = !rc ? -1 : 0;
+
+requeue_resolve:
+	cifs_dbg(FYI, "%s: next dns resolution scheduled for %lu seconds in the future\n",
+		 __func__, ttl);
+	mod_delayed_work(cifsiod_wq, &server->resolve, (ttl * HZ));
+
+	return rc;
+}
+
+
+static void cifs_resolve_server(struct work_struct *work)
+{
+	int rc;
+	struct TCP_Server_Info *server = container_of(work,
+					struct TCP_Server_Info, resolve.work);
+
+	mutex_lock(&server->srv_mutex);
+
+	/*
+	 * Resolve the hostname again to make sure that IP address is up-to-date.
+	 */
+	rc = reconn_set_ipaddr_from_hostname(server);
+	if (rc) {
+		cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
+				__func__, rc);
+	}
+
+	mutex_unlock(&server->srv_mutex);
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
@@ -698,6 +738,7 @@ static void clean_demultiplex_info(struc
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	cancel_delayed_work_sync(&server->echo);
+	cancel_delayed_work_sync(&server->resolve);
 
 	spin_lock(&GlobalMid_Lock);
 	server->tcpStatus = CifsExiting;
@@ -1278,6 +1319,7 @@ cifs_put_tcp_session(struct TCP_Server_I
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	cancel_delayed_work_sync(&server->echo);
+	cancel_delayed_work_sync(&server->resolve);
 
 	if (from_reconnect)
 		/*
@@ -1360,6 +1402,7 @@ cifs_get_tcp_session(struct smb3_fs_cont
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
+	INIT_DELAYED_WORK(&tcp_ses->resolve, cifs_resolve_server);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);
 	memcpy(&tcp_ses->srcaddr, &ctx->srcaddr,
@@ -1440,6 +1483,12 @@ smbd_connected:
 	/* queue echo request delayed work */
 	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
 
+	/* queue dns resolution delayed work */
+	cifs_dbg(FYI, "%s: next dns resolution scheduled for %d seconds in the future\n",
+		 __func__, SMB_DNS_RESOLVE_INTERVAL_DEFAULT);
+
+	queue_delayed_work(cifsiod_wq, &tcp_ses->resolve, (SMB_DNS_RESOLVE_INTERVAL_DEFAULT * HZ));
+
 	return tcp_ses;
 
 out_err_crypto_release:
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -36,6 +36,7 @@
  * dns_resolve_server_name_to_ip - Resolve UNC server name to ip address.
  * @unc: UNC path specifying the server (with '/' as delimiter)
  * @ip_addr: Where to return the IP address.
+ * @expiry: Where to return the expiry time for the dns record.
  *
  * The IP address will be returned in string form, and the caller is
  * responsible for freeing it.
@@ -43,7 +44,7 @@
  * Returns length of result on success, -ve on error.
  */
 int
-dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
+dns_resolve_server_name_to_ip(const char *unc, char **ip_addr, time64_t *expiry)
 {
 	struct sockaddr_storage ss;
 	const char *hostname, *sep;
@@ -78,13 +79,14 @@ dns_resolve_server_name_to_ip(const char
 
 	/* Perform the upcall */
 	rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len,
-		       NULL, ip_addr, NULL, false);
+		       NULL, ip_addr, expiry, false);
 	if (rc < 0)
 		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
 			 __func__, len, len, hostname);
 	else
-		cifs_dbg(FYI, "%s: resolved: %*.*s to %s\n",
-			 __func__, len, len, hostname, *ip_addr);
+		cifs_dbg(FYI, "%s: resolved: %*.*s to %s expiry %llu\n",
+			 __func__, len, len, hostname, *ip_addr,
+			 expiry ? (*expiry) : 0);
 	return rc;
 
 name_is_IP_address:
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -24,7 +24,7 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
-extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
+extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr, time64_t *expiry);
 #endif /* KERNEL */
 
 #endif /* _DNS_RESOLVE_H */
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1199,7 +1199,7 @@ int match_target_ip(struct TCP_Server_In
 
 	cifs_dbg(FYI, "%s: target name: %s\n", __func__, target + 2);
 
-	rc = dns_resolve_server_name_to_ip(target, &tip);
+	rc = dns_resolve_server_name_to_ip(target, &tip, NULL);
 	if (rc < 0)
 		goto out;
 


