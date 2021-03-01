Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368C9328868
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhCARjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238286AbhCARcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:32:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3DD2650A3;
        Mon,  1 Mar 2021 16:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617591;
        bh=7MZz66UTo9uiQiZ9n+5f0he0thM7huuZ/f0FVwoJM+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UK1MsZa83d7Pnki9VipS4wb/QWHA2RVCxWWlplibR7l6SQKfdCuaGqUDMFKB09Fbn
         bOU+EC9yrPmzfNqFk+Mc0qw62eq7xJ8vG7wzMTsJoC/HqS2A/Dsqb2ABox/XsI4izK
         KWiCn5yo8DGosUaADvcRO6br9qMwOJCXHiwI4mS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Sebastian Reichel <sre@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/340] HSI: Fix PM usage counter unbalance in ssi_hw_init
Date:   Mon,  1 Mar 2021 17:11:10 +0100
Message-Id: <20210301161054.519416985@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit aa57e77b3d28f0df07149d88c47bc0f3aa77330b ]

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced.

Fixes: b209e047bc743 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 2be9c01e175ca..f36036be7f032 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -424,7 +424,7 @@ static int ssi_hw_init(struct hsi_controller *ssi)
 	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
 	int err;
 
-	err = pm_runtime_get_sync(ssi->device.parent);
+	err = pm_runtime_resume_and_get(ssi->device.parent);
 	if (err < 0) {
 		dev_err(&ssi->device, "runtime PM failed %d\n", err);
 		return err;
-- 
2.27.0



