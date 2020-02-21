Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738DA16731D
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbgBUIJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:09:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732340AbgBUIJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:09:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172A520578;
        Fri, 21 Feb 2020 08:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272564;
        bh=VoQBGjb/JsFJM3BKoLOX/WXeB1JAJ+3TWYgmREkaBvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kx1AxzVIDbUoqz27v758FoVA/gURGqy7dO9wF4Aow61K6ve7feMCVQU0hELq15ATY
         P8h2MH3QYqsSviXW8qNsa4E01yZPr4H/SZhtAqbcFQItnXfXD2SrTJDWOOgs7E0wCT
         6guJDH2rfaqseiHPX/U1j0s4xztUoiB8vgEScMkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Felipe Balbi <balbi@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/344] usb: dwc3: use proper initializers for property entries
Date:   Fri, 21 Feb 2020 08:39:50 +0100
Message-Id: <20200221072406.390732331@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 5eb5afb07853d6e90d3a2b230c825e028e948f79 ]

We should not be reaching into property entries and initialize them by
hand, but rather use proper initializer macros. This way we can alter
internal representation of property entries with no visible changes to
their users.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/host.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index 5567ed2cddbec..fa252870c926f 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -88,10 +88,10 @@ int dwc3_host_init(struct dwc3 *dwc)
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)
-		props[prop_idx++].name = "usb3-lpm-capable";
+		props[prop_idx++] = PROPERTY_ENTRY_BOOL("usb3-lpm-capable");
 
 	if (dwc->usb2_lpm_disable)
-		props[prop_idx++].name = "usb2-lpm-disable";
+		props[prop_idx++] = PROPERTY_ENTRY_BOOL("usb2-lpm-disable");
 
 	/**
 	 * WORKAROUND: dwc3 revisions <=3.00a have a limitation
@@ -103,7 +103,7 @@ int dwc3_host_init(struct dwc3 *dwc)
 	 * This following flag tells XHCI to do just that.
 	 */
 	if (dwc->revision <= DWC3_REVISION_300A)
-		props[prop_idx++].name = "quirk-broken-port-ped";
+		props[prop_idx++] = PROPERTY_ENTRY_BOOL("quirk-broken-port-ped");
 
 	if (prop_idx) {
 		ret = platform_device_add_properties(xhci, props);
-- 
2.20.1



