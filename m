Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762D333B67C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhCON56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231983AbhCON51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7365264DAD;
        Mon, 15 Mar 2021 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816647;
        bh=hkkl8bLmIp1Yh4LBayoLD0RW3RsbGjJ000u/KnO1o8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJF/2ysirqp7/e5secQyrJZauuyxcqckIhxYE9HjOAuvAKqnSR6Hd/uKkPCC2Hg+3
         Tu4f9F/wu1z4CcYQvIiSFMZvjT6xgbSUl+JrvwIQ/oJReBlB6MVGS2OVk/gNsBQ9Kf
         qRvmipccxnkuyJCkYmAJaKqVJFGGnKe4QznpZ+lw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 040/306] cifs: fix credit accounting for extra channel
Date:   Mon, 15 Mar 2021 14:51:43 +0100
Message-Id: <20210315135508.996723064@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Aurelien Aptel <aaptel@suse.com>

commit a249cc8bc2e2fed680047d326eb9a50756724198 upstream.

With multichannel, operations like the queries
from "ls -lR" can cause all credits to be used and
errors to be returned since max_credits was not
being set correctly on the secondary channels and
thus the client was requesting 0 credits incorrectly
in some cases (which can lead to not having
enough credits to perform any operation on that
channel).

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
CC: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   10 +++++-----
 fs/cifs/sess.c    |    1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1405,6 +1405,11 @@ smbd_connected:
 	tcp_ses->min_offload = ctx->min_offload;
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
 
+	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
+		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
+	else
+		tcp_ses->max_credits = ctx->max_credits;
+
 	tcp_ses->nr_targets = 1;
 	tcp_ses->ignore_signature = ctx->ignore_signature;
 	/* thread spawned, put it on the list */
@@ -2806,11 +2811,6 @@ static int mount_get_conns(struct smb3_f
 
 	*nserver = server;
 
-	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
-		server->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
-	else
-		server->max_credits = ctx->max_credits;
-
 	/* get a reference to a SMB session */
 	ses = cifs_get_smb_ses(server, ctx);
 	if (IS_ERR(ses)) {
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -230,6 +230,7 @@ cifs_ses_add_channel(struct cifs_sb_info
 	ctx.noautotune = ses->server->noautotune;
 	ctx.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	ctx.echo_interval = ses->server->echo_interval / HZ;
+	ctx.max_credits = ses->server->max_credits;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw


