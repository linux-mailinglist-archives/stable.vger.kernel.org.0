Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB3A3C4D6F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbhGLHNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245022AbhGLHLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC4860FF0;
        Mon, 12 Jul 2021 07:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073712;
        bh=jLagBNkpwz2CdsX2bpqc1aEG1+0SE3pWJkgr5G3y5Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkIo9rm3C+QNnczLFK/857xfQtJNVESTgMcBQYKMaL8sUHXgBgJWTM9T15i51+vG2
         rRgsHg2RQFq0YiKJq7XVe7BLD5a32HHJ33v6rCWNSUC67dg7oUOKQWqGyXmcjZ5m15
         N6D3x17Nb9nNcRD9ICVu5XZXHeeP1P5SwWxEf5+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 333/700] extcon: extcon-max8997: Fix IRQ freeing at error path
Date:   Mon, 12 Jul 2021 08:06:56 +0200
Message-Id: <20210712061011.830294109@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 610bdc04830a864115e6928fc944f1171dfff6f3 ]

If reading MAX8997_MUIC_REG_STATUS1 fails at probe the driver exits
without freeing the requested IRQs.

Free the IRQs prior returning if reading the status fails.

Fixes: 3e34c8198960 ("extcon: max8997: Avoid forcing UART path on drive probe")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://lore.kernel.org/r/27ee4a48ee775c3f8c9d90459c18b6f2b15edc76.1623146580.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-max8997.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 337b0eea4e62..5c4f7746cbee 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -729,7 +729,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 				2, info->status);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
-		return ret;
+		goto err_irq;
 	}
 	cable_type = max8997_muic_get_cable_type(info,
 					   MAX8997_CABLE_GROUP_ADC, &attached);
-- 
2.30.2



