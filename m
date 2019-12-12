Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D414811C853
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 09:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfLLIhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 03:37:35 -0500
Received: from inva020.nxp.com ([92.121.34.13]:55154 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728221AbfLLIhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 03:37:35 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 895681A091F;
        Thu, 12 Dec 2019 09:37:34 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 93B2C1A079F;
        Thu, 12 Dec 2019 09:37:31 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 99B61402B4;
        Thu, 12 Dec 2019 16:37:27 +0800 (SGT)
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com,
        Peter Chen <peter.chen@nxp.com>, Jun Li <jun.li@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2 1/1] usb: gadget: f_fs: set req->num_sgs as 0 for non-sg transfer
Date:   Thu, 12 Dec 2019 16:35:03 +0800
Message-Id: <1576139703-9409-1-git-send-email-peter.chen@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The UDC core uses req->num_sgs to judge if scatter buffer list is used.
Eg: usb_gadget_map_request_by_dev. For f_fs sync io mode, the request
is re-used for each request, so if the 1st request->length > PAGE_SIZE,
and the 2nd request->length is <= PAGE_SIZE, the f_fs uses the 1st
req->num_sgs for the 2nd request, it causes the UDC core get the wrong
req->num_sgs value (The 2nd request doesn't use sg). For f_fs async
io mode, it is not harm to initialize req->num_sgs as 0 either, in case,
the UDC driver doesn't zeroed request structure.

Cc: Jun Li <jun.li@nxp.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather buffers")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
Changes for v2:
- Using the correct patch, and initialize req->num_sgs as 0 for aio too.

 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 59d9d512dcda..ced2581cf99f 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1062,6 +1062,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			req->num_sgs = io_data->sgt.nents;
 		} else {
 			req->buf = data;
+			req->num_sgs = 0;
 		}
 		req->length = data_len;
 
@@ -1105,6 +1106,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			req->num_sgs = io_data->sgt.nents;
 		} else {
 			req->buf = data;
+			req->num_sgs = 0;
 		}
 		req->length = data_len;
 
-- 
2.17.1

