Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30089412620
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386083AbhITSxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385521AbhITSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A732C61527;
        Mon, 20 Sep 2021 17:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159307;
        bh=iWpQz4tSFoRFavqd00yNJF85NFFxJrunEhC7CELaIIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L19DhpTv2XJB2QnZO2UVQHuc+00JowPdd/LlRWTyGGmrM6EJDQ0CEV9AlMGcsmln7
         9pwb1mrpc13ttlU1yGpZF0gcddZ8DhQ1VYZYVR+n4409wU1D03G0CLJe8BjebeDbSu
         Lqy64FR4u2MmmjGwIkm11tuNKhav6BlvUcXzX99A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Andrew Lunn <andrew@lunn.ch>, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 129/168] mfd: tqmx86: Clear GPIO IRQ resource when no IRQ is set
Date:   Mon, 20 Sep 2021 18:44:27 +0200
Message-Id: <20210920163925.907385045@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit a946506c48f3bd09363c9d2b0a178e55733bcbb6 ]

The driver was registering IRQ 0 when no IRQ was set. This leads to
warnings with newer kernels.

Clear the resource flags, so no resource is registered at all in this
case.

Fixes: 2f17dd34ffed ("mfd: tqmx86: IO controller with I2C, Wachdog and GPIO")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tqmx86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/tqmx86.c b/drivers/mfd/tqmx86.c
index ddddf08b6a4c..732013f40e4e 100644
--- a/drivers/mfd/tqmx86.c
+++ b/drivers/mfd/tqmx86.c
@@ -209,6 +209,8 @@ static int tqmx86_probe(struct platform_device *pdev)
 
 		/* Assumes the IRQ resource is first. */
 		tqmx_gpio_resources[0].start = gpio_irq;
+	} else {
+		tqmx_gpio_resources[0].flags = 0;
 	}
 
 	ocores_platfom_data.clock_khz = tqmx86_board_id_to_clk_rate(board_id);
-- 
2.30.2



