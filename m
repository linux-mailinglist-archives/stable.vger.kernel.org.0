Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A8E3BB02F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhGDXHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhGDXHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4319B61452;
        Sun,  4 Jul 2021 23:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439904;
        bh=FzXwPdNNUN1+bbWVulgsQZBbjZaP73QD17PYhjK13DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzQRkW0XLvS9DoUmNxpCAKNHmFnCx0w8ro4ru1V5OY1nRRZNeBja9jpT0I3goT5p4
         c4Zk2ii0NmQr00F54sdH1L5AF3B7YPhK0lU2trPp2Ro54BUFh2WMxdg1LdGBfKFpn+
         cGr0DeAPq78+EXtACrttn4hxj01M5LwViknFE6BRUf6CUHLerlaohiJZUPp6nRn4/+
         vqMN/7hCive/yJD/Dg4aoWC3r5Dj+RWQpflx6zDbGvWgRGmG9xrJWsUegDDFswlYlz
         8Hyu5yhZzxICVblRQXkGv8cy695h4veDXwsakQAoUoATCLdm6yrzQs8kfCJ3C2q2CK
         vtcaQ1OuP0XvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Xu <jack.xu@intel.com>, Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.13 31/85] crypto: qat - check return code of qat_hal_rd_rel_reg()
Date:   Sun,  4 Jul 2021 19:03:26 -0400
Message-Id: <20210704230420.1488358-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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

