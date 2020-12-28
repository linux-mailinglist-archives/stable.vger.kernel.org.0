Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723332E3D5B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440462AbgL1OOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440459AbgL1OOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28BC322583;
        Mon, 28 Dec 2020 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164840;
        bh=tphTNjRLSl3fsJBkdTOwUuY0O+F+ZYTjdTi7eEsGz7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mvr6oNHwUVOu0VYtSMgSAyoLMlAgsgPwdcPpffIJQmkxlf4xbN8f2pv5kOl10gmG8
         seo8nOJU9yilbHcsEjnvJmIRXDcKnIylXcKr+nIoDZYAf55xmjdmsm9Trf2xelSMBl
         5UkQhd+uldQ09jLihw1Wx440hcoeYq+P1fFhkELM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/717] memory: jz4780_nemc: Fix potential NULL dereference in jz4780_nemc_probe()
Date:   Mon, 28 Dec 2020 13:45:16 +0100
Message-Id: <20201228125036.269677844@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 4bfa07300b9334b487ed4f3d4901c35ebb31b7ca ]

platform_get_resource() may fail and return NULL, so we should
better check it's return value to avoid a NULL pointer dereference
a bit later in the code.

This is detected by Coccinelle semantic patch.

Fixes: 911a88829725 ("memory: jz4780-nemc: driver for the NEMC on JZ4780 SoCs")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/1607070717-32880-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/jz4780-nemc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/jz4780-nemc.c b/drivers/memory/jz4780-nemc.c
index 3ec5cb0fce1ee..465ea92990d7e 100644
--- a/drivers/memory/jz4780-nemc.c
+++ b/drivers/memory/jz4780-nemc.c
@@ -291,6 +291,8 @@ static int jz4780_nemc_probe(struct platform_device *pdev)
 	nemc->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	/*
 	 * The driver currently only uses the registers up to offset
-- 
2.27.0



