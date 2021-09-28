Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E7A41A7C5
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbhI1F7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239097AbhI1F6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30F996134F;
        Tue, 28 Sep 2021 05:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808595;
        bh=crqvBOsxyoY5DzoUVWd4iR+3mgG1KyOOOtX4Z+Mn0zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iC1TXuGYYV76tE3zy7GqjBHsmdKP3v1X+9pWUFu8MScwGwH8KReIgj2NuBoAwvwG+
         Uozij6nQpMRmlpDVuYDpL6CGH77q6IY0Xq6qUGBLDf9MjYNZC5KHMCiBhDL9o2NkFj
         S3PGR+XPEPuivqclUDRL8nfWqO6B7gmTDXFmJdynF6olJvVA5cq633AeaL+0bl9M7F
         7HAkoW3TncMuaPIu7AvuKZZuFr9YWjky32Ml35gqgcsjCx0dl3oYdTlf2VCwyIWSNQ
         szgbz31Ytdl0uDBx486OrVUJvRjiloOyEpzwk1dPPyrO9rLgJNTKknMoFGegOs3heN
         mr1GkXwfX3jJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.14 35/40] smb3: correct smb3 ACL security descriptor
Date:   Tue, 28 Sep 2021 01:55:19 -0400
Message-Id: <20210928055524.172051-35-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

