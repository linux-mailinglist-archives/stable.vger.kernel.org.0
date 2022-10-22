Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2CD60870C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiJVHz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiJVHyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FAC66F33;
        Sat, 22 Oct 2022 00:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EACE460B45;
        Sat, 22 Oct 2022 07:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0531EC433B5;
        Sat, 22 Oct 2022 07:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424402;
        bh=6eiZPDlPDFL9lPpruiqEd6DS7gA4Z9UNc9hLlk9WAvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltPkDYxy8d00zeFpLfTolBhw0JMDIGxsrVY8bvdV69fBCPVmimLZLvQHnPm7HdKI8
         A3Xc4sNKTuEHJPjpdzsCbrs6rQl+tpCy5xB9CbhWf6l6sNr5d2cFtK+GzfBnN3LwYj
         fLxKa55HER9GpkZ0rb/1JN/fHgQFFKE/7ZOnfSL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 101/717] smb3: do not log confusing message when server returns no network interfaces
Date:   Sat, 22 Oct 2022 09:19:40 +0200
Message-Id: <20221022072433.276045308@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 4659f01e3cd94f64d9bd06764ace2ef8fe1b6227 upstream.

Some servers can return an empty network interface list so, unless
multichannel is requested, no need to log an error for this, and
when multichannel is requested on mount but no interfaces, log
something less confusing.  For this case change
   parse_server_interfaces: malformed interface info
to
   empty network interface list returned by server localhost

Also do not relog this error every ten minutes (only log on mount, once)

Cc: <stable@vger.kernel.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/connect.c   |    2 +-
 fs/cifs/smb2ops.c   |   23 ++++++++++++++++++-----
 3 files changed, 20 insertions(+), 7 deletions(-)

--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -642,7 +642,7 @@ cifs_chan_is_iface_active(struct cifs_se
 int
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int
-SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon);
+SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_mount);
 
 void extract_unc_hostname(const char *unc, const char **h, size_t *len);
 int copy_path_name(char *dst, const char *src);
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -155,7 +155,7 @@ static void smb2_query_server_interfaces
 	/*
 	 * query server network interfaces, in case they change
 	 */
-	rc = SMB3_request_interfaces(0, tcon);
+	rc = SMB3_request_interfaces(0, tcon, false);
 	if (rc) {
 		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				__func__, rc);
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -511,8 +511,7 @@ smb3_negotiate_rsize(struct cifs_tcon *t
 
 static int
 parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
-			size_t buf_len,
-			struct cifs_ses *ses)
+			size_t buf_len, struct cifs_ses *ses, bool in_mount)
 {
 	struct network_interface_info_ioctl_rsp *p;
 	struct sockaddr_in *addr4;
@@ -542,6 +541,20 @@ parse_server_interfaces(struct network_i
 	}
 	spin_unlock(&ses->iface_lock);
 
+	/*
+	 * Samba server e.g. can return an empty interface list in some cases,
+	 * which would only be a problem if we were requesting multichannel
+	 */
+	if (bytes_left == 0) {
+		/* avoid spamming logs every 10 minutes, so log only in mount */
+		if ((ses->chan_max > 1) && in_mount)
+			cifs_dbg(VFS,
+				 "empty network interface list returned by server %s\n",
+				 ses->server->hostname);
+		rc = -EINVAL;
+		goto out;
+	}
+
 	while (bytes_left >= sizeof(*p)) {
 		memset(&tmp_iface, 0, sizeof(tmp_iface));
 		tmp_iface.speed = le64_to_cpu(p->LinkSpeed);
@@ -672,7 +685,7 @@ out:
 }
 
 int
-SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
+SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_mount)
 {
 	int rc;
 	unsigned int ret_data_len = 0;
@@ -692,7 +705,7 @@ SMB3_request_interfaces(const unsigned i
 		goto out;
 	}
 
-	rc = parse_server_interfaces(out_buf, ret_data_len, ses);
+	rc = parse_server_interfaces(out_buf, ret_data_len, ses, in_mount);
 	if (rc)
 		goto out;
 
@@ -1022,7 +1035,7 @@ smb3_qfs_tcon(const unsigned int xid, st
 	if (rc)
 		return;
 
-	SMB3_request_interfaces(xid, tcon);
+	SMB3_request_interfaces(xid, tcon, true /* called during  mount */);
 
 	SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
 			FS_ATTRIBUTE_INFORMATION);


