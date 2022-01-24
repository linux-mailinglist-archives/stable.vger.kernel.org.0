Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F36B499940
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352192AbiAXVeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34862 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345360AbiAXVOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E247CB812A5;
        Mon, 24 Jan 2022 21:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005F3C340E5;
        Mon, 24 Jan 2022 21:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058847;
        bh=VhfLq6rswzGbOL/ljKj6bPc7+9MR7Lf4elfV0tKpNaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiqhslUg9G91Rkev+dFHHnkZHnNamJ7z0obY87r71QaNA9OW4a8/s0Ed/f6gvySrH
         tzQWghOX+deUTdhRtMyjQseWOTLaqm5oiO/WcH6NtpQpHkZIX/op1QscM0z5uEdtp5
         /rCAJXumfI8Vf70KkVDJ56sa52R/vI2EVW5h0mq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0422/1039] spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe
Date:   Mon, 24 Jan 2022 19:36:51 +0100
Message-Id: <20220124184139.493000067@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 69c1b87516e327a60b39f96b778fe683259408bf ]

If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().
Add missing pm_runtime_disable() for meson_spifc_probe.

Fixes: c3e4bc5434d2 ("spi: meson: Add support for Amlogic Meson SPIFC")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220107075424.7774-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spifc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-meson-spifc.c b/drivers/spi/spi-meson-spifc.c
index 8eca6f24cb799..c8ed7815c4ba6 100644
--- a/drivers/spi/spi-meson-spifc.c
+++ b/drivers/spi/spi-meson-spifc.c
@@ -349,6 +349,7 @@ static int meson_spifc_probe(struct platform_device *pdev)
 	return 0;
 out_clk:
 	clk_disable_unprepare(spifc->clk);
+	pm_runtime_disable(spifc->dev);
 out_err:
 	spi_master_put(master);
 	return ret;
-- 
2.34.1



