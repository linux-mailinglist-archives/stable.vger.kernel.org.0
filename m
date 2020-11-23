Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE3C2C0850
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732451AbgKWMsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:48:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:32992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732780AbgKWMri (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E2122168B;
        Mon, 23 Nov 2020 12:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135656;
        bh=EZa6qFIHbne+64W7iNVWwcYC8Ztt5HO+D7wJisHg/NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vVBDWxPBg0eACf8PpCNkZFt1cRZQx8lKs94009e/S6uVRjkUu9WFnRg4przDAQsB
         nkxk7oEpgCGkAKi0pC+DYpsFh9/1zo0mYgxCIC2XEThqZF1wM0fsEacuTw+T2HWEUF
         abkAmg1RHIyIXXt6TM6NZMMKS/kaR5MFyfnY8UmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 117/252] Input: resistive-adc-touch - fix kconfig dependency on IIO_BUFFER
Date:   Mon, 23 Nov 2020 13:21:07 +0100
Message-Id: <20201123121841.238963532@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
index 35c867b2d9a77..e6e043388a972 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -96,6 +96,7 @@ config TOUCHSCREEN_AD7879_SPI
 config TOUCHSCREEN_ADC
 	tristate "Generic ADC based resistive touchscreen"
 	depends on IIO
+	select IIO_BUFFER
 	select IIO_BUFFER_CB
 	help
 	  Say Y here if you want to use the generic ADC
-- 
2.27.0



