Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA132D5E0E
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391138AbgLJOiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391131AbgLJOiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:06 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Rohith Surabattula <rohiths@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.9 24/75] cifs: refactor create_sd_buf() and and avoid corrupting the buffer
Date:   Thu, 10 Dec 2020 15:26:49 +0100
Message-Id: <20201210142607.242107216@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit ea64370bcae126a88cd26a16f1abcc23ab2b9a55 upstream.

When mounting with "idsfromsid" mount option, Azure
corrupted the owner SIDs due to excessive padding
caused by placing the owner fields at the end of the
security descriptor on create.  Placing owners at the
front of the security descriptor (rather than the end)
is also safer, as the number of ACEs (that follow it)
are variable.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Suggested-by: Rohith Surabattula <rohiths@microsoft.com>
CC: Stable <stable@vger.kernel.org> # v5.8
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |   69 ++++++++++++++++++++++++++++--------------------------
 fs/cifs/smb2pdu.h |    2 -
 2 files changed, 37 insertions(+), 34 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2237,17 +2237,15 @@ static struct crt_sd_ctxt *
 create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
 {
 	struct crt_sd_ctxt *buf;
-	struct cifs_ace *pace;
-	unsigned int sdlen, acelen;
+	__u8 *ptr, *aclptr;
+	unsigned int acelen, acl_size, ace_count;
 	unsigned int owner_offset = 0;
 	unsigned int group_offset = 0;
+	struct smb3_acl acl;
 
-	*len = roundup(sizeof(struct crt_sd_ctxt) + (sizeof(struct cifs_ace) * 2), 8);
+	*len = roundup(sizeof(struct crt_sd_ctxt) + (sizeof(struct cifs_ace) * 4), 8);
 
 	if (set_owner) {
-		/* offset fields are from beginning of security descriptor not of create context */
-		owner_offset = sizeof(struct smb3_acl) + (sizeof(struct cifs_ace) * 2);
-
 		/* sizeof(struct owner_group_sids) is already multiple of 8 so no need to round */
 		*len += sizeof(struct owner_group_sids);
 	}
@@ -2256,26 +2254,22 @@ create_sd_buf(umode_t mode, bool set_own
 	if (buf == NULL)
 		return buf;
 
+	ptr = (__u8 *)&buf[1];
 	if (set_owner) {
+		/* offset fields are from beginning of security descriptor not of create context */
+		owner_offset = ptr - (__u8 *)&buf->sd;
 		buf->sd.OffsetOwner = cpu_to_le32(owner_offset);
-		group_offset = owner_offset + sizeof(struct owner_sid);
+		group_offset = owner_offset + offsetof(struct owner_group_sids, group);
 		buf->sd.OffsetGroup = cpu_to_le32(group_offset);
+
+		setup_owner_group_sids(ptr);
+		ptr += sizeof(struct owner_group_sids);
 	} else {
 		buf->sd.OffsetOwner = 0;
 		buf->sd.OffsetGroup = 0;
 	}
 
-	sdlen = sizeof(struct smb3_sd) + sizeof(struct smb3_acl) +
-		 2 * sizeof(struct cifs_ace);
-	if (set_owner) {
-		sdlen += sizeof(struct owner_group_sids);
-		setup_owner_group_sids(owner_offset + sizeof(struct create_context) + 8 /* name */
-			+ (char *)buf);
-	}
-
-	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct crt_sd_ctxt, sd));
-	buf->ccontext.DataLength = cpu_to_le32(sdlen);
+	buf->ccontext.DataOffset = cpu_to_le16(offsetof(struct crt_sd_ctxt, sd));
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof(struct crt_sd_ctxt, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
 	/* SMB2_CREATE_SD_BUFFER_TOKEN is "SecD" */
@@ -2284,6 +2278,7 @@ create_sd_buf(umode_t mode, bool set_own
 	buf->Name[2] = 'c';
 	buf->Name[3] = 'D';
 	buf->sd.Revision = 1;  /* Must be one see MS-DTYP 2.4.6 */
+
 	/*
 	 * ACL is "self relative" ie ACL is stored in contiguous block of memory
 	 * and "DP" ie the DACL is present
@@ -2291,28 +2286,38 @@ create_sd_buf(umode_t mode, bool set_own
 	buf->sd.Control = cpu_to_le16(ACL_CONTROL_SR | ACL_CONTROL_DP);
 
 	/* offset owner, group and Sbz1 and SACL are all zero */
-	buf->sd.OffsetDacl = cpu_to_le32(sizeof(struct smb3_sd));
-	buf->acl.AclRevision = ACL_REVISION; /* See 2.4.4.1 of MS-DTYP */
+	buf->sd.OffsetDacl = cpu_to_le32(ptr - (__u8 *)&buf->sd);
+	/* Ship the ACL for now. we will copy it into buf later. */
+	aclptr = ptr;
+	ptr += sizeof(struct cifs_acl);
 
 	/* create one ACE to hold the mode embedded in reserved special SID */
-	pace = (struct cifs_ace *)(sizeof(struct crt_sd_ctxt) + (char *)buf);
-	acelen = setup_special_mode_ACE(pace, (__u64)mode);
+	acelen = setup_special_mode_ACE((struct cifs_ace *)ptr, (__u64)mode);
+	ptr += acelen;
+	acl_size = acelen + sizeof(struct smb3_acl);
+	ace_count = 1;
 
 	if (set_owner) {
 		/* we do not need to reallocate buffer to add the two more ACEs. plenty of space */
-		pace = (struct cifs_ace *)(acelen + (sizeof(struct crt_sd_ctxt) + (char *)buf));
-		acelen += setup_special_user_owner_ACE(pace);
-		/* it does not appear necessary to add an ACE for the NFS group SID */
-		buf->acl.AceCount = cpu_to_le16(3);
-	} else
-		buf->acl.AceCount = cpu_to_le16(2);
+		acelen = setup_special_user_owner_ACE((struct cifs_ace *)ptr);
+		ptr += acelen;
+		acl_size += acelen;
+		ace_count += 1;
+	}
 
 	/* and one more ACE to allow access for authenticated users */
-	pace = (struct cifs_ace *)(acelen + (sizeof(struct crt_sd_ctxt) +
-		(char *)buf));
-	acelen += setup_authusers_ACE(pace);
+	acelen = setup_authusers_ACE((struct cifs_ace *)ptr);
+	ptr += acelen;
+	acl_size += acelen;
+	ace_count += 1;
+
+	acl.AclRevision = ACL_REVISION; /* See 2.4.4.1 of MS-DTYP */
+	acl.AclSize = cpu_to_le16(acl_size);
+	acl.AceCount = cpu_to_le16(ace_count);
+	memcpy(aclptr, &acl, sizeof(struct cifs_acl));
 
-	buf->acl.AclSize = cpu_to_le16(sizeof(struct cifs_acl) + acelen);
+	buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);
+	*len = ptr - (__u8 *)buf;
 
 	return buf;
 }
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -900,8 +900,6 @@ struct crt_sd_ctxt {
 	struct create_context ccontext;
 	__u8	Name[8];
 	struct smb3_sd sd;
-	struct smb3_acl acl;
-	/* Followed by at least 4 ACEs */
 } __packed;
 
 


