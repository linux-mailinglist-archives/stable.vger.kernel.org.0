Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F8E2E657E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732782AbgL1QBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390471AbgL1Nby (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:31:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3CD02072C;
        Mon, 28 Dec 2020 13:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162273;
        bh=nlvaaxPyovPRjoHXoH4Gxj+sebjgFQrAzLubLCepMHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/9SPyV/BoqIkLTjgDgQAhH5hFXjcEcibL3PAKrD6ZTSf40Zn7Ktq0YXimTik3rtf
         09TCcxTmTusrnFWmn1gHfOywTyHqJIH0MbVXtxgEjv5rGDtvYYgXZJ7RCBsS43DCh1
         +zFVwqPndsRckBL13trTf8EP3DJb5abe4nNMRkW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kazuo ito <kzpn200@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/346] nfsd: Fix message level for normal termination
Date:   Mon, 28 Dec 2020 13:48:58 +0100
Message-Id: <20201228124930.368707639@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 89cb484f1cfbe..ad38633392a0d 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -417,8 +417,7 @@ static void nfsd_last_thread(struct svc_serv *serv, struct net *net)
 		return;
 
 	nfsd_shutdown_net(net);
-	printk(KERN_WARNING "nfsd: last server has exited, flushing export "
-			    "cache\n");
+	pr_info("nfsd: last server has exited, flushing export cache\n");
 	nfsd_export_flush(net);
 }
 
-- 
2.27.0



