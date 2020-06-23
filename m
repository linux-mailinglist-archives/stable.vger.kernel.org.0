Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B303205D6B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389044AbgFWUNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389040AbgFWUNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA74B20707;
        Tue, 23 Jun 2020 20:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943182;
        bh=4wO1ahYsxU7vXLE+IH9aSUvrxXCkZxbwVyXF5c/cCiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lvlMPFWBdBgkfcNoP1JldlNcRQftrdkmBeOCFoauLKsfxszjFPKzEypYaFv4RtPw
         j3BNP+t7XLTx5IoB+oMT2pLnQjj6VtrlGxTklDs/xZMMP1evlDwF8ucdg4WGFTMxer
         6WDL8ZgHm6jiGp426ts22N91jYRbqJxpj+y+mfBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 291/477] NFSv4.1 fix rpc_call_done assignment for BIND_CONN_TO_SESSION
Date:   Tue, 23 Jun 2020 21:54:48 +0200
Message-Id: <20200623195421.323575753@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

[ Upstream commit 1c709b766e73e54d64b1dde1b7cfbcf25bcb15b9 ]

Fixes: 02a95dee8cf0 ("NFS add callback_ops to nfs4_proc_bind_conn_to_session_callback")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 9056f3dd380e5..e32717fd1169a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7909,7 +7909,7 @@ nfs4_bind_one_conn_to_session_done(struct rpc_task *task, void *calldata)
 }
 
 static const struct rpc_call_ops nfs4_bind_one_conn_to_session_ops = {
-	.rpc_call_done =  &nfs4_bind_one_conn_to_session_done,
+	.rpc_call_done =  nfs4_bind_one_conn_to_session_done,
 };
 
 /*
-- 
2.25.1



