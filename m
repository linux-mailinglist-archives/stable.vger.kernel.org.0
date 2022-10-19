Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A35C604532
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiJSMZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiJSMXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:23:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2080BCEE;
        Wed, 19 Oct 2022 04:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1EA3B822BE;
        Wed, 19 Oct 2022 08:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FB4C433D6;
        Wed, 19 Oct 2022 08:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169043;
        bh=nXTuNXaZwwPkGR8X7HBy7kT4bpr0qsxJ+m6iQRJt0Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJ/CgzVzmTuUGcSUJR+21W3S9vTFQ5YczvFAh3z+3KoaE7UZYSU/4X1cWsvErxNiF
         NFi8fxJeelXW+mhR81K7OnW9wuPo1RbJr4jGKUm1o9jCMv7nDu1ihJic9wc+FEAaw6
         LCFDROB4fddIN5p/dy0ohj0ocxixHl5eWsoBjB2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 112/862] smb3: do not log confusing message when server returns no network interfaces
Date:   Wed, 19 Oct 2022 10:23:19 +0200
Message-Id: <20221019083254.876455274@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -639,7 +639,7 @@ cifs_chan_is_iface_active(struct cifs_se
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
@@ -512,8 +512,7 @@ smb3_negotiate_rsize(struct cifs_tcon *t
 
 static int
 parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
-			size_t buf_len,
-			struct cifs_ses *ses)
+			size_t buf_len, struct cifs_ses *ses, bool in_mount)
 {
 	struct network_interface_info_ioctl_rsp *p;
 	struct sockaddr_in *addr4;
@@ -543,6 +542,20 @@ parse_server_interfaces(struct network_i
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
@@ -673,7 +686,7 @@ out:
 }
 
 int
-SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
+SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_mount)
 {
 	int rc;
 	unsigned int ret_data_len = 0;
@@ -693,7 +706,7 @@ SMB3_request_interfaces(const unsigned i
 		goto out;
 	}
 
-	rc = parse_server_interfaces(out_buf, ret_data_len, ses);
+	rc = parse_server_interfaces(out_buf, ret_data_len, ses, in_mount);
 	if (rc)
 		goto out;
 
@@ -729,7 +742,7 @@ smb3_qfs_tcon(const unsigned int xid, st
 	if (rc)
 		return;
 
-	SMB3_request_interfaces(xid, tcon);
+	SMB3_request_interfaces(xid, tcon, true /* called during  mount */);
 
 	SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
 			FS_ATTRIBUTE_INFORMATION);


