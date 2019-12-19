Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF36A126CAC
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfLSSpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:45:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbfLSSpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:45:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C452F206D7;
        Thu, 19 Dec 2019 18:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781131;
        bh=ezkUZWW+aPPfL0HkbGgYbkSBfbUVCtbeF5lLBa77mFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMM6yWoFT6Ta9imeLyUUCs3U4quZhQD4DpvK5d71KwtVVskNLFzzEVhE/q7lkmWbL
         0dbNuaPE/MMh/J/XGAMP+mmLGy8v6evWbrEhpmh1xO+TMbNlcytgjVLUIuloMLDX69
         9mFMe/l0F2dk5dFnAiLJxTbiswOC0iSictojtFog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.9 096/199] usb: gadget: configfs: Fix missing spin_lock_init()
Date:   Thu, 19 Dec 2019 19:32:58 +0100
Message-Id: <20191219183220.231253066@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 093edc2baad2c258b1f55d1ab9c63c2b5ae67e42 upstream.

The driver allocates the spinlock but not initialize it.
Use spin_lock_init() on it to initialize it correctly.

This is detected by Coccinelle semantic patch.

Fixes: 1a1c851bbd70 ("usb: gadget: configfs: fix concurrent issue between composite APIs")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20191030034046.188808-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/configfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1541,6 +1541,7 @@ static struct config_group *gadgets_make
 	gi->composite.resume = NULL;
 	gi->composite.max_speed = USB_SPEED_SUPER;
 
+	spin_lock_init(&gi->spinlock);
 	mutex_init(&gi->lock);
 	INIT_LIST_HEAD(&gi->string_list);
 	INIT_LIST_HEAD(&gi->available_func);


