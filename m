Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A413F353F5E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbhDEJLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239037AbhDEJLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2097161398;
        Mon,  5 Apr 2021 09:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613890;
        bh=OGJAUkr8EK1c6DbvydAiJAYmXQmidWmn7825VsxDhGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoGWGT3iW0qGKX4BNM3MDm5h0gKMHxcH14dBlqVCQUYPbkMGY8cZM8JFdOwUU3A66
         ZtF58uiH4KtjQ4+6+IvzxDgEeEIL+vrxfQv63hXkHEZvG5iSPzLCl/gwwC8pSTc77W
         PqVkc9jNoEjleqVQAirU9M9m+6EG3Rl3tg2JSnIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 5.10 117/126] usb: dwc3: qcom: skip interconnect init for ACPI probe
Date:   Mon,  5 Apr 2021 10:54:39 +0200
Message-Id: <20210405085034.912125152@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

commit 5e4010e36a58978e42b2ee13739ff9b50209c830 upstream.

The ACPI probe starts failing since commit bea46b981515 ("usb: dwc3:
qcom: Add interconnect support in dwc3 driver"), because there is no
interconnect support for ACPI, and of_icc_get() call in
dwc3_qcom_interconnect_init() will just return -EINVAL.

Fix the problem by skipping interconnect init for ACPI probe, and then
the NULL icc_path_ddr will simply just scheild all ICC calls.

Fixes: bea46b981515 ("usb: dwc3: qcom: Add interconnect support in dwc3 driver")
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210311060318.25418-1-shawn.guo@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -244,6 +244,9 @@ static int dwc3_qcom_interconnect_init(s
 	struct device *dev = qcom->dev;
 	int ret;
 
+	if (has_acpi_companion(dev))
+		return 0;
+
 	qcom->icc_path_ddr = of_icc_get(dev, "usb-ddr");
 	if (IS_ERR(qcom->icc_path_ddr)) {
 		dev_err(dev, "failed to get usb-ddr path: %ld\n",


