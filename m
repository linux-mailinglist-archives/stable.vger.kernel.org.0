Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E803A60A6
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhFNKgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233283AbhFNKfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67D1F613DC;
        Mon, 14 Jun 2021 10:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666729;
        bh=4OQAUgYkVCgtPqNMK2aISwkHNI0OutWxoJnXkOyV67I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2UA3LgFE5TYY4m7SynnYbsmbzMycpxY57IKh1+AB29eGOAiooFM7S47MeAMUbk1W
         SEFlsqRTR5khCbLgdklEsaqvXnbKI0rIYGX+o/T8skzo56/5ZuvyY6om8VDhEUwUi4
         ZkVWKiI9NEYDwqRMMQ50Xj2q/YV6WVlKLYmTcnj4=
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
Subject: [PATCH 4.9 31/42] usb: fix various gadgets null ptr deref on 10gbps cabling.
Date:   Mon, 14 Jun 2021 12:27:22 +0200
Message-Id: <20210614102643.693756559@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
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
 drivers/usb/gadget/function/f_loopback.c   |    2 +-
 drivers/usb/gadget/function/f_printer.c    |    3 ++-
 drivers/usb/gadget/function/f_rndis.c      |    2 +-
 drivers/usb/gadget/function/f_serial.c     |    2 +-
 drivers/usb/gadget/function/f_sourcesink.c |    3 ++-
 drivers/usb/gadget/function/f_subset.c     |    2 +-
 drivers/usb/gadget/function/f_tcm.c        |    3 ++-
 9 files changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -793,7 +793,7 @@ ecm_bind(struct usb_configuration *c, st
 		fs_ecm_notify_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, ecm_fs_function, ecm_hs_function,
-			ecm_ss_function, NULL);
+			ecm_ss_function, ecm_ss_function);
 	if (status)
 		goto fail;
 
--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -309,7 +309,7 @@ static int eem_bind(struct usb_configura
 	eem_ss_out_desc.bEndpointAddress = eem_fs_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, eem_fs_function, eem_hs_function,
-			eem_ss_function, NULL);
+			eem_ss_function, eem_ss_function);
 	if (status)
 		goto fail;
 
--- a/drivers/usb/gadget/function/f_loopback.c
+++ b/drivers/usb/gadget/function/f_loopback.c
@@ -211,7 +211,7 @@ autoconf_fail:
 	ss_loop_sink_desc.bEndpointAddress = fs_loop_sink_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, fs_loopback_descs, hs_loopback_descs,
-			ss_loopback_descs, NULL);
+			ss_loopback_descs, ss_loopback_descs);
 	if (ret)
 		return ret;
 
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -1057,7 +1057,8 @@ autoconf_fail:
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
@@ -236,7 +236,7 @@ static int gser_bind(struct usb_configur
 	gser_ss_out_desc.bEndpointAddress = gser_fs_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, gser_fs_function, gser_hs_function,
-			gser_ss_function, NULL);
+			gser_ss_function, gser_ss_function);
 	if (status)
 		goto fail;
 	dev_dbg(&cdev->gadget->dev, "generic ttyGS%d: %s speed IN/%s OUT/%s\n",
--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -435,7 +435,8 @@ no_iso:
 	ss_iso_sink_desc.bEndpointAddress = fs_iso_sink_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, fs_source_sink_descs,
-			hs_source_sink_descs, ss_source_sink_descs, NULL);
+			hs_source_sink_descs, ss_source_sink_descs,
+			ss_source_sink_descs);
 	if (ret)
 		return ret;
 
--- a/drivers/usb/gadget/function/f_subset.c
+++ b/drivers/usb/gadget/function/f_subset.c
@@ -362,7 +362,7 @@ geth_bind(struct usb_configuration *c, s
 		fs_subset_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, fs_eth_function, hs_eth_function,
-			ss_eth_function, NULL);
+			ss_eth_function, ss_eth_function);
 	if (status)
 		goto fail;
 
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -2071,7 +2071,8 @@ static int tcm_bind(struct usb_configura
 	uasp_fs_cmd_desc.bEndpointAddress = uasp_ss_cmd_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, uasp_fs_function_desc,
-			uasp_hs_function_desc, uasp_ss_function_desc, NULL);
+			uasp_hs_function_desc, uasp_ss_function_desc,
+			uasp_ss_function_desc);
 	if (ret)
 		goto ep_fail;
 


