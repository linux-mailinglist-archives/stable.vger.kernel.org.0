Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90038A420
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhETKBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234882AbhETJ7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:59:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2815F616ED;
        Thu, 20 May 2021 09:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503515;
        bh=iLQUTeX6BCNFIMnrDZHpX2dwAoJ9qHYOjAiLV9akYFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emsxXbGTHV4jvYQW2yIf9nIxyiLDZzboKJieFxSYJhajXwLX1ON+c+cS9USxNhEdz
         wffv6fZwTZ5Ige7kYfxkZ9OQMFAAk6xSz/g2kvM8gMGTc0LdpLQpUyNIjJVoFJQzaq
         s7G7b/86E19JdJHM/T64Xiw12Lxtu/XEmx2Th/JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 222/425] usb: dwc2: Fix host mode hibernation exit with remote wakeup flow.
Date:   Thu, 20 May 2021 11:19:51 +0200
Message-Id: <20210520092138.717064634@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>

[ Upstream commit c2db8d7b9568b10e014af83b3c15e39929e3579e ]

Added setting "port_connect_status_change" flag to "1" in order
to re-enumerate, because after exit from hibernation port
connection status is not detected.

Fixes: c5c403dc4336 ("usb: dwc2: Add host/device hibernation functions")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Link: https://lore.kernel.org/r/20210416124707.5EEC2A005D@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 91686e1b24d9..58e53e3d905b 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5741,7 +5741,15 @@ int dwc2_host_exit_hibernation(struct dwc2_hsotg *hsotg, int rem_wakeup,
 		return ret;
 	}
 
-	dwc2_hcd_rem_wakeup(hsotg);
+	if (rem_wakeup) {
+		dwc2_hcd_rem_wakeup(hsotg);
+		/*
+		 * Change "port_connect_status_change" flag to re-enumerate,
+		 * because after exit from hibernation port connection status
+		 * is not detected.
+		 */
+		hsotg->flags.b.port_connect_status_change = 1;
+	}
 
 	hsotg->hibernated = 0;
 	hsotg->bus_suspended = 0;
-- 
2.30.2



