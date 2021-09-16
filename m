Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A253840E333
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245023AbhIPQqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343681AbhIPQoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B15061A54;
        Thu, 16 Sep 2021 16:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809520;
        bh=r/XfC9YknuEJTwDT2ObfBukG4ljdVEksqJ+CNLioO00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCPmCO1hIHp3bp7R+uOYOlwaMrlw+ntXGOWTfb3FZU3FF+FFcOuwmHRUDy1SwbuMM
         /w2nSuTjTXEsXxnfV1790qWgjV31biPKQTyuidyD5KWesJ/Uw46VF34AmpqzHmL3xR
         4FsWjW33etQgTCJ9oAWGo5H/RYrytNkI5PCAjznI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 185/380] media: atomisp: Fix runtime PM imbalance in atomisp_pci_probe
Date:   Thu, 16 Sep 2021 17:59:02 +0200
Message-Id: <20210916155810.368118033@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



