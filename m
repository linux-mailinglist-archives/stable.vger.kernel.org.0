Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8BB29BC7C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810029AbgJ0QdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802487AbgJ0Pth (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:49:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC6C223FB;
        Tue, 27 Oct 2020 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813761;
        bh=aXSL56NO64/b6gwekUk0tX3AXp5hEhmLjEQ5cVnUrtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWxwlOx2MXXrkBz/xQERS1WlqhxpnXVPflmQxmyASe9/A1z7S/GOE8GmOxck/rK1/
         r6912/PYGBRwb1ZZwngCh7oMtzBYyWfeReomChOkuBmK9JXmX6hJG75ZStrPFCd2U6
         +2rZNkzQHKAoeKzr28wz8wGFVbSbYOaX2lAIGo5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 644/757] crypto: ccp - fix error handling
Date:   Tue, 27 Oct 2020 14:54:54 +0100
Message-Id: <20201027135520.771234164@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index bd270e66185e9..40869ea1ed20f 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1744,7 +1744,7 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
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



