Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8076AF4B1F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731956AbfKHLh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731463AbfKHLhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:37:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D48121D6C;
        Fri,  8 Nov 2019 11:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213075;
        bh=3pZtjJxg82RJ4bLROtW2plxaPpzpKc7U4x+pscgL8z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnQiv5nfxu7+ZF4kftqjg4OmVCLgGvlMhvLf+Vdu1augql35S6KSkAblA0gTkNFp7
         eqLi+2FFhLf3iF2cz0sbWsazrNNESUKvR+pXqVLbviwObnJHhODlQNtTkGJ07zdi32
         KaVqrnaFdhkzSzuYAm5ThMLo8R7iksPSxvmGLt18=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 002/205] tee: optee: take DT status property into account
Date:   Fri,  8 Nov 2019 06:34:29 -0500
Message-Id: <20191108113752.12502-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit db878f76b9ff7487da9bb0f686153f81829f1230 ]

DT nodes may have a 'status' property which, if set to anything other
than 'ok' or 'okay', indicates to the OS that the DT node should be
treated as if it was not present. So add that missing logic to the
OP-TEE driver.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index e1aafe842d660..34dce850067b9 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -696,7 +696,7 @@ static int __init optee_driver_init(void)
 		return -ENODEV;
 
 	np = of_find_matching_node(fw_np, optee_match);
-	if (!np)
+	if (!np || !of_device_is_available(np))
 		return -ENODEV;
 
 	optee = optee_probe(np);
-- 
2.20.1

