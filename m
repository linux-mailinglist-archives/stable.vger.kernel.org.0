Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321846D492F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbjDCOfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbjDCOfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF581EF88
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3A47B81CA0
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E33C433D2;
        Mon,  3 Apr 2023 14:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532528;
        bh=Bj4C/a8N6Rx+cNWrg26nF/Rq/+JT3vS6jYovD76DZDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dd4T/jsKF0twDL5LkxTRO7xjk6k2hLVIeo5G1KdWbcHU3r/1g+6rmyIRinLHhA/Iw
         mstPGbmCpjsOhqI3cj1Na/FZO8wFORovyCLWF+0VrC32gIliaOJvgvZmGPOymXcR1S
         bh5uV+f3CuaiWBd5Td6dY3ZBmkUleaZiDbLumZ+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/181] cifs: update ip_addr for ses only for primary chan setup
Date:   Mon,  3 Apr 2023 16:07:17 +0200
Message-Id: <20230403140415.177676987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit e77978de4765229e09c8fabcf4f8419ff367317f ]

We update ses->ip_addr whenever we do a session setup.
But this should happen only for primary channel in mchan
scenario.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: bc962159e8e3 ("cifs: avoid race conditions with parallel reconnects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7aecb1646b6fc..43637c1283748 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4082,16 +4082,12 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		   struct nls_table *nls_info)
 {
 	int rc = -ENOSYS;
-	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
-	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
+	struct TCP_Server_Info *pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&pserver->dstaddr;
+	struct sockaddr_in *addr = (struct sockaddr_in *)&pserver->dstaddr;
 	bool is_binding = false;
 
 	spin_lock(&ses->ses_lock);
-	if (server->dstaddr.ss_family == AF_INET6)
-		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI6", &addr6->sin6_addr);
-	else
-		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
-
 	if (ses->ses_status != SES_GOOD &&
 	    ses->ses_status != SES_NEW &&
 	    ses->ses_status != SES_NEED_RECON) {
@@ -4115,6 +4111,14 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		ses->ses_status = SES_IN_SETUP;
 	spin_unlock(&ses->ses_lock);
 
+	/* update ses ip_addr only for primary chan */
+	if (server == pserver) {
+		if (server->dstaddr.ss_family == AF_INET6)
+			scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI6", &addr6->sin6_addr);
+		else
+			scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
+	}
+
 	if (!is_binding) {
 		ses->capabilities = server->capabilities;
 		if (!linuxExtEnabled)
-- 
2.39.2



