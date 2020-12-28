Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C632E3CC2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438121AbgL1OGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438130AbgL1OGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B68BF207B7;
        Mon, 28 Dec 2020 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164350;
        bh=SalygURyFGZuo7ovPypXrwErcZqfTMmgkCjICmgwdS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGJDaq+D2M1GYNXEVDc+0PojiVOXcokSH2VSeO4EB/0O8e66IOY5CuicpkrgFesVd
         W+T51o43VzOgg+KeXFpsY30M+UtANcUrAeFezc9qJ8ksfRmhBOgwU9U2+l3lGxsdn/
         wnXmBWaHVkhQPfZG+NNLGnJeS2pcodV8Jo81oB5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Xu <jack.xu@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/717] crypto: qat - fix status check in qat_hal_put_rel_rd_xfer()
Date:   Mon, 28 Dec 2020 13:41:46 +0100
Message-Id: <20201228125026.129138461@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Xu <jack.xu@intel.com>

[ Upstream commit 3b5c130fb2e4c045369791c33c83b59f6e84f7d6 ]

The return value of qat_hal_rd_ae_csr() is always a CSR value and never
a status and should not be stored in the status variable of
qat_hal_put_rel_rd_xfer().

This removes the assignment as qat_hal_rd_ae_csr() is not expected to
fail.
A more comprehensive handling of the theoretical corner case which could
result in a fail will be submitted in a separate patch.

Fixes: 8c9478a400b7 ("crypto: qat - reduce stack size with KASAN")
Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 6b9d47682d04d..52ef80efeddc6 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -1146,7 +1146,7 @@ static int qat_hal_put_rel_rd_xfer(struct icp_qat_fw_loader_handle *handle,
 	unsigned short mask;
 	unsigned short dr_offset = 0x10;
 
-	status = ctx_enables = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
+	ctx_enables = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
 	if (CE_INUSE_CONTEXTS & ctx_enables) {
 		if (ctx & 0x1) {
 			pr_err("QAT: bad 4-ctx mode,ctx=0x%x\n", ctx);
-- 
2.27.0



