Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2731D408F57
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241508AbhIMNmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243796AbhIMNkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:40:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF681613E6;
        Mon, 13 Sep 2021 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539754;
        bh=gq9saXxtRIw3MZSwBY8JRo4yxAZ8lKok2m4Ej0sohjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/+A8qLuApsXX97Muj6/bP/iczF9R3d2My8k6JytmaSiD6GLE5Cjk0d2K3PUzxAgV
         0W49/GY3KNYWnWu6piWt/AJ1G9qG9ZqZJT2lO2gDAYXIfA9hqMEymEexrd1I/YAJGB
         uJwPXPaY+ICbDGUOoKVWdJvq7RsG1g8q4I1BTKWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/236] usb: dwc3: qcom: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:13 +0200
Message-Id: <20210913131105.396337827@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 175006956740f70ca23394c58f8d7804776741bd ]

In dwc3_qcom_acpi_register_core(), the driver neglects to check the result
of platform_get_irq()'s call and blithely assigns the negative error codes
to the allocated child device's IRQ resource and then passing this resource
to platform_device_add_resources() and later causing dwc3_otg_get_irq() to
fail anyway.  Stop calling platform_device_add_resources() with the invalid
IRQ #s, so that there's less complexity in the IRQ error checking.

Fixes: 2bc02355f8ba ("usb: dwc3: qcom: Add support for booting with ACPI")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/45fec3da-1679-5bfe-5d74-219ca3fb28e7@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 8bd077fb1190..2a29e2f681fe 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -610,6 +610,10 @@ static int dwc3_qcom_acpi_register_core(struct platform_device *pdev)
 		qcom->acpi_pdata->dwc3_core_base_size;
 
 	irq = platform_get_irq(pdev_irq, 0);
+	if (irq < 0) {
+		ret = irq;
+		goto out;
+	}
 	child_res[1].flags = IORESOURCE_IRQ;
 	child_res[1].start = child_res[1].end = irq;
 
-- 
2.30.2



