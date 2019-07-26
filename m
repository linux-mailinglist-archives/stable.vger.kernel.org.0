Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E3176CD0
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfGZP1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388279AbfGZP1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:27:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2853205F4;
        Fri, 26 Jul 2019 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154859;
        bh=bJ6vLAfgnLHvKGBIv3dTVvxQABq1s5guCM+M2X+jl2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pM8pBJGxADj+tEKOM6EgiAb6LEpF0r2KmvZTeUJbAtXlal4eEyl9ebzf9QQORCTje
         EqdbCp9vir/xQebj3EHrlag+GbVtWdCq7pvA+CyzvtlV8DOF2XJMPqyedT2OuH3q+D
         Lh/dDbLsiEf0Z+Gyz0sgzJGjFyYgoTTJi7xTnVME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.2 51/66] gpio: davinci: silence error prints in case of EPROBE_DEFER
Date:   Fri, 26 Jul 2019 17:24:50 +0200
Message-Id: <20190726152307.474310410@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
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
@@ -238,8 +238,9 @@ static int davinci_gpio_probe(struct pla
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


