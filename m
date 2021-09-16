Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0910C40E7EE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348071AbhIPRgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353531AbhIPReQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB47C63224;
        Thu, 16 Sep 2021 16:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810911;
        bh=jyGbl1MjEM8mx/lQQZ3zXpTmpq1jXOcRdy6X2m35FIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqIMuAUVKFgChZpA0dARAl+O/Jn5EMuQ4CbhiMtN218yY4DMFT538RQ/izrCJQy+C
         uk/OOsbPghGKsyyWWlPRp1B2ULW/BDxGIDEHZGsapTljfaclQDW1+Ce8XEwyThlPUr
         tlWf5K8+kCCD//EEO9YnXvm6VzpDop3AfmTJR3G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 314/432] rpc: fix gss_svc_init cleanup on failure
Date:   Thu, 16 Sep 2021 18:01:03 +0200
Message-Id: <20210916155821.461805042@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index a81be45f40d9..3d685fe328fa 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1980,7 +1980,7 @@ gss_svc_init_net(struct net *net)
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



