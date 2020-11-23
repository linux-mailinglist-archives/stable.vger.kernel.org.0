Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9262C067D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730825AbgKWMbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgKWMbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:31:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B31E720728;
        Mon, 23 Nov 2020 12:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134682;
        bh=4sUJEDl6ADc5HI+sgFrw1jtU5QNzKww3fVWXTn0l5us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZi6OE5j6v/H0+CDArdoQk0sTi9aYPlWTJjA7RIumm98/dDw8zW1qUvsITI/jeZop
         Ui+JnNziUoh1m7fXZFrTrZkvgqFDwhkDPLFzbEVOS7BDuySjV1y/lVn7m1tpVqB0W4
         cZfFv5KFN7YidGW413skhiSUg2vbWuSZmaTQ9cfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/91] Input: resistive-adc-touch - fix kconfig dependency on IIO_BUFFER
Date:   Mon, 23 Nov 2020 13:22:05 +0100
Message-Id: <20201123121811.508200520@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 676650d007e06fddcf3fe38238251d71bd179641 ]

When TOUCHSCREEN_ADC is enabled and IIO_BUFFER is disabled, it results
in the following Kbuild warning:

WARNING: unmet direct dependencies detected for IIO_BUFFER_CB
  Depends on [n]: IIO [=y] && IIO_BUFFER [=n]
  Selected by [y]:
  - TOUCHSCREEN_ADC [=y] && !UML && INPUT [=y] && INPUT_TOUCHSCREEN [=y] && IIO [=y]

The reason is that TOUCHSCREEN_ADC selects IIO_BUFFER_CB without depending
on or selecting IIO_BUFFER while IIO_BUFFER_CB depends on IIO_BUFFER. This
can also fail building the kernel.

Honor the kconfig dependency to remove unmet direct dependency warnings
and avoid any potential build failures.

Fixes: aa132ffb6b0a ("input: touchscreen: resistive-adc-touch: add generic resistive ADC touchscreen")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20201102221504.541279-1-fazilyildiran@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 2a80675cfd947..de400d76df55a 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -95,6 +95,7 @@ config TOUCHSCREEN_AD7879_SPI
 config TOUCHSCREEN_ADC
 	tristate "Generic ADC based resistive touchscreen"
 	depends on IIO
+	select IIO_BUFFER
 	select IIO_BUFFER_CB
 	help
 	  Say Y here if you want to use the generic ADC
-- 
2.27.0



