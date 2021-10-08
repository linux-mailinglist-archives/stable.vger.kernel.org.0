Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62A4269B2
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241550AbhJHLkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243247AbhJHLjG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:39:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABBF1615A7;
        Fri,  8 Oct 2021 11:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692795;
        bh=crqvBOsxyoY5DzoUVWd4iR+3mgG1KyOOOtX4Z+Mn0zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0w+4MKM8kXiuPG5p+EZ7aqFpsbk6K6CAwDjmEZaj0+jrhkkLEFKiWJERc9q/5wj6
         30erpuK54UH41LvL3x1GmeaqF8r0xMGCbrB+BFBi2BE1dpSMcN6hIINoZEafka35s4
         /MtS81+sCOHTiZitWkanmVaNkFur6P+KEC27xJeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 34/48] smb3: correct smb3 ACL security descriptor
Date:   Fri,  8 Oct 2021 13:28:10 +0200
Message-Id: <20211008112721.157308399@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit b06d893ef2492245d0319b4136edb4c346b687a3 ]

Address warning:

        fs/smbfs_client/smb2pdu.c:2425 create_sd_buf()
        warn: struct type mismatch 'smb3_acl vs cifs_acl'

Pointed out by Dan Carpenter via smatch code analysis tool

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b6d2e3591927..e1739d0135b4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2398,7 +2398,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
 	buf->sd.OffsetDacl = cpu_to_le32(ptr - (__u8 *)&buf->sd);
 	/* Ship the ACL for now. we will copy it into buf later. */
 	aclptr = ptr;
-	ptr += sizeof(struct cifs_acl);
+	ptr += sizeof(struct smb3_acl);
 
 	/* create one ACE to hold the mode embedded in reserved special SID */
 	acelen = setup_special_mode_ACE((struct cifs_ace *)ptr, (__u64)mode);
@@ -2423,7 +2423,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
 	acl.AclRevision = ACL_REVISION; /* See 2.4.4.1 of MS-DTYP */
 	acl.AclSize = cpu_to_le16(acl_size);
 	acl.AceCount = cpu_to_le16(ace_count);
-	memcpy(aclptr, &acl, sizeof(struct cifs_acl));
+	memcpy(aclptr, &acl, sizeof(struct smb3_acl));
 
 	buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);
 	*len = roundup(ptr - (__u8 *)buf, 8);
-- 
2.33.0



