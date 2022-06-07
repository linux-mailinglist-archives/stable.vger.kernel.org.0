Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D47B540CCA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353515AbiFGSlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344908AbiFGSja (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DF1185C84;
        Tue,  7 Jun 2022 10:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01274618A8;
        Tue,  7 Jun 2022 17:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9C0C3411C;
        Tue,  7 Jun 2022 17:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624701;
        bh=x3aKltvJCExcuE8Cf1wal8MKtjt6setOO/0CitLWLDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhXdSMJORquDm3sS6EIW2SpsEUZuWotm9l4CrU33fp50Y2CZ/NhFaFsCD3CTQPCBe
         V+6TDu8AIME6IzCdJk7ZiGA60n1GGh3K9yTkxawrAV6Zbc7pQdJkIdmFysmRt4zbKN
         hk8WiWKDWLHP3JNOLiNj8w8bm66ajCk8vWCaE1RFs02InCh8BETJcwdeHZwb1qaHFu
         WOJx/RTjmchwPFMMpLIY2+MDKzBE7qnkRxJcYzpHi5lshs1VGxG6Iq4ExX7xPfI5hW
         DL9jyCD0726cOc3DaEMp/mgH3DML3A2A02jIOCGLi9+PbRQwSBby67aC7czUd4jqc0
         Suu8pLD02zxmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 49/51] cifs: version operations for smb20 unneeded when legacy support disabled
Date:   Tue,  7 Jun 2022 13:55:48 -0400
Message-Id: <20220607175552.479948-49-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 7ef93ffccd55fb0ba000ed16ef6a81cd7dee07b5 ]

We should not be including unused smb20 specific code when legacy
support is disabled (CONFIG_CIFS_ALLOW_INSECURE_LEGACY turned
off).  For example smb2_operations and smb2_values aren't used
in that case.  Over time we can move more and more SMB1/CIFS and SMB2.0
code into the insecure legacy ifdefs

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h | 4 +++-
 fs/cifs/smb2ops.c  | 7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b33835b2943e..a97ed30843cf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1890,11 +1890,13 @@ extern mempool_t *cifs_mid_poolp;
 
 /* Operations for different SMB versions */
 #define SMB1_VERSION_STRING	"1.0"
+#define SMB20_VERSION_STRING    "2.0"
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
-#define SMB20_VERSION_STRING	"2.0"
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
+#endif /* CIFS_ALLOW_INSECURE_LEGACY */
 #define SMB21_VERSION_STRING	"2.1"
 extern struct smb_version_operations smb21_operations;
 extern struct smb_version_values smb21_values;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0c1af2dd9069..b5d4092730ba 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4268,11 +4268,13 @@ smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 	}
 }
 
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 static bool
 smb2_is_read_op(__u32 oplock)
 {
 	return oplock == SMB2_OPLOCK_LEVEL_II;
 }
+#endif /* CIFS_ALLOW_INSECURE_LEGACY */
 
 static bool
 smb21_is_read_op(__u32 oplock)
@@ -5368,7 +5370,7 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
-
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -5467,6 +5469,7 @@ struct smb_version_operations smb20_operations = {
 	.is_status_io_timeout = smb2_is_status_io_timeout,
 	.is_network_name_deleted = smb2_is_network_name_deleted,
 };
+#endif /* CIFS_ALLOW_INSECURE_LEGACY */
 
 struct smb_version_operations smb21_operations = {
 	.compare_fids = smb2_compare_fids,
@@ -5798,6 +5801,7 @@ struct smb_version_operations smb311_operations = {
 	.is_network_name_deleted = smb2_is_network_name_deleted,
 };
 
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_version_values smb20_values = {
 	.version_string = SMB20_VERSION_STRING,
 	.protocol_id = SMB20_PROT_ID,
@@ -5818,6 +5822,7 @@ struct smb_version_values smb20_values = {
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.create_lease_size = sizeof(struct create_lease),
 };
+#endif /* ALLOW_INSECURE_LEGACY */
 
 struct smb_version_values smb21_values = {
 	.version_string = SMB21_VERSION_STRING,
-- 
2.35.1

