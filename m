Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AECA2E39A8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgL1N0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:26:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389120AbgL1N0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE2A22A84;
        Mon, 28 Dec 2020 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161947;
        bh=OsXEu+1bLjL7vCoVVfeanmBzQ/qMtk8V3PeEXvPDxHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luWAMQshLhuAMzRxHmaAVoT7f2K/jgfCWxamduyZPkK2Xc/HNZjJI3hEm8vEpG48j
         R+RTKFi5wgudEmEHsM6/pBqEDBXb3p8q0x1gsx45APG0kLgnoutDOKA9oYKa/8HOgb
         XfrY8XiWtF6Dk3ZDnf/T5A/AFPHEx2NIbtahXNIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Xu <jack.xu@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/346] crypto: qat - fix status check in qat_hal_put_rel_rd_xfer()
Date:   Mon, 28 Dec 2020 13:47:36 +0100
Message-Id: <20201228124926.414690448@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index ff149e176f649..dac130bb807ae 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -1189,7 +1189,7 @@ static int qat_hal_put_rel_rd_xfer(struct icp_qat_fw_loader_handle *handle,
 	unsigned short mask;
 	unsigned short dr_offset = 0x10;
 
-	status = ctx_enables = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
+	ctx_enables = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
 	if (CE_INUSE_CONTEXTS & ctx_enables) {
 		if (ctx & 0x1) {
 			pr_err("QAT: bad 4-ctx mode,ctx=0x%x\n", ctx);
-- 
2.27.0



