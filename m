Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F01AD9FF9
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388721AbfJPWGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438171AbfJPV6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:31 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C360521928;
        Wed, 16 Oct 2019 21:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263110;
        bh=sGsJKFhrpuqfRmJ6WDyPzNWLyv7nP8hm0PYNR2JdHW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reQYFxEZCIMDMoXsWKSX3D+YJjxCrwYBwdb6u9OP/bccqDSKtVBcDxjNypJ2aQW2m
         a58IiGEksQ0tM3jipEZjFzTNy1N762Oo5nSU5LAbMmaQkK0RFZHSEAlTUbAhTyMVCi
         UkWrKU7niwltC+gBRIUy9lRD4KUHnITDDhkZyyow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 5.3 034/112] usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt,wedge}()
Date:   Wed, 16 Oct 2019 14:50:26 -0700
Message-Id: <20191016214853.497255053@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 1aae1394294cb71c6aa0bc904a94a7f2f1e75936 upstream.

The commit 97664a207bc2 ("usb: renesas_usbhs: shrink spin lock area")
had added a usbhsg_pipe_disable() calling into
__usbhsg_ep_set_halt_wedge() accidentally. But, this driver should
not call the usbhsg_pipe_disable() because the function discards
all queues. So, this patch removes it.

Fixes: 97664a207bc2 ("usb: renesas_usbhs: shrink spin lock area")
Cc: <stable@vger.kernel.org> # v3.1+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1569924633-322-2-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/renesas_usbhs/mod_gadget.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -723,8 +723,6 @@ static int __usbhsg_ep_set_halt_wedge(st
 	struct device *dev = usbhsg_gpriv_to_dev(gpriv);
 	unsigned long flags;
 
-	usbhsg_pipe_disable(uep);
-
 	dev_dbg(dev, "set halt %d (pipe %d)\n",
 		halt, usbhs_pipe_number(pipe));
 


