Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3093CE20F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346321AbhGSP2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349347AbhGSP0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:26:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9A3561002;
        Mon, 19 Jul 2021 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710835;
        bh=hwI9xTL2ebUdO0DmxdC1jpzwPPvsqSev3UsSzitDOfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZwXLzy6DoIquM+MKA47+DBxjtvRXluR5H16GcHL0CznmP11mfD1Nd4Y6yZJfdbjV
         fVRdnuDJOnyGzt/uplDpwlncdPehzIfxDZ2VYQw6s0ukV+fvG33c0C6axjSboBTJyC
         fTuh/JjPKlglQaBaizer5JI2yGkm4BV87xneEm4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yizhuo <yzhai003@ucr.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 125/351] Input: hideep - fix the uninitialized use in hideep_nvm_unlock()
Date:   Mon, 19 Jul 2021 16:51:11 +0200
Message-Id: <20210719144948.609832956@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



