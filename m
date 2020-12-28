Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25022E403A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441618AbgL1OTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441607AbgL1OTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26C0821D94;
        Mon, 28 Dec 2020 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165110;
        bh=1yaKa5VO1YtF2ZXkzQr5k4urAr46ODQChP0oi0Bv8Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svPXjoO0/1IEGdnKKDq5IRnOgWNWkkLeoq61FNymf7O9rRGKz3ckY5CVrTntJFP/n
         Vk9dNMmTNXiL9MWbgCHCNSv24vjgwIwpetbGtIBWoSAFK7NVRX+wndyHJhBWHhCzOA
         zZOyXUSeY2hmWNDM6bfp9UGpuZVpM1ONrAiVMZng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kazuo ito <kzpn200@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/717] nfsd: Fix message level for normal termination
Date:   Mon, 28 Dec 2020 13:46:13 +0100
Message-Id: <20201228125038.975981742@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: kazuo ito <kzpn200@gmail.com>

[ Upstream commit 4420440c57892779f265108f46f83832a88ca795 ]

The warning message from nfsd terminating normally
can confuse system adminstrators or monitoring software.

Though it's not exactly fair to pin-point a commit where it
originated, the current form in the current place started
to appear in:

Fixes: e096bbc6488d ("knfsd: remove special handling for SIGHUP")
Signed-off-by: kazuo ito <kzpn200@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 27b1ad1361508..9323e30a7eafe 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -527,8 +527,7 @@ static void nfsd_last_thread(struct svc_serv *serv, struct net *net)
 		return;
 
 	nfsd_shutdown_net(net);
-	printk(KERN_WARNING "nfsd: last server has exited, flushing export "
-			    "cache\n");
+	pr_info("nfsd: last server has exited, flushing export cache\n");
 	nfsd_export_flush(net);
 }
 
-- 
2.27.0



