Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9005865570C
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbiLXBbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbiLXBbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:31:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662BB2EFAA;
        Fri, 23 Dec 2022 17:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D9461FB3;
        Sat, 24 Dec 2022 01:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E62BC433D2;
        Sat, 24 Dec 2022 01:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845413;
        bh=/489chSvrSehPDPnwlYEg6/lHXpA0t+YpsTDC9zquKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ox14rLJ91qQS/2m5RUDnfucb3cLPB/eXnyKvsu2M/Ap8ZHdDLnD23mX+FUObUGqim
         bacLj7AUdyqW+wN4uqWkk8KIwpgnLblWJJl4plXPE/gOHdWEcUBDiJDuJ268eZaLCU
         1yhL4YijRncpKiIHeKRMOFcQaPPWWd5nd5wVN5QPfSqda7bZUUWubUHIl4j+lllQTC
         WqoRIEpLyQJhB+kjZIS98hwL4d4O/M4RqxOziWzQpL2hf6BdK7a19Quzi7m7nngtg6
         zUyC06j0a+aq+zYlY2vwkF0Av5sW2Yrn8K38bDQFqonmNUijKu6DB+Z2JBQ1fHlpEB
         pA5JEwCZFjONw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 13/26] usb: gadget: f_ecm: Always set current gadget in ecm_bind()
Date:   Fri, 23 Dec 2022 20:29:17 -0500
Message-Id: <20221224012930.392358-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit d65e6b6e884a38360fc1cadf8ff31858151da57f ]

The gadget may change over bind/unbind cycles, so set it each time during
bind, not only the first time. Without it we get a use-after-free with
the following example:

cd /sys/kernel/config/usb_gadget/; mkdir -p mygadget; cd mygadget
mkdir -p configs/c.1/strings/0x409
echo "C1:Composite Device" > configs/c.1/strings/0x409/configuration
mkdir -p functions/ecm.usb0
ln -s functions/ecm.usb0 configs/c.1/
rmmod dummy_hcd
modprobe dummy_hcd

KASAN will complain shortly after the 'modprobe':

usb 2-1: New USB device found, idVendor=0000, idProduct=0000, bcdDevice= 6.01
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
==================================================================
BUG: KASAN: use-after-free in gether_connect+0xb8/0x30c
Read of size 4 at addr cbef170c by task swapper/3/0

CPU: 3 PID: 0 Comm: swapper/3 Not tainted 6.1.0-rc3-00014-g41ff012f50cb-dirty #322
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x58/0x70
 dump_stack_lvl from print_report+0x134/0x4d4
 print_report from kasan_report+0x78/0x10c
 kasan_report from gether_connect+0xb8/0x30c
 gether_connect from ecm_set_alt+0x124/0x254
 ecm_set_alt from composite_setup+0xb98/0x2b18
 composite_setup from configfs_composite_setup+0x80/0x98
 configfs_composite_setup from dummy_timer+0x8f0/0x14a0 [dummy_hcd]
 ...

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20221104131031.850850-3-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_ecm.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/gadget/function/f_ecm.c b/drivers/usb/gadget/function/f_ecm.c
index ffe2486fce71..a7ab30e603e2 100644
--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -685,7 +685,7 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 	struct usb_composite_dev *cdev = c->cdev;
 	struct f_ecm		*ecm = func_to_ecm(f);
 	struct usb_string	*us;
-	int			status;
+	int			status = 0;
 	struct usb_ep		*ep;
 
 	struct f_ecm_opts	*ecm_opts;
@@ -695,23 +695,19 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 
 	ecm_opts = container_of(f->fi, struct f_ecm_opts, func_inst);
 
-	/*
-	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
-	 * configurations are bound in sequence with list_for_each_entry,
-	 * in each configuration its functions are bound in sequence
-	 * with list_for_each_entry, so we assume no race condition
-	 * with regard to ecm_opts->bound access
-	 */
+	mutex_lock(&ecm_opts->lock);
+
+	gether_set_gadget(ecm_opts->net, cdev->gadget);
+
 	if (!ecm_opts->bound) {
-		mutex_lock(&ecm_opts->lock);
-		gether_set_gadget(ecm_opts->net, cdev->gadget);
 		status = gether_register_netdev(ecm_opts->net);
-		mutex_unlock(&ecm_opts->lock);
-		if (status)
-			return status;
 		ecm_opts->bound = true;
 	}
 
+	mutex_unlock(&ecm_opts->lock);
+	if (status)
+		return status;
+
 	ecm_string_defs[1].s = ecm->ethaddr;
 
 	us = usb_gstrings_attach(cdev, ecm_strings,
-- 
2.35.1

