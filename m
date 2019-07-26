Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEF076DD3
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbfGZPau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389146AbfGZPat (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:30:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F87B205F4;
        Fri, 26 Jul 2019 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155048;
        bh=TtIz97idgvK/ebngtPfSIyiQsgALKx7b8XEflyfLeM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wh8t8mNQC15XbX9VQfJQjN8Ju5jMJ6l6PtNd1JHLiXb+86+HuL3TKPbrMK301QRSN
         wuP5tUPZ2XSpg/WILIEBmj/5hMkFpuNyJ/ecqsRmeoPdKZeI5k8Pvzr0iP2ADD58/V
         WsXNIOC546iQpN5G+d/JbpT1ZX7x+AsqVYpJGqz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.1 46/62] gpio: davinci: silence error prints in case of EPROBE_DEFER
Date:   Fri, 26 Jul 2019 17:24:58 +0200
Message-Id: <20190726152306.862106492@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

commit 541e4095f388c196685685633c950cb9b97f8039 upstream.

Silence error prints in case of EPROBE_DEFER. This avoids
multiple/duplicate defer prints during boot.

Cc: <stable@vger.kernel.org>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-davinci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -242,8 +242,9 @@ static int davinci_gpio_probe(struct pla
 	for (i = 0; i < nirq; i++) {
 		chips->irqs[i] = platform_get_irq(pdev, i);
 		if (chips->irqs[i] < 0) {
-			dev_info(dev, "IRQ not populated, err = %d\n",
-				 chips->irqs[i]);
+			if (chips->irqs[i] != -EPROBE_DEFER)
+				dev_info(dev, "IRQ not populated, err = %d\n",
+					 chips->irqs[i]);
 			return chips->irqs[i];
 		}
 	}


