Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F5CF468C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390381AbfKHLnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfKHLnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3D38222C6;
        Fri,  8 Nov 2019 11:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213393;
        bh=IMTxs0Vg3w+Hwrt3XgNErfmtrm2IarEi/exW/jkwuQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiM7KD3l5Kfwn0CZLSt1vMJk3VMlgKKB5dsfrq1gz6VWUR1xYpPY4dIwiHbPLOu91
         5P7SsipmIeoP/ZHPxnsQ+adm1bc38voS+jy1LjRTd3Rva58t1Ae4nZwJUzIdYbAI+q
         ycIZoTfzR/0va1jS/ikuU0ulDi/nz2mFzmcxKlIM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>, tee-dev@lists.linaro.org
Subject: [PATCH AUTOSEL 4.14 002/103] tee: optee: take DT status property into account
Date:   Fri,  8 Nov 2019 06:41:27 -0500
Message-Id: <20191108114310.14363-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
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
index edb6e4e9ef3ac..ca79c2ba2ef2a 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -590,7 +590,7 @@ static int __init optee_driver_init(void)
 		return -ENODEV;
 
 	np = of_find_matching_node(fw_np, optee_match);
-	if (!np)
+	if (!np || !of_device_is_available(np))
 		return -ENODEV;
 
 	optee = optee_probe(np);
-- 
2.20.1

