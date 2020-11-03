Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFEC2A56B9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgKCVao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:30:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731943AbgKCU57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A17A92053B;
        Tue,  3 Nov 2020 20:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437079;
        bh=9QN+udJZnhGzgroHE4DOWTJeymjfgpRTOmxGr0XsLYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsf6iDrmvRl0wNPVSS6ixVl00cHbviaQJwNKS1ZKXrqadPPTsydxSzzzPVURGqs7B
         TGwpMg/ty4JsUm2bXjBUcv25Rbb/2xCrbKPbM7xd3EO8Ixxy0kNaHu/lKgtV2p8sCO
         VppnagfMyvz5PySz9qddxZlUccS4wpgmQtywOwXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 137/214] usb: dwc3: core: add phy cleanup for probe error handling
Date:   Tue,  3 Nov 2020 21:36:25 +0100
Message-Id: <20201103203303.682009582@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -1535,6 +1535,17 @@ static int dwc3_probe(struct platform_de
 
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


