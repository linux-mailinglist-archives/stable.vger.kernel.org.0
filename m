Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9C124BA97
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbgHTMNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730185AbgHTJ51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:57:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C65D22CAD;
        Thu, 20 Aug 2020 09:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917447;
        bh=TBVknhZVyjDgRUX1egicX7fhjQ9CedC2sJRWeg3JK24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmrGpTerFwrnV76lQ6wiBhwSxHspUA1n4uVPJDc2u3WbvC0sgYhZ/OCnF+1CjNspe
         k4IuKOFOo2hGgZU9jRSeT/qxNubCdjTLN/2bYZdhpKTrqBmot6ONGkE/2KWSIns4hS
         ljG3GqnOYBYaPgEaaCHS6PZSPC+3Yj1vxdHMY/zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 005/212] crypto: ccp - Release all allocated memory if sha type is invalid
Date:   Thu, 20 Aug 2020 11:19:38 +0200
Message-Id: <20200820091602.527206018@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 128c66429247add5128c03dc1e144ca56f05a4e2 ]

Release all allocated memory if sha type is invalid:
In ccp_run_sha_cmd, if the type of sha is invalid, the allocated
hmac_buf should be released.

v2: fix the goto.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 7d4cd518e6022..723f0a0cb2b5b 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1216,8 +1216,9 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			       digest_size);
 			break;
 		default:
+			kfree(hmac_buf);
 			ret = -EINVAL;
-			goto e_ctx;
+			goto e_data;
 		}
 
 		memset(&hmac_cmd, 0, sizeof(hmac_cmd));
-- 
2.25.1



