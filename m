Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE75137C203
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhELPGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232941AbhELPCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C8CD6144D;
        Wed, 12 May 2021 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831475;
        bh=4NUvwbMiTVc+LwbJhgVqirOeNja/kDToO5rLITW94/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lfr5H84BbZ3nuuWM/NxyZL58OOFg4GdaTGouHVvZ+tUi5B8wHxntGHFRkIEgYzWa8
         bABi2WlaQy9vs4i6utG3gJIzLf7VWQM1JCXfF9zgsyYHus+HpSbRnQSBwC9yXEHlIm
         w0dXltxFBpPBloXDkjt2bdqXDEGdBUUtZHQKRJIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/244] usb: dwc2: Fix host mode hibernation exit with remote wakeup flow.
Date:   Wed, 12 May 2021 16:48:26 +0200
Message-Id: <20210512144747.336894050@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 258056c82206..f29fbadb0548 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5580,7 +5580,15 @@ int dwc2_host_exit_hibernation(struct dwc2_hsotg *hsotg, int rem_wakeup,
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



