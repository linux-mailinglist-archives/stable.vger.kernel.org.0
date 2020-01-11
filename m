Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84F3137F4E
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgAKKSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbgAKKSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:18:15 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 265602077C;
        Sat, 11 Jan 2020 10:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737895;
        bh=PA4FxnAk4aNpdZ8YIp/EAybWfqD/vW0X7F1oDdtjVRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wj3IDEdJL8neA8Evvi1grqr0Fy3O9oQaJoNcfGCos2/smjLMoEQqOgrBQhUf0HTKi
         ffU54kd0xSqcod96AeU1N5hkv7BpQamTD6UVS2RXNPl9kSvNpb6mWQTe6yqLhXm5Fo
         GJZQtpGX12/gon2Ibb2jV29HWD309TjH8JMxtwQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Inki Dae <inki.dae@samsung.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/84] drm/exynos: gsc: add missed component_del
Date:   Sat, 11 Jan 2020 10:50:30 +0100
Message-Id: <20200111094906.379794988@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 84c92365b20a44c363b95390ea00dfbdd786f031 ]

The driver forgets to call component_del in remove to match component_add
in probe.
Add the missed call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Inki Dae <inki.dae@samsung.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 7ba414b52faa..d71188b982cb 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1292,6 +1292,7 @@ static int gsc_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 
+	component_del(dev, &gsc_component_ops);
 	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
 
-- 
2.20.1



