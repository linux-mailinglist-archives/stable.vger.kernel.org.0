Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89EB4C080A
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiBWCbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiBWCbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:31:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48F6457A5;
        Tue, 22 Feb 2022 18:29:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59C3EB81DA6;
        Wed, 23 Feb 2022 02:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41247C340EB;
        Wed, 23 Feb 2022 02:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583393;
        bh=pGLG2SOVo6AjJURheQjGN51ViP8G0Dfy41nopw84HZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxPw6J/rI7NTjoQSsEMzkNHPo+E0KSnvai27wf7GY6pFE5wqUjnIv4Jvd+Fjqv1Uf
         3ZnIowV1KkttOYzwDjeBeaXWb/j1y9ahBBBs63X6EAr3xCiY4/B7nLoC+56/bQCkHD
         QQKV6NCoMoR8FXFw2VXWZQgLscjDQiT/gs8bjynRl+c2qqOIAAFW4nujiz9+ffhxw8
         imklb0fLzS1jBsdRJ+fkPi4D000tHZ+1h9u4vBaoQdQwosikuGwNibC0KCflJNKbwc
         O65g9kFVnODeInDTP4/iX8DqetZGgSiJspNiVE5mmBiVdaJO2ZDCqVMK5XE714LsLD
         IT7QIcKI7ulQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 12/28] cifs: do not use uninitialized data in the owner/group sid
Date:   Tue, 22 Feb 2022 21:29:13 -0500
Message-Id: <20220223022929.241127-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 26d3dadebbcbddfaf1d9caad42527a28a0ed28d8 ]

When idsfromsid is used we create a special SID for owner/group.
This structure must be initialized or else the first 5 bytes
of the Authority field of the SID will contain uninitialized data
and thus not be a valid SID.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index ee3aab3dd4ac6..5df21d63dd04e 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1297,7 +1297,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 
 		if (uid_valid(uid)) { /* chown */
 			uid_t id;
-			nowner_sid_ptr = kmalloc(sizeof(struct cifs_sid),
+			nowner_sid_ptr = kzalloc(sizeof(struct cifs_sid),
 								GFP_KERNEL);
 			if (!nowner_sid_ptr) {
 				rc = -ENOMEM;
@@ -1326,7 +1326,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 		}
 		if (gid_valid(gid)) { /* chgrp */
 			gid_t id;
-			ngroup_sid_ptr = kmalloc(sizeof(struct cifs_sid),
+			ngroup_sid_ptr = kzalloc(sizeof(struct cifs_sid),
 								GFP_KERNEL);
 			if (!ngroup_sid_ptr) {
 				rc = -ENOMEM;
-- 
2.34.1

