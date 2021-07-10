Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF263C2E81
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhGJC1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233445AbhGJC0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A83FF613EB;
        Sat, 10 Jul 2021 02:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883835;
        bh=hwI9xTL2ebUdO0DmxdC1jpzwPPvsqSev3UsSzitDOfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFBPbhIorIDBmBQmQ8UZa8EkrWgfFq09XfTwpxsPy432lalYp7Afp0MXy23EuUw44
         cbbeN4BZOY7eYaLvYa/n+ZSwVS6ptUgJZWyoEHBXZI05sSJ/Ux3w+TCfani32yMFE0
         gnziORBM0h2Ciip3OvgBViTBWHwam5daFJTICYc7+Xa5xiPynqxE3ciQ5J6ZnFT4c0
         gY6dS24P2kY/0oNSESCFkpkZPjbxdn6/k6x0YPZI13NbWxGgB+ZIn8yK3QAmN2lnLU
         YLxff0l3wSRfbdVAVCutDnKwvSswHaHbxt57ydcyWmdskeOMpfar2vXE/ajYh7OQxe
         WiakyaBofHIXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yizhuo Zhai <yzhai003@ucr.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 082/104] Input: hideep - fix the uninitialized use in hideep_nvm_unlock()
Date:   Fri,  9 Jul 2021 22:21:34 -0400
Message-Id: <20210710022156.3168825-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yizhuo Zhai <yzhai003@ucr.edu>

[ Upstream commit cac7100d4c51c04979dacdfe6c9a5e400d3f0a27 ]

Inside function hideep_nvm_unlock(), variable "unmask_code" could
be uninitialized if hideep_pgm_r_reg() returns error, however, it
is used in the later if statement after an "and" operation, which
is potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/hideep.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/hideep.c b/drivers/input/touchscreen/hideep.c
index ddad4a82a5e5..e9547ee29756 100644
--- a/drivers/input/touchscreen/hideep.c
+++ b/drivers/input/touchscreen/hideep.c
@@ -361,13 +361,16 @@ static int hideep_enter_pgm(struct hideep_ts *ts)
 	return -EIO;
 }
 
-static void hideep_nvm_unlock(struct hideep_ts *ts)
+static int hideep_nvm_unlock(struct hideep_ts *ts)
 {
 	u32 unmask_code;
+	int error;
 
 	hideep_pgm_w_reg(ts, HIDEEP_FLASH_CFG, HIDEEP_NVM_SFR_RPAGE);
-	hideep_pgm_r_reg(ts, 0x0000000C, &unmask_code);
+	error = hideep_pgm_r_reg(ts, 0x0000000C, &unmask_code);
 	hideep_pgm_w_reg(ts, HIDEEP_FLASH_CFG, HIDEEP_NVM_DEFAULT_PAGE);
+	if (error)
+		return error;
 
 	/* make it unprotected code */
 	unmask_code &= ~HIDEEP_PROT_MODE;
@@ -384,6 +387,8 @@ static void hideep_nvm_unlock(struct hideep_ts *ts)
 	NVM_W_SFR(HIDEEP_NVM_MASK_OFS, ts->nvm_mask);
 	SET_FLASH_HWCONTROL();
 	hideep_pgm_w_reg(ts, HIDEEP_FLASH_CFG, HIDEEP_NVM_DEFAULT_PAGE);
+
+	return 0;
 }
 
 static int hideep_check_status(struct hideep_ts *ts)
@@ -462,7 +467,9 @@ static int hideep_program_nvm(struct hideep_ts *ts,
 	u32 addr = 0;
 	int error;
 
-	hideep_nvm_unlock(ts);
+       error = hideep_nvm_unlock(ts);
+       if (error)
+               return error;
 
 	while (ucode_len > 0) {
 		xfer_len = min_t(size_t, ucode_len, HIDEEP_NVM_PAGE_SIZE);
-- 
2.30.2

