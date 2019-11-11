Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFE4F7C4F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfKKSpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbfKKSpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:45:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89298204FD;
        Mon, 11 Nov 2019 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497902;
        bh=NAogkW33fSfT/LC/kozI9usm/VdaqyUYpaY1pwI9Gy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=je/zu3lu7Jetmw40JqkHrbhKyqwxqd9RSZzuqD+6Q+dFf+SewyM9JlDElm9vGZP4f
         LoVOtcHT2e1tcxmIukJVoL5Qvs1FrLyExpHc6tAOPP9W2Bdny5yc9oq9ugxLNNueoW
         rhbb+Fg+hcAXbAG8CAuXQLsdJDGw7R8YM4Py3IVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/125] usb: dwc3: pci: prevent memory leak in dwc3_pci_probe
Date:   Mon, 11 Nov 2019 19:28:51 +0100
Message-Id: <20191111181452.221804790@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 9bbfceea12a8f145097a27d7c7267af25893c060 ]

In dwc3_pci_probe a call to platform_device_alloc allocates a device
which is correctly put in case of error except one case: when the call to
platform_device_add_properties fails it directly returns instead of
going to error handling. This commit replaces return with the goto.

Fixes: 1a7b12f69a94 ("usb: dwc3: pci: Supply device properties via driver data")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 8cced3609e243..b4e42d597211a 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -256,7 +256,7 @@ static int dwc3_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	ret = platform_device_add_properties(dwc->dwc3, p);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	ret = dwc3_pci_quirks(dwc);
 	if (ret)
-- 
2.20.1



