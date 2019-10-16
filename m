Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD718D9EFA
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbfJPWEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438433AbfJPV7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:14 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E6C2218DE;
        Wed, 16 Oct 2019 21:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263153;
        bh=sa4eUBZuMlSSMi6W6tiquabBPrqcRrjXGCzvIZP5hbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmXX370ttx2//i3VdFADpYVNXIoghpVHbXkez4XiTyjzh7K1dMLUJIT0VAeZn7UHK
         Rxg/NwK2LGJG6lZW4qe/QgkQki1Ay3Hl70PIg6+sqVo0nfqKFOjgGFfBqFrHPJfSkQ
         hwcUQu7Jj2Vej5rOREx4CEmLekXmH5L8j3pu1wnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 081/112] gpio: fix getting nonexclusive gpiods from DT
Date:   Wed, 16 Oct 2019 14:51:13 -0700
Message-Id: <20191016214904.616631307@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit be7ae45cfea97e787234e00e1a9eb341acacd84e ]

Since commit ec757001c818 ("gpio: Enable nonexclusive gpiods from DT
nodes") we are able to get GPIOD_FLAGS_BIT_NONEXCLUSIVE marked gpios.
Currently the gpiolib uses the wrong flags variable for the check. We
need to check the gpiod_flags instead of the of_gpio_flags else we
return -EBUSY for GPIOD_FLAGS_BIT_NONEXCLUSIVE marked and requested
gpiod's.

Fixes: ec757001c818 gpio: Enable nonexclusive gpiods from DT nodes
Cc: stable@vger.kernel.org
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
[Bartosz: the function was moved to gpiolib-of.c so updated the patch]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
[Bartosz: backported to v5.3.y]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d9074191edef4..e4203c1eb869d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4303,7 +4303,7 @@ struct gpio_desc *gpiod_get_from_of_node(struct device_node *node,
 	transitory = flags & OF_GPIO_TRANSITORY;
 
 	ret = gpiod_request(desc, label);
-	if (ret == -EBUSY && (flags & GPIOD_FLAGS_BIT_NONEXCLUSIVE))
+	if (ret == -EBUSY && (dflags & GPIOD_FLAGS_BIT_NONEXCLUSIVE))
 		return desc;
 	if (ret)
 		return ERR_PTR(ret);
-- 
2.20.1



