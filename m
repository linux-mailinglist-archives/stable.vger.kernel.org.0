Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C450B126CAA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfLSSpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbfLSSpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:45:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE1012465E;
        Thu, 19 Dec 2019 18:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781143;
        bh=y6rnEU77n16s4mST6pvUdKrdxHfmcibG65MT/rSN5tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wi1UrXoaqzwk0/f1l3cXZvZfP6wl478IsPtnwnj1a2sb6dal20IyOjZ2wI6zSs3i7
         r6XFbH+sVOUinfVbQKZ9tlqyfSm5C9+/ecIdHtSRLNxAqCRIbIhQ5f+uCEfYm+Udhg
         KQVvfwQnjQIcK+UnApi9WGBubx4eNpNdxIlMO7z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 100/199] staging: rtl8188eu: fix interface sanity check
Date:   Thu, 19 Dec 2019 19:33:02 +0100
Message-Id: <20191219183220.438131683@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 74ca34118a0e05793935d804ccffcedd6eb56596 upstream.

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: c2478d39076b ("staging: r8188eu: Add files for new driver - part 20")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210114751.5119-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -78,7 +78,7 @@ static struct dvobj_priv *usb_dvobj_init
 	phost_conf = pusbd->actconfig;
 	pconf_desc = &phost_conf->desc;
 
-	phost_iface = &usb_intf->altsetting[0];
+	phost_iface = usb_intf->cur_altsetting;
 	piface_desc = &phost_iface->desc;
 
 	pdvobjpriv->NumInterfaces = pconf_desc->bNumInterfaces;


