Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146834FD495
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354862AbiDLH55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359100AbiDLHmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EAE55483;
        Tue, 12 Apr 2022 00:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA32E616B2;
        Tue, 12 Apr 2022 07:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C504DC385A5;
        Tue, 12 Apr 2022 07:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748014;
        bh=G4nXFvcr9Il+xgiyLJXTB2I4UFpbZB76hNekK2W5Qc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYK9HMLUjRlvwOgU9t1AZLRV0YLs1QLFmLxp0EYSCeVC8oi3a9Qr1arxN+2oe8eat
         byeXMIempcqcHL5RRBEFtMWKWOjzdjnZYykSucMcp8B12YooES4WAqkNYUgsLN2Q5O
         /U8Mrhy06wKp1MaxGvA6Qzbfo/5luI0QsIbcfmZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 289/343] cifs: force new session setup and tcon for dfs
Date:   Tue, 12 Apr 2022 08:31:47 +0200
Message-Id: <20220412062959.670188954@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Paulo Alcantara <pc@cjr.nz>

commit fb39d30e227233498c8debe6a9fe3e7cf575c85f upstream.

Do not reuse existing sessions and tcons in DFS failover as it might
connect to different servers and shares.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -453,9 +453,7 @@ static int reconnect_target_unlocked(str
 	return rc;
 }
 
-static int
-reconnect_dfs_server(struct TCP_Server_Info *server,
-		     bool mark_smb_session)
+static int reconnect_dfs_server(struct TCP_Server_Info *server)
 {
 	int rc = 0;
 	const char *refpath = server->current_fullpath + 1;
@@ -479,7 +477,12 @@ reconnect_dfs_server(struct TCP_Server_I
 	if (!cifs_tcp_ses_needs_reconnect(server, num_targets))
 		return 0;
 
-	cifs_mark_tcp_ses_conns_for_reconnect(server, mark_smb_session);
+	/*
+	 * Unconditionally mark all sessions & tcons for reconnect as we might be connecting to a
+	 * different server or share during failover.  It could be improved by adding some logic to
+	 * only do that in case it connects to a different server or share, though.
+	 */
+	cifs_mark_tcp_ses_conns_for_reconnect(server, true);
 
 	cifs_abort_connection(server);
 
@@ -537,7 +540,7 @@ int cifs_reconnect(struct TCP_Server_Inf
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	return reconnect_dfs_server(server, mark_smb_session);
+	return reconnect_dfs_server(server);
 }
 #else
 int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)


