Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B685F468D8
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfFNU2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfFNU2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:28:44 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 168A2217F9;
        Fri, 14 Jun 2019 20:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544124;
        bh=94ECcV6dTx0xMKW52GxZHCimBf4x1MEXzsL6Zr2qNAc=;
        h=From:To:Cc:Subject:Date:From;
        b=hBijiaGH3A/Rs5sPj2DV+lkVp/wiL0V2sMx43NUwmOhbL2IYW6K/DYgTRt2/SO53a
         j4g38R6cBVlnv+1TX41IVuPzoD38imzFrv7sXmqY7GmUry2buu055w6oHLruwUVK0H
         qOaof/OUE6h9oQOCf41jrTVdffGd43lGudt1vvjA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 01/59] lkdtm/usercopy: Moves the KERNEL_DS test to non-canonical
Date:   Fri, 14 Jun 2019 16:27:45 -0400
Message-Id: <20190614202843.26941-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 2bf8496f6e9b7e9a557f65eb95eab16fea7958c7 ]

The prior implementation of the KERNEL_DS fault checking would work on
any unmapped kernel address, but this was narrowed to the non-canonical
range instead. This adjusts the LKDTM test to match.

Fixes: 00c42373d397 ("x86-64: add warning for non-canonical user access address dereferences")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/usercopy.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/lkdtm/usercopy.c b/drivers/misc/lkdtm/usercopy.c
index d5a0e7f1813b..e172719dd86d 100644
--- a/drivers/misc/lkdtm/usercopy.c
+++ b/drivers/misc/lkdtm/usercopy.c
@@ -324,14 +324,16 @@ void lkdtm_USERCOPY_KERNEL(void)
 
 void lkdtm_USERCOPY_KERNEL_DS(void)
 {
-	char __user *user_ptr = (char __user *)ERR_PTR(-EINVAL);
+	char __user *user_ptr =
+		(char __user *)(0xFUL << (sizeof(unsigned long) * 8 - 4));
 	mm_segment_t old_fs = get_fs();
 	char buf[10] = {0};
 
-	pr_info("attempting copy_to_user on unmapped kernel address\n");
+	pr_info("attempting copy_to_user() to noncanonical address: %px\n",
+		user_ptr);
 	set_fs(KERNEL_DS);
-	if (copy_to_user(user_ptr, buf, sizeof(buf)))
-		pr_info("copy_to_user un unmapped kernel address failed\n");
+	if (copy_to_user(user_ptr, buf, sizeof(buf)) == 0)
+		pr_err("copy_to_user() to noncanonical address succeeded!?\n");
 	set_fs(old_fs);
 }
 
-- 
2.20.1

