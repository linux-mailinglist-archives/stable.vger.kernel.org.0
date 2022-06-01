Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FD753A6E3
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353854AbiFAN4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353794AbiFANz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B828E1BE;
        Wed,  1 Jun 2022 06:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDE8AB81806;
        Wed,  1 Jun 2022 13:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2943C385B8;
        Wed,  1 Jun 2022 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091652;
        bh=33xmMUUu2yyaxwek5Otu/Ihv7PjXK0y8lP29hOMLgw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7Erp5BaM8BnmElMsSyDgYPWnRAylHRBvovENPpMy9I0m3rDIIr8PqorI2KFUuQzI
         NB9kn+lHepVg4zbj4BLYXwavllpRkGhcvZnERwQ1ifdqVvCAdQRMAiPQId7LFiAd8r
         a3TX4LexxlmCPKDDPBbvGrfDaJLe2n8/K/AoLObKEb0qIlzlXgL1M9/Ll1Cgcm8b7f
         vTaH6txVCAr2KXRHVlJWi70O69yxoq4XndVSvDi4Unl+T0iFXroXzfgNL5O8ppmntt
         26KCY3bmX5b/v/VKc64Bq4GstYQ98aI/sWqDalcHdT2jjn9icc1iZUQpcWsXYpwpY+
         wqTahwb98lIrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.18 45/49] smb3: check for null tcon
Date:   Wed,  1 Jun 2022 09:52:09 -0400
Message-Id: <20220601135214.2002647-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit bbdf6cf56c88845fb0b713cbf5c6623c53fe40d8 ]

Although unlikely to be null, it is confusing to use a pointer
before checking for it to be null so move the use down after
null check.

Addresses-Coverity: 1517586 ("Null pointer dereferences  (REVERSE_INULL)")
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d6aaeff4a30a..16aeb37636e5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -760,8 +760,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		struct cifs_sb_info *cifs_sb,
 		struct cached_fid **cfid)
 {
-	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = ses->server;
+	struct cifs_ses *ses;
+	struct TCP_Server_Info *server;
 	struct cifs_open_parms oparms;
 	struct smb2_create_rsp *o_rsp = NULL;
 	struct smb2_query_info_rsp *qi_rsp = NULL;
@@ -779,6 +779,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (tcon->nohandlecache)
 		return -ENOTSUPP;
 
+	ses = tcon->ses;
+	server = ses->server;
+
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
 
-- 
2.35.1

