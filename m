Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818966D493D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjDCOgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbjDCOgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:36:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896EE17646
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A3C361E77
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2ACC433EF;
        Mon,  3 Apr 2023 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532560;
        bh=mKTZqnASsqMLyV1yPuox+NTgyD0BIxwgbfujYSuC8K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dRbZP0yJoLShEsBwsNCjzIr7G3y/DQUvlGYDer80bjTDBgsWCk9dQCTpgD2BKLmL
         4vy9BSIkWp2asvUFJybAoN4k/i1fa5qSetuGmtsFwbA/sNZZasa2TYvW5K0uNO7LDw
         qiMrUHGImC0ZS3D114r+QvfibSfxOtb/79yZYwUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/181] cifs: fix missing unload_nls() in smb2_reconnect()
Date:   Mon,  3 Apr 2023 16:07:45 +0200
Message-Id: <20230403140416.151023015@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit c24bb1a87dc3f2d77d410eaac2c6a295961bf50e ]

Make sure to unload_nls() @nls_codepage if we no longer need it.

Fixes: bc962159e8e3 ("cifs: avoid race conditions with parallel reconnects")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f0b1ae0835d71..b37379b62cc77 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -144,7 +144,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	struct nls_table *nls_codepage;
+	struct nls_table *nls_codepage = NULL;
 	struct cifs_ses *ses;
 
 	/*
@@ -216,8 +216,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		 tcon->ses->chans_need_reconnect,
 		 tcon->need_reconnect);
 
-	nls_codepage = load_nls_default();
-
 	mutex_lock(&ses->session_mutex);
 	/*
 	 * Recheck after acquire mutex. If another thread is negotiating
@@ -237,6 +235,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 	spin_unlock(&server->srv_lock);
 
+	nls_codepage = load_nls_default();
+
 	/*
 	 * need to prevent multiple threads trying to simultaneously
 	 * reconnect the same SMB session
-- 
2.39.2



