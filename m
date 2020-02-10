Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FF8157824
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgBJNF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728759AbgBJMkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:01 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC6F208C4;
        Mon, 10 Feb 2020 12:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338401;
        bh=pcYjza1vJD3GTXeNK0U17dkKSU+/KESF8oYozpwbETc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0eTCOBN7bS28Jhi6WQ2eOULIcUxfvxY4734JiLAO89fxb26L4r3eUnRhC/26qm/M
         o6fno4jcOadSryYO5Er+X9T7UH+gmL9zp7nwoZkl1LHvWfTko+TdphYEV7MjEn3Ugt
         khm+uA8zTrfaNVQgLuNgWC65Fbl8YsBqYiY1JwuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.5 099/367] smb3: fix default permissions on new files when mounting with modefromsid
Date:   Mon, 10 Feb 2020 04:30:12 -0800
Message-Id: <20200210122433.511214096@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 643fbceef48e5b22bf8e0905f903e908b5d2ba69 upstream.

When mounting with "modefromsid" mount parm most servers will require
that some default permissions are given to users in the ACL on newly
created files, files created with the new 'sd context' - when passing in
an sd context on create, permissions are not inherited from the parent
directory, so in addition to the ACE with the special SID which contains
the mode, we also must pass in an ACE allowing users to access the file
(GENERIC_ALL for authenticated users seemed like a reasonable default,
although later we could allow a mount option or config switch to make
it GENERIC_ALL for EVERYONE special sid).

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-By: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsacl.c   |   20 ++++++++++++++++++++
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/smb2pdu.c   |   11 ++++++++---
 3 files changed, 29 insertions(+), 3 deletions(-)

--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -802,6 +802,26 @@ static void parse_dacl(struct cifs_acl *
 	return;
 }
 
+unsigned int setup_authusers_ACE(struct cifs_ace *pntace)
+{
+	int i;
+	unsigned int ace_size = 20;
+
+	pntace->type = ACCESS_ALLOWED_ACE_TYPE;
+	pntace->flags = 0x0;
+	pntace->access_req = cpu_to_le32(GENERIC_ALL);
+	pntace->sid.num_subauth = 1;
+	pntace->sid.revision = 1;
+	for (i = 0; i < NUM_AUTHS; i++)
+		pntace->sid.authority[i] =  sid_authusers.authority[i];
+
+	pntace->sid.sub_auth[0] =  sid_authusers.sub_auth[0];
+
+	/* size = 1 + 1 + 2 + 4 + 1 + 1 + 6 + (psid->num_subauth*4) */
+	pntace->size = cpu_to_le16(ace_size);
+	return ace_size;
+}
+
 /*
  * Fill in the special SID based on the mode. See
  * http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -213,6 +213,7 @@ extern struct cifs_ntsd *get_cifs_acl_by
 						const struct cifs_fid *, u32 *);
 extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
 				const char *, int);
+extern unsigned int setup_authusers_ACE(struct cifs_ace *pace);
 extern unsigned int setup_special_mode_ACE(struct cifs_ace *pace, __u64 nmode);
 
 extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2199,13 +2199,14 @@ create_sd_buf(umode_t mode, unsigned int
 	struct cifs_ace *pace;
 	unsigned int sdlen, acelen;
 
-	*len = roundup(sizeof(struct crt_sd_ctxt) + sizeof(struct cifs_ace), 8);
+	*len = roundup(sizeof(struct crt_sd_ctxt) + sizeof(struct cifs_ace) * 2,
+			8);
 	buf = kzalloc(*len, GFP_KERNEL);
 	if (buf == NULL)
 		return buf;
 
 	sdlen = sizeof(struct smb3_sd) + sizeof(struct smb3_acl) +
-		 sizeof(struct cifs_ace);
+		 2 * sizeof(struct cifs_ace);
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
 					(struct crt_sd_ctxt, sd));
@@ -2232,8 +2233,12 @@ create_sd_buf(umode_t mode, unsigned int
 	/* create one ACE to hold the mode embedded in reserved special SID */
 	pace = (struct cifs_ace *)(sizeof(struct crt_sd_ctxt) + (char *)buf);
 	acelen = setup_special_mode_ACE(pace, (__u64)mode);
+	/* and one more ACE to allow access for authenticated users */
+	pace = (struct cifs_ace *)(acelen + (sizeof(struct crt_sd_ctxt) +
+		(char *)buf));
+	acelen += setup_authusers_ACE(pace);
 	buf->acl.AclSize = cpu_to_le16(sizeof(struct cifs_acl) + acelen);
-	buf->acl.AceCount = cpu_to_le16(1);
+	buf->acl.AceCount = cpu_to_le16(2);
 	return buf;
 }
 


