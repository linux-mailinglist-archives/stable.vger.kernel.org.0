Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E619062
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfEISo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbfEISo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:44:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA5A217D6;
        Thu,  9 May 2019 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427465;
        bh=YtgbiACOYpu3Ps647bzUjSSLMETUjJZB0fG39icM7G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVUg8Uo7OR+0ziaQ8UiPRoJuXhRhUN54PC8uJJ1PRIKW93rlIEYOb7smiUxV4uPAP
         Ig8pfMSC3AEMGmohC+D3EVFmd0zVeMfxamqS9z/JLQdU7kC/DAWV/SvyhHX9fAw59O
         XYitaYIqZt8+yRAXx5+/f0rt6fyZaPJT6lL639hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.9 20/28] usb: dwc3: Fix default lpm_nyet_threshold value
Date:   Thu,  9 May 2019 20:42:12 +0200
Message-Id: <20190509181254.486030106@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181247.647767531@linuxfoundation.org>
References: <20190509181247.647767531@linuxfoundation.org>
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
@@ -991,7 +991,7 @@ static int dwc3_probe(struct platform_de
 	dwc->regs_size	= resource_size(res);
 
 	/* default to highest possible threshold */
-	lpm_nyet_threshold = 0xff;
+	lpm_nyet_threshold = 0xf;
 
 	/* default to -3.5dB de-emphasis */
 	tx_de_emphasis = 1;


