Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29999CA802
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393028AbfJCQry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393029AbfJCQrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 657A62070B;
        Thu,  3 Oct 2019 16:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121272;
        bh=dWZQeEXELj4oPCyvPKatzqbyZkyD3e/BEQa+Mm6YXN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoTAn9HrRhsSoLMUk8f8k6rBCr6FmUQJ0xSRpQ5IzvqhK1TXz5c6ntP3/tYoi/9mj
         HNgXSEZOgxyaV1L2+3ZIs4JA4LguYlhq7GQLP4oy6KWp0yUKz9EA6UQ6qICiq+7j8J
         PLza7exYPTG+sOLaq/EsmWQQxxz/j1C1EMOPz+9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 217/344] mmc: mtk-sd: Re-store SDIO IRQs mask at system resume
Date:   Thu,  3 Oct 2019 17:53:02 +0200
Message-Id: <20191003154601.711711454@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 1c81d69d4c98aab56c5a7d5a810f84aefdb37e9b ]

In cases when SDIO IRQs have been enabled, runtime suspend is prevented by
the driver. However, this still means msdc_runtime_suspend|resume() gets
called during system suspend/resume, via pm_runtime_force_suspend|resume().

This means during system suspend/resume, the register context of the mtk-sd
device most likely loses its register context, even in cases when SDIO IRQs
have been enabled.

To re-enable the SDIO IRQs during system resume, the mtk-sd driver
currently relies on the mmc core to re-enable the SDIO IRQs when it resumes
the SDIO card, but this isn't the recommended solution. Instead, it's
better to deal with this locally in the mtk-sd driver, so let's do that.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 33f4b6387ef71..978c8ccce7e31 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2421,6 +2421,9 @@ static void msdc_restore_reg(struct msdc_host *host)
 	} else {
 		writel(host->save_para.pad_tune, host->base + tune_reg);
 	}
+
+	if (sdio_irq_claimed(host->mmc))
+		__msdc_enable_sdio_irq(host, 1);
 }
 
 static int msdc_runtime_suspend(struct device *dev)
-- 
2.20.1



