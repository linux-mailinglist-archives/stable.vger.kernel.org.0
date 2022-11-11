Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4299D625097
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiKKChC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiKKCgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D936712E;
        Thu, 10 Nov 2022 18:35:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C974ECE233A;
        Fri, 11 Nov 2022 02:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096A4C433D6;
        Fri, 11 Nov 2022 02:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134111;
        bh=Yh3GWewTiJAao22kbAdeSrVnIOJgI12zbV4o+ZkNclM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRdQMT7R5rAWvNWcqqURsHg3gSPJDqGszrcEIeti6pdppbG4UypqzFlegwO2Q1mNn
         rt3d6N7fPpk+zJi3RxDVAa1JjIEMRDOXOrYnZhyQefJJNeRzp2nwJyKIxTV1R3tpPU
         WGQYpd1TfCEMMQBQfK1p76yEdrflobATv5KwrQ6cws4aPjYRK+AryJEPvdBVIz1+1X
         gvGWjhPf3ObsgsUPBHcLtszEKBa5lgctsD/pNe0Bc0NtSrbOmst4JbwYhScs42LZzq
         MD5xiF/RVkNR2dCHbe/r8eUm0EcasOmZ8sSRPuwBDEp4KitBBAwWtnvvxGTnDAQlDU
         WPDRlt2sAxWhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.0 30/30] cifs: always iterate smb sessions using primary channel
Date:   Thu, 10 Nov 2022 21:33:38 -0500
Message-Id: <20221111023340.227279-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 8abcaeaed38109e5ccaf40218e0e9e387f07bfe6 ]

smb sessions and tcons currently hang off primary channel only.
Secondary channels have the lists as empty. Whenever there's a
need to iterate sessions or tcons, we should use the list in the
corresponding primary channel.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/misc.c          |  6 +++++-
 fs/cifs/smb2misc.c      | 12 ++++++++++--
 fs/cifs/smb2ops.c       |  6 +++++-
 fs/cifs/smb2transport.c |  6 +++++-
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 87f60f736731..35085fa86636 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -400,6 +400,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 {
 	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct smb_com_lock_req *pSMB = (struct smb_com_lock_req *)buf;
+	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *pCifsInode;
@@ -464,9 +465,12 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	if (!(pSMB->LockType & LOCKING_ANDX_OPLOCK_RELEASE))
 		return false;
 
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(srv) ? srv->primary_server : srv;
+
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &srv->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid != buf->Tid)
 				continue;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d73e5672aac4..3bcd3ac65dc1 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -135,6 +135,7 @@ static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
 int
 smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 {
+	struct TCP_Server_Info *pserver;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct smb2_pdu *pdu = (struct smb2_pdu *)shdr;
 	int hdr_size = sizeof(struct smb2_hdr);
@@ -143,6 +144,9 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 	__u32 calc_len; /* calculated length */
 	__u64 mid;
 
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
 	/*
 	 * Add function to do table lookup of StructureSize by command
 	 * ie Validate the wct via smb2_struct_sizes table above
@@ -155,7 +159,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(iter, &server->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(iter, &pserver->smb_ses_list, smb_ses_list) {
 			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
 				ses = iter;
 				break;
@@ -671,6 +675,7 @@ bool
 smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 {
 	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
+	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode;
@@ -691,9 +696,12 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "oplock level 0x%x\n", rsp->OplockLevel);
 
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 
 			spin_lock(&tcon->open_file_lock);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 14376437187a..c258a7b122b6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2288,14 +2288,18 @@ static void
 smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
+	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 
 	if (shdr->Status != STATUS_NETWORK_NAME_DELETED)
 		return;
 
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				spin_lock(&tcon->tc_lock);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 4640fc4a8b13..da85cfd7803b 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -140,9 +140,13 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 static struct cifs_ses *
 smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
 {
+	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		if (ses->Suid != ses_id)
 			continue;
 		++ses->ses_count;
-- 
2.35.1

