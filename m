Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D82404A2A
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbhIILpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238930AbhIILnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26AB56121E;
        Thu,  9 Sep 2021 11:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187737;
        bh=xbxYGYIg0UL75d3G0fWo/RQD4FPUCgMdfo9m49n9B04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjwyaAlZqMeFves7jb9Ccc0UyabePY6y+P/Xxr0YIaTJchLVfvMUyzh2btB5VOTGB
         ftsMVcjd98683lrVY6siqyhl7bYeBKMAZZkR2dWpyEeNIXY65zeNSsXQVCQ6IDlYBb
         4bqG3Pre4maXpa2UtwEqvK3lJtve3AYraFYYBfeAzxQJ8JiejX8l47FiuiRl0OeIcU
         VQI2g0/rFCNQYVwIGliAxpzsWUHJUTm8lUuVFardTFLvLGIrn7U4ZtwBXKaREpQn5O
         Izlclb9pH/7mpPjRrln6XwQKzy8by/JsiQhS0QM0e4XokKgT3QTl8lh1RlxZzOYMFc
         vmXtpABukevHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.14 055/252] media: atomisp: Fix runtime PM imbalance in atomisp_pci_probe
Date:   Thu,  9 Sep 2021 07:37:49 -0400
Message-Id: <20210909114106.141462-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 672fe1cf145ab9978c62eb827d6a16aa6b63994b ]

When hmm_pool_register() fails, a pairing PM usage counter
increment is needed to keep the counter balanced. It's the
same for the following error paths.

Link: https://lore.kernel.org/linux-media/20210408081850.24278-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
index 948769ca6539..af0d83eaa68c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
@@ -1815,6 +1815,7 @@ static int atomisp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	hmm_cleanup();
 	hmm_pool_unregister(HMM_POOL_TYPE_RESERVED);
 hmm_pool_fail:
+	pm_runtime_get_noresume(&pdev->dev);
 	destroy_workqueue(isp->wdt_work_queue);
 wdt_work_queue_fail:
 	atomisp_acc_cleanup(isp);
-- 
2.30.2

