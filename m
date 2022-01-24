Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0BF499515
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392198AbiAXUui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358023AbiAXUnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:43:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1172EC019B2B;
        Mon, 24 Jan 2022 11:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFDCAB8122F;
        Mon, 24 Jan 2022 19:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097C8C340E5;
        Mon, 24 Jan 2022 19:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054003;
        bh=81xl3sgM260UXnSFz+zCoNVTk3dN1gWBm6MwUjmOT7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjLuGwQTbfL7qXzMfJMQ4qc1jz+WRbPAGZ8xBpXf/XLYkTlhvBPwxGa+0TfF7k6Bn
         +gTBNztk3Tpf/Y+vZQ1MHMCRQyEFSTi8LVReBd+sxZt+R89rtzbHzKPkprpS2rMnuz
         671wwAPEXuwqjZiJ5G2acF4Vid0ilrkE0/Ghr1iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/563] usb: dwc3: qcom: Fix NULL vs IS_ERR checking in dwc3_qcom_probe
Date:   Mon, 24 Jan 2022 19:39:39 +0100
Message-Id: <20220124184031.855228474@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b52fe2dbb3e655eb1483000adfab68a219549e13 ]

Since the acpi_create_platform_device() function may return error
pointers, dwc3_qcom_create_urs_usb_platdev() function may return error
pointers too. Using IS_ERR_OR_NULL() to check the return value to fix this.

Fixes: c25c210f590e ("usb: dwc3: qcom: add URS Host support for sdm845 ACPI boot")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20211222111823.22887-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 2a29e2f681fe6..504f8af4d0f80 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -764,9 +764,12 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 
 		if (qcom->acpi_pdata->is_urs) {
 			qcom->urs_usb = dwc3_qcom_create_urs_usb_platdev(dev);
-			if (!qcom->urs_usb) {
+			if (IS_ERR_OR_NULL(qcom->urs_usb)) {
 				dev_err(dev, "failed to create URS USB platdev\n");
-				return -ENODEV;
+				if (!qcom->urs_usb)
+					return -ENODEV;
+				else
+					return PTR_ERR(qcom->urs_usb);
 			}
 		}
 	}
-- 
2.34.1



