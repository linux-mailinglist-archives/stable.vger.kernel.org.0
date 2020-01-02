Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B5D12EF34
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgABWoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730001AbgABWdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:33:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B66A22525;
        Thu,  2 Jan 2020 22:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004404;
        bh=byk/T/blC6QdqOmM5SuAxsXo+9ZoWInFeQF+sh/tvVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbaC0g5d5Xa9LFpGozYzliXV7FN+nkJJa4V0z5XmxInPijBJf/+af3XPYQJogRrJG
         lmoqPwQh04f338wvAfR0fhM+f3+076ldNj3eWd7kCtFzq3S93z8PDRUXMv/8VbHiLu
         TeKqQimAWhKWfOHiFNGIcDh45cuC7DIA3ljrwjlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 165/171] mmc: sdhci: Update the tuning failed messages to pr_debug level
Date:   Thu,  2 Jan 2020 23:08:16 +0100
Message-Id: <20200102220609.634841607@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

Tuning support in DDR50 speed mode was added in SD Specifications Part1
Physical Layer Specification v3.01. Its not possible to distinguish
between v3.00 and v3.01 from the SCR and that is why since
commit 4324f6de6d2e ("mmc: core: enable CMD19 tuning for DDR50 mode")
tuning failures are ignored in DDR50 speed mode.

Cards compatible with v3.00 don't respond to CMD19 in DDR50 and this
error gets printed during enumeration and also if retune is triggered at
any time during operation. Update the printk level to pr_debug so that
these errors don't lead to false error reports.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Cc: stable@vger.kernel.org # v4.4+
Link: https://lore.kernel.org/r/20191206114326.15856-1-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index df306caba296..bd43dc7f4c63 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2098,7 +2098,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		spin_lock_irqsave(&host->lock, flags);
 
 		if (!host->tuning_done) {
-			pr_info(DRIVER_NAME ": Timeout waiting for Buffer Read Ready interrupt during tuning procedure, falling back to fixed sampling clock\n");
+			pr_debug(DRIVER_NAME ": Timeout waiting for Buffer Read Ready interrupt during tuning procedure, falling back to fixed sampling clock\n");
 			ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 			ctrl &= ~SDHCI_CTRL_TUNED_CLK;
 			ctrl &= ~SDHCI_CTRL_EXEC_TUNING;
-- 
2.20.1



