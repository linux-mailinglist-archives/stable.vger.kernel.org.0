Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7ED499B11
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379447AbiAXVt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456655AbiAXVjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCF7C0419C3;
        Mon, 24 Jan 2022 12:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C3E26150D;
        Mon, 24 Jan 2022 20:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81CFC340E5;
        Mon, 24 Jan 2022 20:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055966;
        bh=tc4vaYi2tH8OU8FZACwACbNtaBA8r1yAdX/YVgAuQhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETP9HeVs8rTCleDZCGBomDdY9s/QZooGRMPamvjGYjpVEOJ4sOgm7yfgDLxcskO5V
         bpKeZPwNLNphGQqIAjYyUXjgPINb7yGP6IdegO9IILNI0ci7iWr9uENEojXNFbwCJM
         iSO/RA9sSx6HrH6WN26VJLPaU7tdo6kbnkODE/U4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/846] usb: dwc3: qcom: Fix NULL vs IS_ERR checking in dwc3_qcom_probe
Date:   Mon, 24 Jan 2022 19:37:21 +0100
Message-Id: <20220124184112.079280719@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 3cb01cdd02c29..b81a9e1c13153 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -769,9 +769,12 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 
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



