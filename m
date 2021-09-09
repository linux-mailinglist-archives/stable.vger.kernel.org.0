Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545134050F3
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343785AbhIIMc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353993AbhIIM1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:27:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89C0561264;
        Thu,  9 Sep 2021 11:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188323;
        bh=r/XfC9YknuEJTwDT2ObfBukG4ljdVEksqJ+CNLioO00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkaMjinvtOSPLjZFyPE8rhAZPx/IBkfFtxr6h/SNG4LFb2rxeWrI694l24XT49mMY
         n8D1pI+/Z8Ojw3BrgAMtHn7KCx02/BOy+UM5LSTdQvTjAHbARVNlWvQlfkuDQBdDcy
         bf1CEqq3niZJFiBOV6qa44wJr+eyqpWP9s0zgAiH92XUhhKwSixp4exN2BnxTmYv+E
         9OMdjRXMf7pE1kkTOTjYrjr0ua4h20QuPCaVaMhyyh+9tUbDiQfCFn465bo1kNLAm7
         q3zloYDPvElgE4VQm6NPD7E7lEVS224VNxnmfN6fxN8Bw67Ijb0ajxQnqSj84wn/wH
         +cILkRJWyryJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 035/176] media: atomisp: Fix runtime PM imbalance in atomisp_pci_probe
Date:   Thu,  9 Sep 2021 07:48:57 -0400
Message-Id: <20210909115118.146181-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 0295e2e32d79..02f774ed80c8 100644
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

