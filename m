Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199BC4FDA49
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiDLIKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358219AbiDLHlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2034B42A17;
        Tue, 12 Apr 2022 00:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFECA61045;
        Tue, 12 Apr 2022 07:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0E0C385A1;
        Tue, 12 Apr 2022 07:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747855;
        bh=HLy3qY+J5ROTEF4rwyotysIW1sSO8dDgG1rHbzkhJac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IM5zbrN3BMuJCxUpezxflmU+o+ZkGW5kB0fUPCdavQw6uze7p0LDLOvUacXxv1fCk
         AZy2i0SV17idNneDAxZyaq7yrWgPPbvt7jygbZ+K+R/1OP+mGIzFRFf2A+Xn3IvITd
         gRQrTxFci13ODH0j0/JAInFEmVim0+nAGxnQCFO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Enzo Matsumiya <ematsumiya@suse.de>,
        Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 229/343] cifs: fix potential race with cifsd thread
Date:   Tue, 12 Apr 2022 08:30:47 +0200
Message-Id: <20220412062957.947491639@linuxfoundation.org>
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

[ Upstream commit 687127c81ad32c8900a3fedbc7ed8f686ca95855 ]

To avoid racing with demultiplex thread while it is handling data on
socket, use cifs_signal_cifsd_for_reconnect() helper for marking
current server to reconnect and let the demultiplex thread handle the
rest.

Fixes: dca65818c80c ("cifs: use a different reconnect helper for non-cifsd threads")
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 2 +-
 fs/cifs/netmisc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d6f8ccc7bfe2..0270b412f801 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4465,7 +4465,7 @@ static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tco
 	 */
 	if (rc && server->current_fullpath != server->origin_fullpath) {
 		server->current_fullpath = server->origin_fullpath;
-		cifs_reconnect(tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(server, true);
 	}
 
 	dfs_cache_free_tgts(tl);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index ebe236b9d9f5..235aa1b395eb 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -896,7 +896,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
 		if (class == ERRSRV && code == ERRbaduid) {
 			cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
 				code);
-			cifs_reconnect(mid->server, false);
+			cifs_signal_cifsd_for_reconnect(mid->server, false);
 		}
 	}
 
-- 
2.35.1



