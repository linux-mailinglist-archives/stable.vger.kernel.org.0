Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63FF111E54
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbfLCXBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbfLCW4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F82320803;
        Tue,  3 Dec 2019 22:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413801;
        bh=klQsIEaLdkvQn9mXHsL/19l5ID92BD8wx7KpDUk+fkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b84PSBlyXmiVIikg0oGPW1gteEYDvWzMwx2HVEin+7pYHSda0OmwcZhZZZ782clG0
         WI6DFpTybzFju9HaiNWf/R32LfzpY7tNDNaawvRi+DyzWIZ2CnVUIA9M2ZpID1xfjx
         oIi0PUSaqXgxdrEbI/nHPtMNcZ+qMwaxFl/dLMik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.19 268/321] usb: dwc2: use a longer core rest timeout in dwc2_core_reset()
Date:   Tue,  3 Dec 2019 23:35:34 +0100
Message-Id: <20191203223441.067373492@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Kresin <dev@kresin.me>

commit 6689f0f4bb14e50917ba42eb9b41c25e0184970c upstream.

Testing on different generations of Lantiq MIPS SoC based boards, showed
that it takes up to 1500 us until the core reset bit is cleared.

The driver from the vendor SDK (ifxhcd) uses a 1 second timeout. Use the
same timeout to fix wrong hang detections and make the driver work for
Lantiq MIPS SoCs.

At least till kernel 4.14 the hanging reset only caused a warning but
the driver was probed successful. With kernel 4.19 errors out with
EBUSY.

Cc: linux-stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathias Kresin <dev@kresin.me>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -524,7 +524,7 @@ int dwc2_core_reset(struct dwc2_hsotg *h
 	greset |= GRSTCTL_CSFTRST;
 	dwc2_writel(hsotg, greset, GRSTCTL);
 
-	if (dwc2_hsotg_wait_bit_clear(hsotg, GRSTCTL, GRSTCTL_CSFTRST, 50)) {
+	if (dwc2_hsotg_wait_bit_clear(hsotg, GRSTCTL, GRSTCTL_CSFTRST, 10000)) {
 		dev_warn(hsotg->dev, "%s: HANG! Soft Reset timeout GRSTCTL GRSTCTL_CSFTRST\n",
 			 __func__);
 		return -EBUSY;


