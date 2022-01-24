Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2809F498EF0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357237AbiAXTtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42288 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355616AbiAXTot (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:44:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D281F6131E;
        Mon, 24 Jan 2022 19:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42F0C340E5;
        Mon, 24 Jan 2022 19:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053488;
        bh=NnJCk13Goff3H48BL/psmetMcVRnOhKs9tjpoNimvyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Llk8SmJq92rKeW6AZaHFsfJdltP6EGS6M6H3VK+b5avkxSssInGvzbXeaRF7zxPzO
         zStG3xtS4YUsuif39s8fVIRDW9rFFoiQurU4AV4PRsu9fXHlinzcPhug7vJNwObaVe
         Nw5z2swwxhPtNLBCTttXnE1zvKWiuaOVr/AVLOmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/563] fs: dlm: use sk->sk_socket instead of con->sock
Date:   Mon, 24 Jan 2022 19:37:27 +0100
Message-Id: <20220124184027.228849912@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit feb704bd17786c8ff52a49d7759b8ee4f3a5aaac ]

Instead of dereference "con->sock" we can get the socket structure over
"sk->sk_socket" as well. This patch will switch to this behaviour.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 0c78fdfb1f6fa..0a8645ed4b2d6 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -480,8 +480,7 @@ static void lowcomms_error_report(struct sock *sk)
 		goto out;
 
 	orig_report = listen_sock.sk_error_report;
-	if (con->sock == NULL ||
-	    kernel_getpeername(con->sock, (struct sockaddr *)&saddr) < 0) {
+	if (kernel_getpeername(sk->sk_socket, (struct sockaddr *)&saddr) < 0) {
 		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
 				   "sending to node %d, port %d, "
 				   "sk_err=%d/%d\n", dlm_our_nodeid(),
-- 
2.34.1



