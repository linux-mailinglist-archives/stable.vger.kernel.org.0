Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468051014B8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbfKSFgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729989AbfKSFgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7150020862;
        Tue, 19 Nov 2019 05:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141800;
        bh=A8kyb2hX5fNoWsEQow3qiFHYpIqrMrW8S0UxFL6m/bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMucfdd7vr8fs7umUCv1WKQp52ljfLHYWDhH6nIFiYntW6jRER0G2jpygulLsd1Qm
         +7rGJnQ25lb2BakrHKM6N5S9rm2QzrSop/7F2iZRIPO6WhXg+6b8e4yI5yg8SwmGDs
         auUtmjai+4Xn1KQS/9fdHV8gjEs/Rq9EHnCTFSaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Adell <nicolas.adell@actia.fr>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 286/422] usb: chipidea: imx: enable OTG overcurrent in case USB subsystem is already started
Date:   Tue, 19 Nov 2019 06:18:03 +0100
Message-Id: <20191119051417.517873970@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Adell <nicolas.adell@actia.fr>

[ Upstream commit 1dedbdf2bbb1ede8d96f35f9845ecae179dc1988 ]

When initializing the USB subsystem before starting the kernel,
OTG overcurrent detection is disabled. In case the OTG polarity of
overcurrent is low active, the overcurrent detection is never enabled
again and events cannot be reported as expected. Because imx usb
overcurrent polarity is low active by default, only detection needs
to be enable in usbmisc init function.

Signed-off-by: Nicolas Adell <nicolas.adell@actia.fr>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/usbmisc_imx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/chipidea/usbmisc_imx.c b/drivers/usb/chipidea/usbmisc_imx.c
index 34ad5bf8acd8d..424ecb1f003fe 100644
--- a/drivers/usb/chipidea/usbmisc_imx.c
+++ b/drivers/usb/chipidea/usbmisc_imx.c
@@ -343,6 +343,8 @@ static int usbmisc_imx6q_init(struct imx_usbmisc_data *data)
 	} else if (data->oc_polarity == 1) {
 		/* High active */
 		reg &= ~(MX6_BM_OVER_CUR_DIS | MX6_BM_OVER_CUR_POLARITY);
+	} else {
+		reg &= ~(MX6_BM_OVER_CUR_DIS);
 	}
 	writel(reg, usbmisc->base + data->index * 4);
 
-- 
2.20.1



