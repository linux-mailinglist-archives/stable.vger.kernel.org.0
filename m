Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D2F3A6423
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhFNLVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234589AbhFNLSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE4FA61985;
        Mon, 14 Jun 2021 10:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667870;
        bh=WNRQmvYVaPg3E/hPDUmbhbtgg55PVELOBnv9FnkzaDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYV8faVJK9m/WlFf8fTc3roSLxx39XxI5TB9xMjYl/VBBtBiOHv4iWINEsNX7bBMh
         4lJNwPTwdd8BxKeGJ6pjyDDZEy6HCjjEb6fQjSY0N4x/xCUzvYY3jUZ3FPTjn/UzjG
         Vn2ONggsekRT3JybNClzSZS72z/fs3rNUpHQZZNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felipe Balbi <balbi@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael R Sweet <msweet@msweet.org>,
        Mike Christie <michael.christie@oracle.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@nxp.com>,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Wei Ming Chen <jj251510319013@gmail.com>,
        Will McVicker <willmcvicker@google.com>,
        Zqiang <qiang.zhang@windriver.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH 5.12 107/173] usb: fix various gadgets null ptr deref on 10gbps cabling.
Date:   Mon, 14 Jun 2021 12:27:19 +0200
Message-Id: <20210614102701.728005593@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

commit 90c4d05780d47e14a50e11a7f17373104cd47d25 upstream.

This avoids a null pointer dereference in
f_{ecm,eem,hid,loopback,printer,rndis,serial,sourcesink,subset,tcm}
by simply reusing the 5gbps config for 10gbps.

Fixes: eaef50c76057 ("usb: gadget: Update usb_assign_descriptors for SuperSpeedPlus")
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Michael R Sweet <msweet@msweet.org>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Pawel Laszczak <pawell@cadence.com>
Cc: Peter Chen <peter.chen@nxp.com>
Cc: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc: Wei Ming Chen <jj251510319013@gmail.com>
Cc: Will McVicker <willmcvicker@google.com>
Cc: Zqiang <qiang.zhang@windriver.com>
Reviewed-By: Lorenzo Colitti <lorenzo@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20210608044141.3898496-1-zenczykowski@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ecm.c        |    2 +-
 drivers/usb/gadget/function/f_eem.c        |    2 +-
 drivers/usb/gadget/function/f_hid.c        |    3 ++-
 drivers/usb/gadget/function/f_loopback.c   |    2 +-
 drivers/usb/gadget/function/f_printer.c    |    3 ++-
 drivers/usb/gadget/function/f_rndis.c      |    2 +-
 drivers/usb/gadget/function/f_serial.c     |    2 +-
 drivers/usb/gadget/function/f_sourcesink.c |    3 ++-
 drivers/usb/gadget/function/f_subset.c     |    2 +-
 drivers/usb/gadget/function/f_tcm.c        |    3 ++-
 10 files changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -791,7 +791,7 @@ ecm_bind(struct usb_configuration *c, st
 		fs_ecm_notify_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, ecm_fs_function, ecm_hs_function,
-			ecm_ss_function, NULL);
+			ecm_ss_function, ecm_ss_function);
 	if (status)
 		goto fail;
 
--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -302,7 +302,7 @@ static int eem_bind(struct usb_configura
 	eem_ss_out_desc.bEndpointAddress = eem_fs_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, eem_fs_function, eem_hs_function,
-			eem_ss_function, NULL);
+			eem_ss_function, eem_ss_function);
 	if (status)
 		goto fail;
 
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -802,7 +802,8 @@ static int hidg_bind(struct usb_configur
 		hidg_fs_out_ep_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, hidg_fs_descriptors,
-			hidg_hs_descriptors, hidg_ss_descriptors, NULL);
+			hidg_hs_descriptors, hidg_ss_descriptors,
+			hidg_ss_descriptors);
 	if (status)
 		goto fail;
 
--- a/drivers/usb/gadget/function/f_loopback.c
+++ b/drivers/usb/gadget/function/f_loopback.c
@@ -207,7 +207,7 @@ autoconf_fail:
 	ss_loop_sink_desc.bEndpointAddress = fs_loop_sink_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, fs_loopback_descs, hs_loopback_descs,
-			ss_loopback_descs, NULL);
+			ss_loopback_descs, ss_loopback_descs);
 	if (ret)
 		return ret;
 
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -1101,7 +1101,8 @@ autoconf_fail:
 	ss_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, fs_printer_function,
-			hs_printer_function, ss_printer_function, NULL);
+			hs_printer_function, ss_printer_function,
+			ss_printer_function);
 	if (ret)
 		return ret;
 
--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -789,7 +789,7 @@ rndis_bind(struct usb_configuration *c,
 	ss_notify_desc.bEndpointAddress = fs_notify_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, eth_fs_function, eth_hs_function,
-			eth_ss_function, NULL);
+			eth_ss_function, eth_ss_function);
 	if (status)
 		goto fail;
 
--- a/drivers/usb/gadget/function/f_serial.c
+++ b/drivers/usb/gadget/function/f_serial.c
@@ -233,7 +233,7 @@ static int gser_bind(struct usb_configur
 	gser_ss_out_desc.bEndpointAddress = gser_fs_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, gser_fs_function, gser_hs_function,
-			gser_ss_function, NULL);
+			gser_ss_function, gser_ss_function);
 	if (status)
 		goto fail;
 	dev_dbg(&cdev->gadget->dev, "generic ttyGS%d: %s speed IN/%s OUT/%s\n",
--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -431,7 +431,8 @@ no_iso:
 	ss_iso_sink_desc.bEndpointAddress = fs_iso_sink_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, fs_source_sink_descs,
-			hs_source_sink_descs, ss_source_sink_descs, NULL);
+			hs_source_sink_descs, ss_source_sink_descs,
+			ss_source_sink_descs);
 	if (ret)
 		return ret;
 
--- a/drivers/usb/gadget/function/f_subset.c
+++ b/drivers/usb/gadget/function/f_subset.c
@@ -358,7 +358,7 @@ geth_bind(struct usb_configuration *c, s
 		fs_subset_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, fs_eth_function, hs_eth_function,
-			ss_eth_function, NULL);
+			ss_eth_function, ss_eth_function);
 	if (status)
 		goto fail;
 
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -2061,7 +2061,8 @@ static int tcm_bind(struct usb_configura
 	uasp_fs_cmd_desc.bEndpointAddress = uasp_ss_cmd_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, uasp_fs_function_desc,
-			uasp_hs_function_desc, uasp_ss_function_desc, NULL);
+			uasp_hs_function_desc, uasp_ss_function_desc,
+			uasp_ss_function_desc);
 	if (ret)
 		goto ep_fail;
 


