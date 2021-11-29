Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B15461F67
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379707AbhK2Sqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:46:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57512 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378633AbhK2Sov (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:44:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42164CE169C;
        Mon, 29 Nov 2021 18:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FE5C53FCF;
        Mon, 29 Nov 2021 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211290;
        bh=/hlEadkNJbfRO84v5Cji+IW0U23YPQQk85Zrg4PWZjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADPvh2YLanxt4HtdJgOx3IJnhf/r70D6KghhAeFN9qQ/Ffm363C6UY24ulr4R/jNo
         pJPRuQTubfUBlXgauCCX3mlyXZZGQ+sZEXB0/dT1m8j4LycnVQkM8n+OC15MV2Kv4v
         ho8e2/NIF0wPckTcQQ03JSq0tHo79lXtIKXphOlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 171/179] cifs: nosharesock should be set on new server
Date:   Mon, 29 Nov 2021 19:19:25 +0100
Message-Id: <20211129181724.557473832@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit b9ad6b5b687e798746024e5fc4574d8fa8bdfade upstream.

Recent fix to maintain a nosharesock state on the
server struct caused a regression. It updated this
field in the old tcp session, and not the new one.

This caused the multichannel scenario to misbehave.

Fixes: c9f1c19cf7c5 (cifs: nosharesock should not share socket with future sessions)
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1217,10 +1217,8 @@ static int match_server(struct TCP_Serve
 {
 	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
 
-	if (ctx->nosharesock) {
-		server->nosharesock = true;
+	if (ctx->nosharesock)
 		return 0;
-	}
 
 	/* this server does not share socket */
 	if (server->nosharesock)
@@ -1376,6 +1374,9 @@ cifs_get_tcp_session(struct smb3_fs_cont
 		goto out_err;
 	}
 
+	if (ctx->nosharesock)
+		tcp_ses->nosharesock = true;
+
 	tcp_ses->ops = ctx->ops;
 	tcp_ses->vals = ctx->vals;
 	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));


