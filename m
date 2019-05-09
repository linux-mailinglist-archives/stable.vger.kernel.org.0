Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A72419166
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfEISzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbfEISzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:55:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB47204FD;
        Thu,  9 May 2019 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428115;
        bh=WSRye4QuqhDnD0KzcvLyhshoPeuDaJR9wrkaZyoDOMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+DjTKgOJ+OxL9eKvzy7o4M/kA6kBdEYT6JYakj45OZZCb7EVGVwvVW+XNm/vccMq
         QCrHPH2U7o7plbzwRodFIPYyP+iG8UUHC45WKglZUTaHbfBugDftfqA+0eqoV9dTS8
         LpWcfrnDql+CgRENouQHyJCsyxqP3bHSjIhF6UKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 5.1 08/30] usb: dwc3: Fix default lpm_nyet_threshold value
Date:   Thu,  9 May 2019 20:42:40 +0200
Message-Id: <20190509181252.423027909@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 8d791929b2fbdf7734c1596d808e55cb457f4562 upstream.

The max possible value for DCTL.LPM_NYET_THRES is 15 and not 255. Change
the default value to 15.

Cc: stable@vger.kernel.org
Fixes: 80caf7d21adc ("usb: dwc3: add lpm erratum support")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1218,7 +1218,7 @@ static void dwc3_get_properties(struct d
 	u8			tx_max_burst_prd;
 
 	/* default to highest possible threshold */
-	lpm_nyet_threshold = 0xff;
+	lpm_nyet_threshold = 0xf;
 
 	/* default to -3.5dB de-emphasis */
 	tx_de_emphasis = 1;


