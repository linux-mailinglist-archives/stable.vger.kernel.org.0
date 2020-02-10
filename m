Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0DC157886
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgBJNIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:08:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbgBJMje (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:34 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15C3F20842;
        Mon, 10 Feb 2020 12:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338374;
        bh=ZgdRohyeoqyTe+zFijsGSWH8xU5n9mO1FJu1F/BIhj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVy8k0+WwvNCWuR2J4ZP7GT/fhXneKnH8yguFhJwjxqlhh/Y6o2CUnggAnXo2BaLW
         BKMEwBDPHrO8cPSbr7zoLQMSl4eTMPFvBSvo/QWdYJ5ulnhr/dVpgkf1ec0gAdCvo7
         l5In4osbZE1CQ6LjKUA/jh2Ff5WehQgfSFAdA7M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.5 047/367] usb: gadget: f_fs: set req->num_sgs as 0 for non-sg transfer
Date:   Mon, 10 Feb 2020 04:29:20 -0800
Message-Id: <20200210122428.383827294@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit d2450c6937018d40d4111fe830fa48d4ddceb8d0 upstream.

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
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_fs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1062,6 +1062,7 @@ static ssize_t ffs_epfile_io(struct file
 			req->num_sgs = io_data->sgt.nents;
 		} else {
 			req->buf = data;
+			req->num_sgs = 0;
 		}
 		req->length = data_len;
 
@@ -1105,6 +1106,7 @@ static ssize_t ffs_epfile_io(struct file
 			req->num_sgs = io_data->sgt.nents;
 		} else {
 			req->buf = data;
+			req->num_sgs = 0;
 		}
 		req->length = data_len;
 


