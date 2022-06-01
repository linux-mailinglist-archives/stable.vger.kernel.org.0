Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6040653A76A
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354048AbiFAOBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354110AbiFAN7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:59:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6EBA207E;
        Wed,  1 Jun 2022 06:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB87A6160E;
        Wed,  1 Jun 2022 13:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6F1C3411E;
        Wed,  1 Jun 2022 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091774;
        bh=N3kTbKDGhwPcAfEWlQX4qmpBTCC5UMNdyrw/bUyv9r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OthGHI4g6zkm37uqh/sV4DjKevPfdX4XizvZu2/ZsZdc5T4e9y7o3iNSQCMC0w7Y1
         a9ASBIMaHcHTo4cABWGx+4/Zsmr2t2uQ4pIKRuc8D179nseeUVfKsW+qy3tmqLZnS8
         RrVvkXYYlmtNjCesSj+UoA5Y15jKsyWFE2PepVyRldMWkEjIN9LXrJS2iGk65VEF3l
         zW/cDsmzI32A6WVRYtIv9Soj4Nhp223t4Mo7H7FZYNEg10e/co7+cM7vyUICL4ZMJR
         4xTn0Qi7Yru5GIqhNfWp4VfyuL53XgrYpoxvvjMOD8xiN3nNpMhjJ5k7sYegPlHEPh
         N1DzIH756bblA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.17 44/48] smb3: check for null tcon
Date:   Wed,  1 Jun 2022 09:54:17 -0400
Message-Id: <20220601135421.2003328-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
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
index 13080d6a140b..584b78d88db6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -757,8 +757,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -776,6 +776,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (tcon->nohandlecache)
 		return -ENOTSUPP;
 
+	ses = tcon->ses;
+	server = ses->server;
+
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
 
-- 
2.35.1

