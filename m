Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C732F175D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbhAKOFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729958AbhAKNEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:04:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F2422515;
        Mon, 11 Jan 2021 13:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370233;
        bh=rwPYVE94HfNpJFsSt+E5hlbIoXRvehJRH/rC2WXnwAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/WQfW2+G3oUWzKplWLumJswMepTsk1DzEi/e8HYEM62JUyDDM9UEDWz+ZjLlvDtV
         4GdaYM7wl1TpljX88xHWCSc5v/ey1uegBBgDEo9TMX6yi9GUdaXtqOKwa7x57rRGoU
         boG4jujSNAh0yaUSHNKQIS96jgeLx9oWbXgx2/zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 4.9 35/45] USB: gadget: legacy: fix return error code in acm_ms_bind()
Date:   Mon, 11 Jan 2021 14:01:13 +0100
Message-Id: <20210111130035.344704997@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit c91d3a6bcaa031f551ba29a496a8027b31289464 upstream.

If usb_otg_descriptor_alloc() failed, it need return ENOMEM.

Fixes: 578aa8a2b12c ("usb: gadget: acm_ms: allocate and init otg descriptor by otg capabilities")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201117092955.4102785-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/legacy/acm_ms.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/acm_ms.c
+++ b/drivers/usb/gadget/legacy/acm_ms.c
@@ -207,8 +207,10 @@ static int acm_ms_bind(struct usb_compos
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto fail_string_ids;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;


