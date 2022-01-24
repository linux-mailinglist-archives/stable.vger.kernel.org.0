Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24C6498BD8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347457AbiAXTQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:16:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40176 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348046AbiAXTOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:14:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F20B0B8121C;
        Mon, 24 Jan 2022 19:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24347C340E5;
        Mon, 24 Jan 2022 19:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051683;
        bh=D54MdEBmCYEy6ur7bgYgsa7SkjdZdJ+WIe8dfhTumU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDStTNV6mZVICQuZHYjGQOs67wGh+3UPgdYaIsry/4tyXlwQufllXMzzCuqAiKL40
         MP1EydNPSaaSxXbzzzp0lAvx7rGlvXJQjpFVV2bOOb4lYL6OX5FoKj2OZTwi0K1MhB
         P+h+smN7obJUsBGvYawowjUzJFJoOwAISCG9qLXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/239] tee: fix put order in teedev_close_context()
Date:   Mon, 24 Jan 2022 19:41:32 +0100
Message-Id: <20220124183944.853795376@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
index dd46b758852aa..d42fc2ae8592e 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -96,8 +96,10 @@ void teedev_ctx_put(struct tee_context *ctx)
 
 static void teedev_close_context(struct tee_context *ctx)
 {
-	tee_device_put(ctx->teedev);
+	struct tee_device *teedev = ctx->teedev;
+
 	teedev_ctx_put(ctx);
+	tee_device_put(teedev);
 }
 
 static int tee_release(struct inode *inode, struct file *filp)
-- 
2.34.1



