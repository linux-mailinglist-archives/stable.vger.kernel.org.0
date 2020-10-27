Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FD029B0FA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901659AbgJ0OZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901657AbgJ0OZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:25:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0579A2072D;
        Tue, 27 Oct 2020 14:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808747;
        bh=maqoZSVQAjmQq5Ak1k2jmwjOBlOlVlYDoIXSuF4W+VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVV0nJ0B4ZhHrEMVp0ZVX5gFa4Gj2dfSAn+lePQaHEKZWj+YtK25H4l5QxL1p3rqk
         Rb4PMkKXypTf5D7THatZhhwreJSk++343jritknSl/fiARYNkszTWPghg21tzR0frT
         uh8rSyq5ID8nqcWhFSCoH4sEGpw/VJUJgAmgXsLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 207/264] crypto: ccp - fix error handling
Date:   Tue, 27 Oct 2020 14:54:25 +0100
Message-Id: <20201027135440.399247975@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@denx.de>

[ Upstream commit e356c49c6cf0db3f00e1558749170bd56e47652d ]

Fix resource leak in error handling.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Acked-by: John Allen <john.allen@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 626b643d610eb..20ca9c9e109e0 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1752,7 +1752,7 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			break;
 		default:
 			ret = -EINVAL;
-			goto e_ctx;
+			goto e_data;
 		}
 	} else {
 		/* Stash the context */
-- 
2.25.1



