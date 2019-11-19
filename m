Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EA01013D4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfKSF1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfKSF1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAAAE21939;
        Tue, 19 Nov 2019 05:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141263;
        bh=cdrS8Uc5C1CK0pynDXTy5DUwfd0d+1/Gvdh+qg1pCMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFneYoDQjM/do6KtcVg9yxSiHUbBtuoMXjn2YlhM892qNjGTWZgZO662qm4YTS9nP
         Ksaci90fZVzySdbjxBarRiYUrewnRwPPTsRIV11isTg5PCkrUxl1JDm4F4YiQ4p5GS
         G2WS39wUqBu0/dRGif8FsndLi13LClqNn4JhIn8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/422] extcon: cht-wc: Return from default case to avoid warnings
Date:   Tue, 19 Nov 2019 06:14:09 +0100
Message-Id: <20191119051403.191773560@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 962341b54b99965ebec5f70c8d39f1c382eea833 ]

When we have first case to fall through it's not enough to put
single comment there to satisfy compiler. Instead of doing that,
return fall back value directly from default case.

This to avoid following warnings:

drivers/extcon/extcon-intel-cht-wc.c: In function ‘cht_wc_extcon_get_charger’:
include/linux/device.h:1420:2: warning: this statement may fall through [-Wimplicit-fallthrough=]
  _dev_warn(dev, dev_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/extcon/extcon-intel-cht-wc.c:148:3: note: in expansion of macro ‘dev_warn’
   dev_warn(ext->dev,
   ^~~~~~~~
drivers/extcon/extcon-intel-cht-wc.c:152:2: note: here
  case CHT_WC_USBSRC_TYPE_SDP:
  ^~~~

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-intel-cht-wc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-intel-cht-wc.c b/drivers/extcon/extcon-intel-cht-wc.c
index 5e1dd27722781..bdb67878179ed 100644
--- a/drivers/extcon/extcon-intel-cht-wc.c
+++ b/drivers/extcon/extcon-intel-cht-wc.c
@@ -156,7 +156,7 @@ static int cht_wc_extcon_get_charger(struct cht_wc_extcon_data *ext,
 		dev_warn(ext->dev,
 			"Unhandled charger type %d, defaulting to SDP\n",
 			 ret);
-		/* Fall through, treat as SDP */
+		return EXTCON_CHG_USB_SDP;
 	case CHT_WC_USBSRC_TYPE_SDP:
 	case CHT_WC_USBSRC_TYPE_FLOAT_DP_DN:
 	case CHT_WC_USBSRC_TYPE_OTHER:
-- 
2.20.1



