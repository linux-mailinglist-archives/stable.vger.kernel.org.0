Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0801C4094F5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbhIMOgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347539AbhIMOem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E4BF61BD2;
        Mon, 13 Sep 2021 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541194;
        bh=b9YNcmCliiO5LuW1S8Qk0bHedHDC6m3En6NGtRIFRVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZQd63UZNEjFksGZfICdy7C2ZaOYgZ7yjTVKtC1EWbCjPvdpeAOuKWbOC/rkKghIb
         6pn3mkqGrexOkEPZBLMtkZ8detrCvP7zvl74i3dTc+Tj+3mgfrPYrolX63bn446jE+
         cCAefoAsHezf5DkODUpQRLmkI9HkCIMhShf4aHAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 200/334] usb: dwc3: qcom: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:14 +0200
Message-Id: <20210913131120.171679482@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 49e6ca94486d..cfbb96f6627e 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -614,6 +614,10 @@ static int dwc3_qcom_acpi_register_core(struct platform_device *pdev)
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



