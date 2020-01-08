Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14BB134C2D
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgAHTuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:50:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43410 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730390AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006o7-4z; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dlo-HT; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Chen" <peter.chen@nxp.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>
Date:   Wed, 08 Jan 2020 19:43:15 +0000
Message-ID: <lsq.1578512578.71487032@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 17/63] usb: gadget: composite: fix dereference after
 null check coverify warning
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@nxp.com>

commit c526c62d565ea5a5bba9433f28756079734f430d upstream.

cdev->config is checked for null pointer at above code, so cdev->config
might be null, fix it by adding null pointer check.

Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/composite.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1729,6 +1729,8 @@ unknown:
 			break;
 
 		case USB_RECIP_ENDPOINT:
+			if (!cdev->config)
+				break;
 			endp = ((w_index & 0x80) >> 3) | (w_index & 0x0f);
 			list_for_each_entry(f, &cdev->config->functions, list) {
 				if (test_bit(endp, f->endpoints))

