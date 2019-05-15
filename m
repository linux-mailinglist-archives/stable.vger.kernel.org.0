Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869391ED53
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbfEOLIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbfEOLIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:08:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9022520843;
        Wed, 15 May 2019 11:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918492;
        bh=yzgXO+JO6I4uqNtMMxQo5ERI9XjfeOUIZ4hcLkwCdu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+ewy1Fao2qsAJY4PbgTl4pBLTxtDx2Moy+9AWnB7fBaUde3kiewaJH4RNlPKOm38
         b3iLrEhcCyVHPE3iiv4P/yUqLKbMGGnemAAwB+4FX+o7dXMFJ8qe8oSZaGxvVHNGjD
         W1m2ezxZufl3cefRWZW5+cXhCnwv3PmC7Jf0f4vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.4 151/266] usb: dwc3: Fix default lpm_nyet_threshold value
Date:   Wed, 15 May 2019 12:54:18 +0200
Message-Id: <20190515090728.020915732@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
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
@@ -867,7 +867,7 @@ static int dwc3_probe(struct platform_de
 	dwc->regs_size	= resource_size(res);
 
 	/* default to highest possible threshold */
-	lpm_nyet_threshold = 0xff;
+	lpm_nyet_threshold = 0xf;
 
 	/* default to -3.5dB de-emphasis */
 	tx_de_emphasis = 1;


