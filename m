Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110E04188A2
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhIZMd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIZMd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:33:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0277D60F92;
        Sun, 26 Sep 2021 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632659512;
        bh=sHMEzYQ4ItzwpUhaBuXGt6RZ33CZBr4qjyZsLB65BAQ=;
        h=Subject:To:Cc:From:Date:From;
        b=PwatFXSBZBnVGTXyE8kVfFp6ALJXjMipc2iNIpIxy8PcQB+/uQGOOmqlDeoPTAZND
         h4U7RGVuc1EMGm6CDUgf8SgaW0zHT3wGtPdPw8O7cYAHDDclSsoL7z/RdYERnrBRmb
         7kpgLYtfBGtrmN3F6upPeJcqZOrNAHI/kUExymP8=
Subject: FAILED: patch "[PATCH] usb: gadget: f_uac2: Populate SS descriptors'" failed to apply to 5.14-stable tree
To:     jackp@codeaurora.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 14:31:50 +0200
Message-ID: <163265951017818@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0e8a206a2a53a919e1709c654cb65d519f7befb Mon Sep 17 00:00:00 2001
From: Jack Pham <jackp@codeaurora.org>
Date: Thu, 9 Sep 2021 10:48:11 -0700
Subject: [PATCH] usb: gadget: f_uac2: Populate SS descriptors'
 wBytesPerInterval

For Isochronous endpoints, the SS companion descriptor's
wBytesPerInterval field is required to reserve bus time in order
to transmit the required payload during the service interval.
If left at 0, the UAC2 function is unable to transact data on its
playback or capture endpoints in SuperSpeed mode.

Since f_uac2 currently does not support any bursting this value can
be exactly equal to the calculated wMaxPacketSize.

Tested with Windows 10 as a host.

Fixes: f8cb3d556be3 ("usb: f_uac2: adds support for SS and SSP")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210909174811.12534-3-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index d89c1ebb07f4..be864560bfea 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -1178,6 +1178,9 @@ afunc_bind(struct usb_configuration *cfg, struct usb_function *fn)
 	agdev->out_ep_maxpsize = max_t(u16, agdev->out_ep_maxpsize,
 				le16_to_cpu(ss_epout_desc.wMaxPacketSize));
 
+	ss_epin_desc_comp.wBytesPerInterval = ss_epin_desc.wMaxPacketSize;
+	ss_epout_desc_comp.wBytesPerInterval = ss_epout_desc.wMaxPacketSize;
+
 	// HS and SS endpoint addresses are copied from autoconfigured FS descriptors
 	hs_ep_int_desc.bEndpointAddress = fs_ep_int_desc.bEndpointAddress;
 	hs_epout_desc.bEndpointAddress = fs_epout_desc.bEndpointAddress;

