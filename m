Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF6213204A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 08:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgAGHQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 02:16:28 -0500
Received: from inva020.nxp.com ([92.121.34.13]:58024 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgAGHQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 02:16:27 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2C06C1A0837;
        Tue,  7 Jan 2020 08:16:26 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 87DDE1A00D2;
        Tue,  7 Jan 2020 08:16:21 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 09236402C7;
        Tue,  7 Jan 2020 15:16:15 +0800 (SGT)
From:   Ran Wang <ran.wang_1@nxp.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        Jun Li <jun.li@nxp.com>, Peter Chen <peter.chen@nxp.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ran Wang <ran.wang_1@nxp.com>, stable@vger.kernel.org
Subject: [PATCH] usb: dwc3: gadget: Fix controller get stuck when kicking extra transfer in wrong case
Date:   Tue,  7 Jan 2020 15:14:41 +0800
Message-Id: <20200107071441.480-1-ran.wang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to original commit c96e6725db9d6a ("usb: dwc3: gadget: Correct the
logic for queuing sgs"), we would only kick off another transfer in case of
req->num_pending_sgs > 0.

However, current logic will do this as long as req->remaining > 0, this will
include the case of non-sgs (both dwc3_gadget_ep_request_completed(req) and
req->num_pending_sgs are 0) that we did not want to.

Without this fix, we observed dwc3 got stuck on Layerscape plaftorms (such as
LS1088ARDB) when enabling gadget (mass storage function) as below:

[   27.923959] Mass Storage Function, version: 2009/09/11
[   27.929115] LUN: removable file: (no medium)
[   27.933432] LUN: file: /run/media/sda1/419/test
[   27.937963] Number of LUNs=1
[   27.941042] g_mass_storage gadget: Mass Storage Gadget, version: 2009/09/11
[   27.948019] g_mass_storage gadget: userspace failed to provide iSerialNumber
[   27.955069] g_mass_storage gadget: g_mass_storage ready
[   28.411188] g_mass_storage gadget: super-speed config #1: Linux File-Backed Storage
[   48.319766] g_mass_storage gadget: super-speed config #1: Linux File-Backed Storage
[   68.320794] g_mass_storage gadget: super-speed config #1: Linux File-Backed Storage
[   88.319898] g_mass_storage gadget: super-speed config #1: Linux File-Backed Storage
[  108.320808] g_mass_storage gadget: super-speed config #1: Linux File-Backed Storage
[  128.323419] g_mass_storage gadget: super-speed config #1: Linux File-Backed Storage
[  148.320857] g_mass_storage gadget: super-speed config #1: Linux File-Backed Storage
[  148.362023] g_mass_storage gadget: super-speed config #0: unconfigured

Fixes: 8c7d4b7b3d43 ("usb: dwc3: gadget: Fix logical condition")

Cc: stable@vger.kernel.org
Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 0c960a9..5b0f02f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2491,7 +2491,7 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 
 	req->request.actual = req->request.length - req->remaining;
 
-	if (!dwc3_gadget_ep_request_completed(req) ||
+	if (!dwc3_gadget_ep_request_completed(req) &&
 			req->num_pending_sgs) {
 		__dwc3_gadget_kick_transfer(dep);
 		goto out;
-- 
2.7.4

