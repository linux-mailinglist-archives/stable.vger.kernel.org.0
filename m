Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080323C5547
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355490AbhGLIJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353402AbhGLICI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7589861222;
        Mon, 12 Jul 2021 07:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076498;
        bh=9mTz9qCOuj4S8M3/VIJtVbByzHuDYY0u+y6Uu0rnKn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vV5834+p+TQYfFSiewrFKR/EewfUx2Sm9zFiEwuZSKDjnQq+oJ//CnTFDtgdTvn1G
         pLGESuWvRzTAOITcK2j2a8A3iC8pIA23Ye6nR74rTJD7gdxk15FfzPqvwqj+nG06HT
         RtqHrIn8EjusQyofjgITvgKjFd+YQei2aeACgS3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 670/800] mfd: rn5t618: Fix IRQ trigger by changing it to level mode
Date:   Mon, 12 Jul 2021 08:11:33 +0200
Message-Id: <20210712061038.229585665@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit a1649a5260631979c68e5b2012f60f90300e646f ]

During more massive generation of interrupts, the IRQ got stuck,
and the subdevices did not see any new interrupts. That happens
especially at wonky USB supply in combination with ADC reads.
To fix that trigger the IRQ at level low instead of falling edge.

Fixes: 0c81604516af ("mfd: rn5t618: Add IRQ support")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rn5t618.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rn5t618.c b/drivers/mfd/rn5t618.c
index 6ed04e6dbc78..384acb459427 100644
--- a/drivers/mfd/rn5t618.c
+++ b/drivers/mfd/rn5t618.c
@@ -107,7 +107,7 @@ static int rn5t618_irq_init(struct rn5t618 *rn5t618)
 
 	ret = devm_regmap_add_irq_chip(rn5t618->dev, rn5t618->regmap,
 				       rn5t618->irq,
-				       IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				       IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 				       0, irq_chip, &rn5t618->irq_data);
 	if (ret)
 		dev_err(rn5t618->dev, "Failed to register IRQ chip\n");
-- 
2.30.2



