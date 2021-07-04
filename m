Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2AA3BB1BD
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhGDXNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231380AbhGDXJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF5061946;
        Sun,  4 Jul 2021 23:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440020;
        bh=FzXwPdNNUN1+bbWVulgsQZBbjZaP73QD17PYhjK13DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiJ7YI/oZ18avvZpZE+aS+TJFHpnYRsJiANyFrgS5Uc4i85rvSgZuoJXwV/m6Is6b
         matMeWi7aFGwnH0vTdUJf0jXWu+er6KwEkJAZA999TJC3+AxW0nbfQrIvI2+O84OO3
         LaRpFUFYQr4jDxwNyO4qVb2NnDLdSsn3ZjNS2kWxJBT2mCpYeTJOBDNwsVPK1DnlVs
         ST5/3PCn1Dl9yYsHWaQOtxc7s+ZyDvIo5BZ6puAqenGzew/roECtE0mJeb2uJ40gOD
         ic9Sgv+itu5jq3wONnDfTKOZkWTqzDK+EevoCzpQoqVD/dqItdwWGo4fFqRFfKOXz5
         H+yK1+3TeWvtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Xu <jack.xu@intel.com>, Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.12 31/80] crypto: qat - check return code of qat_hal_rd_rel_reg()
Date:   Sun,  4 Jul 2021 19:05:27 -0400
Message-Id: <20210704230616.1489200-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index bd3028126cbe..069f51621f0e 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -1417,7 +1417,11 @@ static int qat_hal_put_rel_wr_xfer(struct icp_qat_fw_loader_handle *handle,
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

