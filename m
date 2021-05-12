Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF637C498
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhELPcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235483AbhELP2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D14C61925;
        Wed, 12 May 2021 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832395;
        bh=ypEOU/CNhBtB4MaCH9Ro/6/r+rQI6t1xksKmsj56Cs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnM5AfXHK/mssZVbB2gbPAOO51LfoCaySzQeHgA4L5AKq+qzKYoN6PbMIwzko37Vc
         GLsV4+AZJZl1F1yjgJTEMg33OifKDeh8dj0bhjd76O2k8rAJ/jnlIsWIS4WJIQ0kvN
         yDBb5lsGUBML4bIMTg+k9TZQE8npV08YnWlfZjiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/530] spi: spi-zynqmp-gqspi: Fix missing unlock on error in zynqmp_qspi_exec_op()
Date:   Wed, 12 May 2021 16:46:05 +0200
Message-Id: <20210512144828.217387913@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 6043357263fbe2df0bf0736d971ad5dce7d19dc1 ]

Add the missing unlock before return from function zynqmp_qspi_exec_op()
in the error handling case.

Fixes: a0f65be6e880 ("spi: spi-zynqmp-gqspi: add mutex locking for exec_op")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210412160025.194171-1-weiyongjun1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 036d8ae41c06..408e348382c5 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -965,8 +965,10 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 
 	if (op->cmd.opcode) {
 		tmpbuf = kzalloc(op->cmd.nbytes, GFP_KERNEL | GFP_DMA);
-		if (!tmpbuf)
+		if (!tmpbuf) {
+			mutex_unlock(&xqspi->op_lock);
 			return -ENOMEM;
+		}
 		tmpbuf[0] = op->cmd.opcode;
 		reinit_completion(&xqspi->data_completion);
 		xqspi->txbuf = tmpbuf;
-- 
2.30.2



