Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7765F1EFB16
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgFEOXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgFEOSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A249A208E4;
        Fri,  5 Jun 2020 14:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366701;
        bh=AkXn3F1QP5BSV0KUEGG2OW8Bi82lChNVpLv1xxfpwO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5PkN8fMXeIVGeh2f0whIaCXXi+tWri2TylU313EaIMfE7B9i15qzZ0a2eX37cEG7
         O0KBHRPnW0e7OLS4QFtrEk7RhOSqneFymQ+gcLLT/sbUzEzpzKLaUIMgkJ4d2fzTXV
         21tMVGYJb9kHKyuHOKwb6Jvup3q/M2IgCkyjXeFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, fengsheng <fengsheng5@huawei.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/38] spi: dw: use "smp_mb()" to avoid sending spi data error
Date:   Fri,  5 Jun 2020 16:15:02 +0200
Message-Id: <20200605140253.715066792@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xinwei Kong <kong.kongxinwei@hisilicon.com>

[ Upstream commit bfda044533b213985bc62bd7ca96f2b984d21b80 ]

Because of out-of-order execution about some CPU architecture,
In this debug stage we find Completing spi interrupt enable ->
prodrucing TXEI interrupt -> running "interrupt_transfer" function
will prior to set "dw->rx and dws->rx_end" data, so this patch add
memory barrier to enable dw->rx and dw->rx_end to be visible and
solve to send SPI data error.
eg:
it will fix to this following low possibility error in testing environment
which using SPI control to connect TPM Modules

kernel: tpm tpm0: Operation Timed out
kernel: tpm tpm0: tpm_relinquish_locality: : error -1

Signed-off-by: fengsheng <fengsheng5@huawei.com>
Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
Link: https://lore.kernel.org/r/1578019930-55858-1-git-send-email-kong.kongxinwei@hisilicon.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 11cac7e10663..d2ca3b357cfe 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -297,6 +297,9 @@ static int dw_spi_transfer_one(struct spi_controller *master,
 	dws->len = transfer->len;
 	spin_unlock_irqrestore(&dws->buf_lock, flags);
 
+	/* Ensure dw->rx and dw->rx_end are visible */
+	smp_mb();
+
 	spi_enable_chip(dws, 0);
 
 	/* Handle per transfer options for bpw and speed */
-- 
2.25.1



