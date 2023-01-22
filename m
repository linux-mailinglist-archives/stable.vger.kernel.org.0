Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19654676F6D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjAVPVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjAVPV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:21:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5161422DE7
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9151B80B23
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2F1C433D2;
        Sun, 22 Jan 2023 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400875;
        bh=PcQq1f3cQ5m9uohLqlScSGueBeZ0BtRw6zMK6sryKbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pu7U7VLW7ALIFwCwHQ1naGD0UZkg4k+ZMOjPHl2hma4C7JXGgkjvtNthjAW9obwer
         bMqVlCIYeGp7Rm3iS12hguGTG14TJcv8FuRVXSyum+kH5nV3sbLusP2XjkAkYCS0ZN
         GMaymdYTl9zMLXqi0vicivk78XVLk8foPfCqJTOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/193] cifs: fix race in assemble_neg_contexts()
Date:   Sun, 22 Jan 2023 16:02:33 +0100
Message-Id: <20230122150247.473717865@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 775e44d6d86dca400d614cbda5dab4def4951fe7 ]

Serialise access of TCP_Server_Info::hostname in
assemble_neg_contexts() by holding the server's mutex otherwise it
might end up accessing an already-freed hostname pointer from
cifs_reconnect() or cifs_resolve_server().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4ac5b1bfaf78..727f16b426be 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -541,9 +541,10 @@ static void
 assemble_neg_contexts(struct smb2_negotiate_req *req,
 		      struct TCP_Server_Info *server, unsigned int *total_len)
 {
-	char *pneg_ctxt;
-	char *hostname = NULL;
 	unsigned int ctxt_len, neg_context_count;
+	struct TCP_Server_Info *pserver;
+	char *pneg_ctxt;
+	char *hostname;
 
 	if (*total_len > 200) {
 		/* In case length corrupted don't want to overrun smb buffer */
@@ -574,8 +575,9 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	 * secondary channels don't have the hostname field populated
 	 * use the hostname field in the primary channel instead
 	 */
-	hostname = CIFS_SERVER_IS_CHAN(server) ?
-		server->primary_server->hostname : server->hostname;
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+	cifs_server_lock(pserver);
+	hostname = pserver->hostname;
 	if (hostname && (hostname[0] != 0)) {
 		ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
 					      hostname);
@@ -584,6 +586,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 		neg_context_count = 3;
 	} else
 		neg_context_count = 2;
+	cifs_server_unlock(pserver);
 
 	build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
 	*total_len += sizeof(struct smb2_posix_neg_context);
-- 
2.35.1



