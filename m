Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DB4498F03
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357380AbiAXTty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36504 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356100AbiAXTpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:45:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2780FB810AF;
        Mon, 24 Jan 2022 19:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494DCC340E5;
        Mon, 24 Jan 2022 19:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053512;
        bh=ZtKeDD/iUB+vymXfA70PorhyhrKwFGMPyIFP8fSH8eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNNwpqZVCeuVVzZ45zdatq7U4goI4tTy1JrWn0TQWFSkxzhcDsx+BrPCt7rdno3CB
         okDd2HI2a9afiWICQ93fIptc/xSVUno6cGTFSzJDrreBBcjY9bsMLQbMj4NJ7Mfoph
         EZNbfJsU0ZkFfUIX6RLisLvjcYitHSTPKM+/BP1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/563] tee: fix put order in teedev_close_context()
Date:   Mon, 24 Jan 2022 19:37:34 +0100
Message-Id: <20220124184027.476119292@linuxfoundation.org>
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

From: Jens Wiklander <jens.wiklander@linaro.org>

[ Upstream commit f18397ab3ae23e8e43bba9986e66af6d4497f2ad ]

Prior to this patch was teedev_close_context() calling tee_device_put()
before teedev_ctx_put() leading to teedev_ctx_release() accessing
ctx->teedev just after the reference counter was decreased on the
teedev. Fix this by calling teedev_ctx_put() before tee_device_put().

Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 6ade4a5c48407..dfc239c64ce3c 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -98,8 +98,10 @@ void teedev_ctx_put(struct tee_context *ctx)
 
 static void teedev_close_context(struct tee_context *ctx)
 {
-	tee_device_put(ctx->teedev);
+	struct tee_device *teedev = ctx->teedev;
+
 	teedev_ctx_put(ctx);
+	tee_device_put(teedev);
 }
 
 static int tee_open(struct inode *inode, struct file *filp)
-- 
2.34.1



