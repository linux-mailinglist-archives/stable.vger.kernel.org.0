Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09342DA08B
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407348AbfJPWMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406590AbfJPV4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:14 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2081C218DE;
        Wed, 16 Oct 2019 21:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262974;
        bh=JffcVU2maBe0QjGzq/y3BwaF0f+wHP+HIvIN//M6Jio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbVIiNRz8uZy1iiU1CcQr5CYl4eX1+Jtc7vuQsJNiP5OAg//zlpMN7DCLhAvpFXHc
         U/6Uiw0W9eOKkAdD3FdYl66pN74x69ps5apFt4+Tv9/rIjCxqNr7TnDB/KtBhHt7Qo
         hZG/BjirbgctSTAv7fk2pK+ZG/w+GtR5O1R7rv+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Schmidt <jan@centricular.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 09/65] xhci: Prevent device initiated U1/U2 link pm if exit latency is too long
Date:   Wed, 16 Oct 2019 14:50:23 -0700
Message-Id: <20191016214803.862322042@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit cd9d9491e835a845c1a98b8471f88d26285e0bb9 upstream.

If host/hub initiated link pm is prevented by a driver flag we still must
ensure that periodic endpoints have longer service intervals than link pm
exit latency before allowing device initiated link pm.

Fix this by continue walking and checking endpoint service interval if
xhci_get_timeout_no_hub_lpm() returns anything else than USB3_LPM_DISABLED

While at it fix the split line error message

Tested-by: Jan Schmidt <jan@centricular.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-3-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4607,10 +4607,12 @@ static u16 xhci_calculate_lpm_timeout(st
 		if (intf->dev.driver) {
 			driver = to_usb_driver(intf->dev.driver);
 			if (driver && driver->disable_hub_initiated_lpm) {
-				dev_dbg(&udev->dev, "Hub-initiated %s disabled "
-						"at request of driver %s\n",
-						state_name, driver->name);
-				return xhci_get_timeout_no_hub_lpm(udev, state);
+				dev_dbg(&udev->dev, "Hub-initiated %s disabled at request of driver %s\n",
+					state_name, driver->name);
+				timeout = xhci_get_timeout_no_hub_lpm(udev,
+								      state);
+				if (timeout == USB3_LPM_DISABLED)
+					return timeout;
 			}
 		}
 


