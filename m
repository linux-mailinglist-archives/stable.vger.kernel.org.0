Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0372ABCCC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbgKINjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730642AbgKINCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:02:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E795421D46;
        Mon,  9 Nov 2020 13:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926950;
        bh=miv/onbwCQT97ox3By4hcR1GQCILCs7hylsnxiBa+hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6D5osRFb8UrvWb4SbM2Wsz6Fuj3wcZ/MyQFbOGrAyvjG5Vrl0L+8S1+Ij6EBVc9Q
         AAevm1LSVCiYcapuOR870N0IUiu8DhERQHLRLg2r6wvtTdpPccj/J7J4GPWOFE+8r1
         UA5gpI9Cir6e802Q0x6Si3G6+zv1dFYhHTawJ+TA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.9 060/117] usb: dwc3: core: add phy cleanup for probe error handling
Date:   Mon,  9 Nov 2020 13:54:46 +0100
Message-Id: <20201109125028.517713194@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
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
@@ -1148,6 +1148,17 @@ static int dwc3_probe(struct platform_de
 
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


