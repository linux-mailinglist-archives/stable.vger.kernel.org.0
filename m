Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14191D859C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgERRxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731180AbgERRxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:53:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0659D20715;
        Mon, 18 May 2020 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824420;
        bh=XdSVoiFRtf3cyz7ypktPW4mY6jLVSFfO5OzF2dGq2VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKJ3yE655t7s+Kk2Q02ZxP9zI1GFhW/8W8uuHxVcea20ekc4H9o4apVtFJxDo69PY
         ooszUoQ5HeUqxq534Q8tzRHWV0wf0eD8ZYwc1HKThxn9YH+D4H/I0HzZbgFs6DKh9h
         M5mzwxwTCIbnShkJE2qzmNYVbBNP+dTlOTBJy1VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 70/80] usb: gadget: legacy: fix error return code in gncm_bind()
Date:   Mon, 18 May 2020 19:37:28 +0200
Message-Id: <20200518173504.513021640@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit e27d4b30b71c66986196d8a1eb93cba9f602904a upstream.

If 'usb_otg_descriptor_alloc()' fails, we must return a
negative error code -ENOMEM, not 0.

Fixes: 1156e91dd7cc ("usb: gadget: ncm: allocate and init otg descriptor by otg capabilities")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/legacy/ncm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/ncm.c
+++ b/drivers/usb/gadget/legacy/ncm.c
@@ -156,8 +156,10 @@ static int gncm_bind(struct usb_composit
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto fail;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;


