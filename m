Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3483A1B68E3
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgDWXSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:18:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48940 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728266AbgDWXGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:37 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-0004fa-Hp; Fri, 24 Apr 2020 00:06:31 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvO-00E6mH-2T; Fri, 24 Apr 2020 00:06:30 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Fri, 24 Apr 2020 00:05:17 +0100
Message-ID: <lsq.1587683028.60307578@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 090/245] staging: rtl8188eu: fix interface sanity check
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 74ca34118a0e05793935d804ccffcedd6eb56596 upstream.

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: c2478d39076b ("staging: r8188eu: Add files for new driver - part 20")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210114751.5119-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -141,7 +141,7 @@ static struct dvobj_priv *usb_dvobj_init
 	phost_conf = pusbd->actconfig;
 	pconf_desc = &phost_conf->desc;
 
-	phost_iface = &usb_intf->altsetting[0];
+	phost_iface = usb_intf->cur_altsetting;
 	piface_desc = &phost_iface->desc;
 
 	pdvobjpriv->NumInterfaces = pconf_desc->bNumInterfaces;

