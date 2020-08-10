Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7154E240F89
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbgHJTXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbgHJTMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:12:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE1D622B49;
        Mon, 10 Aug 2020 19:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086770;
        bh=nLJEez5D3+KWTGWkl7L3ZwkzvHX5nNJKbSCaoB6TIp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnwPNuS9zXMzotWBSFDMFEfsfzPuEQ68cghR/7twrQHO2bpAybrkJeW/Sm8AC/Cgf
         aJiEOvOdGmL4O3aG5eze73AZZz6nfFC8izToHUu/yMwfmHqilB94zl6jbkbjn/OD2V
         EH6GLzga7fu09mOEGF2GxXl8kjIE0puDlAVuYgPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Danesh Petigara <danesh.petigara@broadcom.com>,
        Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 40/45] usb: bdc: Halt controller on suspend
Date:   Mon, 10 Aug 2020 15:11:48 -0400
Message-Id: <20200810191153.3794446-40-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191153.3794446-1-sashal@kernel.org>
References: <20200810191153.3794446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danesh Petigara <danesh.petigara@broadcom.com>

[ Upstream commit 5fc453d7de3d0c345812453823a3a56783c5f82c ]

GISB bus error kernel panics have been observed during S2 transition
tests on the 7271t platform. The errors are a result of the BDC
interrupt handler trying to access BDC register space after the
system's suspend callbacks have completed.

Adding a suspend hook to the BDC driver that halts the controller before
S2 entry thus preventing unwanted access to the BDC register space during
this transition.

Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 174555e94a6c0..3d33499db50b5 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -605,9 +605,14 @@ static int bdc_remove(struct platform_device *pdev)
 static int bdc_suspend(struct device *dev)
 {
 	struct bdc *bdc = dev_get_drvdata(dev);
+	int ret;
 
-	clk_disable_unprepare(bdc->clk);
-	return 0;
+	/* Halt the controller */
+	ret = bdc_stop(bdc);
+	if (!ret)
+		clk_disable_unprepare(bdc->clk);
+
+	return ret;
 }
 
 static int bdc_resume(struct device *dev)
-- 
2.25.1

