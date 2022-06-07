Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3789A540A37
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349845AbiFGSSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349930AbiFGSNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:13:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5478A159070;
        Tue,  7 Jun 2022 10:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4033C61782;
        Tue,  7 Jun 2022 17:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF40C385A5;
        Tue,  7 Jun 2022 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624142;
        bh=8D15uPtE3xzFTL7RFxE6DtiM+zTsnzoGBO5Q+B9naE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3e3TCpDFOpil8lMxTaPVw8PE/lqiHkSBq0u0dux812irw1Qxvx7eMO+Vh3NEPWrH
         FKmDYdiks3Z9CtYD/KvU8JTlG9tmMkt3ID1WRpW6xG0ytKOo9fi8dlmxp62YdCgwLZ
         OvDyWxIvH5eSO+WVy0g00GYXJMnpuvBr+Bs0W9JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/667] smb3: check for null tcon
Date:   Tue,  7 Jun 2022 18:57:24 +0200
Message-Id: <20220607164940.177772538@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index df9ba3729d1f..775296e4d3c8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -745,8 +745,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -764,6 +764,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (tcon->nohandlecache)
 		return -ENOTSUPP;
 
+	ses = tcon->ses;
+	server = ses->server;
+
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
 
-- 
2.35.1



