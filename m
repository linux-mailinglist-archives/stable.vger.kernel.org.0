Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA21911C483
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 05:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfLLEBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 23:01:52 -0500
Received: from inva020.nxp.com ([92.121.34.13]:60432 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfLLEBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 23:01:52 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 32BDC1A1075;
        Thu, 12 Dec 2019 05:01:50 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3D3101A08FB;
        Thu, 12 Dec 2019 05:01:47 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 3AC9B402B1;
        Thu, 12 Dec 2019 12:01:43 +0800 (SGT)
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com,
        Peter Chen <peter.chen@nxp.com>, Jun Li <jun.li@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/1] usb: gadget: f_fs: set req->num_sgs as 0 for sync io mode
Date:   Thu, 12 Dec 2019 11:59:20 +0800
Message-Id: <1576123160-28931-1-git-send-email-peter.chen@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The UDC core uses req->num_sgs to judge if scatter buffer list is used.
Eg: usb_gadget_map_request_by_dev. For f_fs sync io mode, the request
is re-used for each request, so if the 1st request->length > PAGE_SIZE,
and the 2nd request->length is < PAGE_SIZE, the f_fs uses the 1st
req->num_sgs for the 2nd request, it causes the UDC core get the wrong
req->num_sgs value (The 2nd request doesn't use sg).

We set req->num_sgs as 0 for each request at non-sg transfer case to
fix it.

Cc: Jun Li <jun.li@nxp.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather buffers")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/gadget/function/f_fs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index eedd926cc578..b5a1bfc2fc7e 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1106,7 +1106,6 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			req->num_sgs = io_data->sgt.nents;
 		} else {
 			req->buf = data;
-			req->num_sgs = 0;
 		}
 		req->length = data_len;
 
-- 
2.17.1

