Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F868111CE1
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfLCWs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:48:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729422AbfLCWsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:48:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA3B120656;
        Tue,  3 Dec 2019 22:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413299;
        bh=um8tu6uAw/zbChLCopYomwAWYNQNltHoeeW4RgTCtXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2XQASogancISfoeepPr/Vz7LzHKuibinsIhAbqDhZolLDq0GwzVfnnNPy9tA75Pl
         +/DbZf8a/vIfdW/ds8O3eiuzdIxDU96AbJE5v0Z37XdviQ16chVAoPWemIm/EZ9K4r
         ZR0ZFZNTu3dKpriJ3OVSU/DBNiD/km+VCccs0URs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@mellanox.com>,
        "Darren Hart (VMware)" <dvhart@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/321] platform/x86: mlx-platform: Fix LED configuration
Date:   Tue,  3 Dec 2019 23:32:20 +0100
Message-Id: <20191203223431.012941331@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit 440f343df1996302d9a3904647ff11b689bf27bc ]

Exchange LED configuration between msn201x and next generation systems
types.

Bug was introduced when LED driver activation was added to mlx-platform.
LED configuration for the three new system MQMB7, MSN37, MSN34 was
assigned to MSN21 and vice versa. This bug affects MSN21 only and
likely requires backport to v4.19.

Fixes: 1189456b1cce ("platform/x86: mlx-platform: Add LED platform driver activation")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Darren Hart (VMware) <dvhart@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index d17db140cb1fc..69e28c12d5915 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -1421,7 +1421,7 @@ static int __init mlxplat_dmi_msn201x_matched(const struct dmi_system_id *dmi)
 	mlxplat_hotplug = &mlxplat_mlxcpld_msn201x_data;
 	mlxplat_hotplug->deferred_nr =
 		mlxplat_default_channels[i - 1][MLXPLAT_CPLD_GRP_CHNL_NUM - 1];
-	mlxplat_led = &mlxplat_default_ng_led_data;
+	mlxplat_led = &mlxplat_msn21xx_led_data;
 	mlxplat_regs_io = &mlxplat_msn21xx_regs_io_data;
 
 	return 1;
@@ -1439,7 +1439,7 @@ static int __init mlxplat_dmi_qmb7xx_matched(const struct dmi_system_id *dmi)
 	mlxplat_hotplug = &mlxplat_mlxcpld_default_ng_data;
 	mlxplat_hotplug->deferred_nr =
 		mlxplat_msn21xx_channels[MLXPLAT_CPLD_GRP_CHNL_NUM - 1];
-	mlxplat_led = &mlxplat_msn21xx_led_data;
+	mlxplat_led = &mlxplat_default_ng_led_data;
 	mlxplat_fan = &mlxplat_default_fan_data;
 
 	return 1;
-- 
2.20.1



