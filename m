Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C05EF7F42
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKKTJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:09:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbfKKSdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:33:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F9720656;
        Mon, 11 Nov 2019 18:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497231;
        bh=tLGNzM1ESzY0AC4R6Ft+QUd5Jg4tuJOTcEn0pW8yYYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMyXX113Q0pArW6498K+QmFj8x1zwtS2r5MkrUWAY6/N8hRwSbGkjZlSchez7zX8v
         eyziNXRQFiWfWNeCPE0wbVrdLoGA/8nedtqqi7PABYxk8rYhcLWbUWtgBye0ZZXIRo
         OktbPNmpTtpqqWD1E5xkJurgwKso/tjh88cb+Zcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chandana Kishori Chiluveru <cchiluve@codeaurora.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 46/65] usb: gadget: composite: Fix possible double free memory bug
Date:   Mon, 11 Nov 2019 19:28:46 +0100
Message-Id: <20191111181349.413232862@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandana Kishori Chiluveru <cchiluve@codeaurora.org>

[ Upstream commit 1c20c89b0421b52b2417bb0f62a611bc669eda1d ]

composite_dev_cleanup call from the failure of configfs_composite_bind
frees up the cdev->os_desc_req and cdev->req. If the previous calls of
bind and unbind is successful these will carry stale values.

Consider the below sequence of function calls:
configfs_composite_bind()
        composite_dev_prepare()
                - Allocate cdev->req, cdev->req->buf
        composite_os_desc_req_prepare()
                - Allocate cdev->os_desc_req, cdev->os_desc_req->buf
configfs_composite_unbind()
        composite_dev_cleanup()
                - free the cdev->os_desc_req->buf and cdev->req->buf
Next composition switch
configfs_composite_bind()
        - If it fails goto err_comp_cleanup will call the
	  composite_dev_cleanup() function
        composite_dev_cleanup()
	        - calls kfree up with the stale values of cdev->req->buf and
		  cdev->os_desc_req from the previous configfs_composite_bind
		  call. The free call on these stale values leads to double free.

Hence, Fix this issue by setting request and buffer pointer to NULL after
kfree.

Signed-off-by: Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 9fa168af847b5..854c4ec0af2c5 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2179,14 +2179,18 @@ void composite_dev_cleanup(struct usb_composite_dev *cdev)
 			usb_ep_dequeue(cdev->gadget->ep0, cdev->os_desc_req);
 
 		kfree(cdev->os_desc_req->buf);
+		cdev->os_desc_req->buf = NULL;
 		usb_ep_free_request(cdev->gadget->ep0, cdev->os_desc_req);
+		cdev->os_desc_req = NULL;
 	}
 	if (cdev->req) {
 		if (cdev->setup_pending)
 			usb_ep_dequeue(cdev->gadget->ep0, cdev->req);
 
 		kfree(cdev->req->buf);
+		cdev->req->buf = NULL;
 		usb_ep_free_request(cdev->gadget->ep0, cdev->req);
+		cdev->req = NULL;
 	}
 	cdev->next_string_id = 0;
 	device_remove_file(&cdev->gadget->dev, &dev_attr_suspended);
-- 
2.20.1



