Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5E129B9B1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802729AbgJ0PvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802173AbgJ0Ppx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7312822202;
        Tue, 27 Oct 2020 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813553;
        bh=6mYzDgJcOvDJXh+Tmg2NuyyLlvNXj+9TQ0gkWTS9jaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYgo3Bjgb3za/kIMWEoAB7UuUXC/grUMsmejPzkJmbpX8gxBs2dZMki/wgIsb9BQp
         AWNyaQusA48ABMffGbTRHnOREgvPWkOFO4xzudUDa4S5JSiPWWcmaEALiZYTmPLlzi
         BPUO+S8kXYQGqe/jX589Zvka2749T2Mk9DBa6Z7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Roger Quadros <rogerq@ti.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 591/757] memory: omap-gpmc: Fix build error without CONFIG_OF
Date:   Tue, 27 Oct 2020 14:54:01 +0100
Message-Id: <20201027135518.254433173@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 13d029ee51da365aa9c859db0c7395129252bde8 ]

If CONFIG_OF is n, gcc fails:

drivers/memory/omap-gpmc.o: In function `gpmc_omap_onenand_set_timings':
    omap-gpmc.c:(.text+0x2a88): undefined reference to `gpmc_read_settings_dt'

Add gpmc_read_settings_dt() helper function, which zero the gpmc_settings
so the caller doesn't proceed with random/invalid settings.

Fixes: a758f50f10cf ("mtd: onenand: omap2: Configure driver from DT")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Roger Quadros <rogerq@ti.com>
Link: https://lore.kernel.org/r/20200827125316.20780-1-yuehaibing@huawei.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/omap-gpmc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
index 1e6d6e9434c8b..057666e1b6cda 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -2265,6 +2265,10 @@ static void gpmc_probe_dt_children(struct platform_device *pdev)
 	}
 }
 #else
+void gpmc_read_settings_dt(struct device_node *np, struct gpmc_settings *p)
+{
+	memset(p, 0, sizeof(*p));
+}
 static int gpmc_probe_dt(struct platform_device *pdev)
 {
 	return 0;
-- 
2.25.1



