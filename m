Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5252A55A6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbgKCVGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:06:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388139AbgKCVGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E26206B5;
        Tue,  3 Nov 2020 21:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437580;
        bh=LKUmMnFXVOxYaju0nDXGbsj2PEhcS8DdZXsmLE7XBNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vzLgxunNkqpOGvQ5ugqu+rkghqBIOf2oziDrqFRaxn6MT46X4r6jKpsUTvzeOMen
         JjCextckLUB3bH/ZW5ZsivpeLktnZjC4FPcJE5cY+8BjUJdmkknX+cgijNcdONfF74
         zzuyCRWP8f80CvGOyXA0+l81kEb6dt7tG7fzJSKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 138/191] usb: dwc3: core: add phy cleanup for probe error handling
Date:   Tue,  3 Nov 2020 21:37:10 +0100
Message-Id: <20201103203245.852784602@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit 03c1fd622f72c7624c81b64fdba4a567ae5ee9cb upstream.

Add the phy cleanup if dwc3 mode init fail, which is the missing part of
de-init for dwc3 core init.

Fixes: c499ff71ff2a ("usb: dwc3: core: re-factor init and exit paths")
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1507,6 +1507,17 @@ static int dwc3_probe(struct platform_de
 
 err5:
 	dwc3_event_buffers_cleanup(dwc);
+
+	usb_phy_shutdown(dwc->usb2_phy);
+	usb_phy_shutdown(dwc->usb3_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
+
+	usb_phy_set_suspend(dwc->usb2_phy, 1);
+	usb_phy_set_suspend(dwc->usb3_phy, 1);
+	phy_power_off(dwc->usb2_generic_phy);
+	phy_power_off(dwc->usb3_generic_phy);
+
 	dwc3_ulpi_exit(dwc);
 
 err4:


