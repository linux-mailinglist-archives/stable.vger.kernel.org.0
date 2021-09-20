Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4246C411ACC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245118AbhITQw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237332AbhITQun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E0CB61351;
        Mon, 20 Sep 2021 16:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156543;
        bh=IBIVmOL369LFjKG+XM3g14fm6SBagN/h5YPqfsTxOQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncF+UGwvIuasqfIzXWpomcSFi7uNP6TTtLS32fwwcazdoVmjaJSVXrIzH9a/Innje
         mCa1cq3YsJA9tpbVYvIkUkMtJ57JA2q6QoHjZfuR53K79qj748NGkuz1l7XQoQ7lQk
         pF9kQa7zL91+JVmK/Y2bEXTsc7K36Yvit8Wxi56M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 108/133] rpc: fix gss_svc_init cleanup on failure
Date:   Mon, 20 Sep 2021 18:43:06 +0200
Message-Id: <20210920163916.157962735@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 5a4753446253a427c0ff1e433b9c4933e5af207c ]

The failure case here should be rare, but it's obviously wrong.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index bb8b0ef5de82..daf0c1ea3917 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1845,7 +1845,7 @@ gss_svc_init_net(struct net *net)
 		goto out2;
 	return 0;
 out2:
-	destroy_use_gss_proxy_proc_entry(net);
+	rsi_cache_destroy_net(net);
 out1:
 	rsc_cache_destroy_net(net);
 	return rv;
-- 
2.30.2



