Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE8E3C3138
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhGJCk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233805AbhGJCho (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19E56613BE;
        Sat, 10 Jul 2021 02:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884499;
        bh=Hvm7ppRyQJJFoZu7LAYNLjkXJAGcAG0e9cv6Q0x2NAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3YxLh48a2moPK9OIlx3/lrAsUltOhwF1U0PY5BDyqXdI2wpXMw755ZJSrkWnuuwW
         FcHYdO9slkeWw1mmQfEq4eupHp5agLUFTqVLmH2uW7U/n1TwhvJ3OWAyHjyowI1EvQ
         P6PIUzEkFUVf9gbEAfGfeRGcQlpfO2hrWy83Cb0Vxk3G3OMaNrB/OUZTzwn4FQw9/8
         nCd8hrF+puXi238Nom6t+nUlK3xNJyifXRZhHXLfV/8ORZkuQbNsaY1n6+kqplAxrN
         xZ6QSbo7TYEckACONUoXs77f+Gs7vpCz8cM3yOjR2KIzQt0ojCcvy1iadJzC2t6+4Z
         bajtKH1DDrWpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yizhuo Zhai <yzhai003@ucr.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 28/39] Input: hideep - fix the uninitialized use in hideep_nvm_unlock()
Date:   Fri,  9 Jul 2021 22:31:53 -0400
Message-Id: <20210710023204.3171428-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
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
index f1cd4dd9a4a3..d7775db0b711 100644
--- a/drivers/input/touchscreen/hideep.c
+++ b/drivers/input/touchscreen/hideep.c
@@ -364,13 +364,16 @@ static int hideep_enter_pgm(struct hideep_ts *ts)
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
@@ -387,6 +390,8 @@ static void hideep_nvm_unlock(struct hideep_ts *ts)
 	NVM_W_SFR(HIDEEP_NVM_MASK_OFS, ts->nvm_mask);
 	SET_FLASH_HWCONTROL();
 	hideep_pgm_w_reg(ts, HIDEEP_FLASH_CFG, HIDEEP_NVM_DEFAULT_PAGE);
+
+	return 0;
 }
 
 static int hideep_check_status(struct hideep_ts *ts)
@@ -465,7 +470,9 @@ static int hideep_program_nvm(struct hideep_ts *ts,
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

