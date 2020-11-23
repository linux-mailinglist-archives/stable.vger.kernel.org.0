Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0075B2C08E2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388282AbgKWNCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387691AbgKWMwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:52:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA0552100A;
        Mon, 23 Nov 2020 12:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135921;
        bh=TsNWTANIt7WdCQ4d/Y7OwMq2cI1gmLGa4f8d/Zrj+pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvDa0yxb+NcbJ6VgDLP+AONWY76ph7jf/cdmwJfay7NlNY7TmHTdlAYdbjv/eiMt8
         eiTpzciBo08JtiFwXfkap6nX+MAFkb8Wo9MmFrVZxy6sKogxuGAqbx17CesWYhuZtd
         2UgVCRw4/JhPgEeDIWIBeWYXP1ci27E9u2Q0hvH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.9 214/252] iio/adc: ingenic: Fix battery VREF for JZ4770 SoC
Date:   Mon, 23 Nov 2020 13:22:44 +0100
Message-Id: <20201123121845.897294214@linuxfoundation.org>
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

From: Paul Cercueil <paul@crapouillou.net>

commit c91ebcc578e09783cfa4d85c1b437790f140f29a upstream.

The reference voltage for the battery is clearly marked as 1.2V in the
programming manual. With this fixed, the battery channel now returns
correct values.

Fixes: a515d6488505 ("IIO: Ingenic JZ47xx: Add support for JZ4770 SoC ADC.")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Artur Rojek <contact@artur-rojek.eu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201104192843.67187-1-paul@crapouillou.net
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ingenic-adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ingenic-adc.c
+++ b/drivers/iio/adc/ingenic-adc.c
@@ -71,7 +71,7 @@
 #define JZ4725B_ADC_BATTERY_HIGH_VREF_BITS	10
 #define JZ4740_ADC_BATTERY_HIGH_VREF		(7500 * 0.986)
 #define JZ4740_ADC_BATTERY_HIGH_VREF_BITS	12
-#define JZ4770_ADC_BATTERY_VREF			6600
+#define JZ4770_ADC_BATTERY_VREF			1200
 #define JZ4770_ADC_BATTERY_VREF_BITS		12
 
 #define JZ_ADC_IRQ_AUX			BIT(0)


