Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7313A17069C
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 18:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgBZRv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 12:51:29 -0500
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:34638 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgBZRv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 12:51:29 -0500
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 38C763C009D;
        Wed, 26 Feb 2020 18:51:26 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vLozTJuWFvoL; Wed, 26 Feb 2020 18:51:20 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id DDDDE3C005E;
        Wed, 26 Feb 2020 18:51:20 +0100 (CET)
Received: from lxhi-065.adit-jv.com (10.72.93.66) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Wed, 26 Feb
 2020 18:51:20 +0100
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "Lee, Chiasheng" <chiasheng.lee@intel.com>,
        Mathieu Malaterre <malat@debian.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Hardik Gajjar <hgajjar@de.adit-jv.com>,
        <stable@vger.kernel.org>, <scan-admin@coverity.com>
Subject: [PATCH v3 1/3] usb: core: hub: fix unhandled return by employing a void function
Date:   Wed, 26 Feb 2020 18:50:34 +0100
Message-ID: <20200226175036.14946-1-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.93.66]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Address below Coverity complaint (Feb 25, 2020, 8:06 AM CET):

*** CID 1458999:  Error handling issues  (CHECKED_RETURN)
/drivers/usb/core/hub.c: 1869 in hub_probe()
1863
1864            if (id->driver_info & HUB_QUIRK_CHECK_PORT_AUTOSUSPEND)
1865                    hub->quirk_check_port_auto_suspend = 1;
1866
1867            if (id->driver_info & HUB_QUIRK_DISABLE_AUTOSUSPEND) {
1868                    hub->quirk_disable_autosuspend = 1;
 >>>     CID 1458999:  Error handling issues  (CHECKED_RETURN)
 >>>     Calling "usb_autopm_get_interface" without checking return value (as is done elsewhere 97 out of 111 times).
1869                    usb_autopm_get_interface(intf);
1870            }
1871
1872            if (hub_configure(hub, &desc->endpoint[0].desc) >= 0)
1873                    return 0;
1874

Rather than checking the return value of 'usb_autopm_get_interface()',
switch to the usb_autopm_get_interface_no_resume() API, as per:

On Tue, Feb 25, 2020 at 10:32:32AM -0500, Alan Stern wrote:
 ------ 8< ------
 > This change (i.e. 'ret = usb_autopm_get_interface') is not necessary,
 > because the resume operation cannot fail at this point (interfaces
 > are always powered-up during probe). A better solution would be to
 > call usb_autopm_get_interface_no_resume() instead.
 ------ 8< ------

Fixes: 1208f9e1d758c9 ("USB: hub: Fix the broken detection of USB3 device in SMSC hub")
Cc: Hardik Gajjar <hgajjar@de.adit-jv.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # v4.14+
Reported-by: scan-admin@coverity.com
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---
v3:
 - Make the summary line more clear
 - s/autpm/autopm/ in patch description
 - Cc <stable> with v4.14+ since v4.14.x is the earliest stable kernel
   which accepted commit 1208f9e1d758c9 ("USB: hub: Fix the broken
   detection of USB3 device in SMSC hub")

v2:
 - [Alan Stern] Use usb_autopm_get_interface_no_resume() instead of
   usb_autopm_get_interface()
 - Augment commit description to provide background
 - Link: https://lore.kernel.org/lkml/20200225183057.31953-1-erosca@de.adit-jv.com

v1:
 - Link: https://lore.kernel.org/lkml/20200225130846.20236-1-erosca@de.adit-jv.com
---
 drivers/usb/core/hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 1d212f82c69b..1105983b5c1c 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1866,7 +1866,7 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	if (id->driver_info & HUB_QUIRK_DISABLE_AUTOSUSPEND) {
 		hub->quirk_disable_autosuspend = 1;
-		usb_autopm_get_interface(intf);
+		usb_autopm_get_interface_no_resume(intf);
 	}
 
 	if (hub_configure(hub, &desc->endpoint[0].desc) >= 0)
-- 
2.25.1

