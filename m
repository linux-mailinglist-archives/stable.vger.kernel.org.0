Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3473BB331
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhGDXRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234305AbhGDXPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0A876141C;
        Sun,  4 Jul 2021 23:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440326;
        bh=akcR7Pm/E7YJgiGct8FsuxZrYv4JOGAcsaYKBK4XVC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQgXJ0mn03JbNV29chF4csgkL9Tu08R57/ItYeswqJtvpMF7aVhbPl3GpROBO7HJR
         jvgVSNGC4beW0PugY3rLjh/VxqRY77HwhcSQb3JCT6f9RCQDkhwvL7N8tKnMbdq5V4
         SmyiSgxkyW2eWUUlB+rtS2OxScRlTVxJcoYGErepDFURSCsM9uDsFjBk9mMBbW5vt6
         II8xzkncLNCC0JYAI5ebbGvJ7dK/UX8LdTF8Z3GOYbTij945A7f3E+udQbnEM9DG70
         2VZCARnTeT1pSv7wJHmyLWCmhlVTXZpr8mGQKGw4qO7yUfJqzqxrfdLCWyidrLRt4x
         pQSStPnGQ39aQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Xu <jack.xu@intel.com>, Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 08/20] crypto: qat - check return code of qat_hal_rd_rel_reg()
Date:   Sun,  4 Jul 2021 19:11:43 -0400
Message-Id: <20210704231155.1491795-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231155.1491795-1-sashal@kernel.org>
References: <20210704231155.1491795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Xu <jack.xu@intel.com>

[ Upstream commit 96b57229209490c8bca4335b01a426a96173dc56 ]

Check the return code of the function qat_hal_rd_rel_reg() and return it
to the caller.

This is to fix the following warning when compiling the driver with
clang scan-build:

    drivers/crypto/qat/qat_common/qat_hal.c:1436:2: warning: 6th function call argument is an uninitialized value

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Zhehui Xiang <zhehui.xiang@intel.com>
Signed-off-by: Zhehui Xiang <zhehui.xiang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 8c4fd255a601..cdf80c16a033 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -1255,7 +1255,11 @@ static int qat_hal_put_rel_wr_xfer(struct icp_qat_fw_loader_handle *handle,
 		pr_err("QAT: bad xfrAddr=0x%x\n", xfr_addr);
 		return -EINVAL;
 	}
-	qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPB_REL, gprnum, &gprval);
+	status = qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPB_REL, gprnum, &gprval);
+	if (status) {
+		pr_err("QAT: failed to read register");
+		return status;
+	}
 	gpr_addr = qat_hal_get_reg_addr(ICP_GPB_REL, gprnum);
 	data16low = 0xffff & data;
 	data16hi = 0xffff & (data >> 0x10);
-- 
2.30.2

