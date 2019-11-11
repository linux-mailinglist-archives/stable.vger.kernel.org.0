Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16FEF7C73
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfKKSqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:46:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbfKKSqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:46:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96AB02173B;
        Mon, 11 Nov 2019 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497981;
        bh=c33AECLfdkLw9jMvT37q32hJX80dIXfiA4ZnBHOxKt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pnz+9rZvSoYokpfFvwUgPrU2xdeks/uJR33Ll4AGP0HsNtNaOs277koKX++yA3nVS
         +TjZBC6A+PUGaSBW5hWx25q4vnqu2bHub/R3i57BS9yw6AxB8Z6iRsYEWC75r4G/tB
         n6C/xj4wOzUsrCWyUB1Io7fhi/4IS+yeEcSEqXoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/125] usb: dwc3: gadget: fix race when disabling ep with cancelled xfers
Date:   Mon, 11 Nov 2019 19:29:12 +0100
Message-Id: <20191111181454.916507789@linuxfoundation.org>
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

From: Felipe Balbi <felipe.balbi@linux.intel.com>

[ Upstream commit d8eca64eec7103ab1fbabc0a187dbf6acfb2af93 ]

When disabling an endpoint which has cancelled requests, we should
make sure to giveback requests that are currently pending in the
cancelled list, otherwise we may fall into a situation where command
completion interrupt fires after endpoint has been disabled, therefore
causing a splat.

Fixes: fec9095bdef4 "usb: dwc3: gadget: remove wait_end_transfer"
Reported-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Link: https://lore.kernel.org/r/20191031090713.1452818-1-felipe.balbi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 54de732550648..8398c33d08e7c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -698,6 +698,12 @@ static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep)
 
 		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
 	}
+
+	while (!list_empty(&dep->cancelled_list)) {
+		req = next_request(&dep->cancelled_list);
+
+		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+	}
 }
 
 /**
-- 
2.20.1



