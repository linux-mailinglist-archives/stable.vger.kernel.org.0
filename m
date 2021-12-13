Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA89472782
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbhLMKBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:01:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45968 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbhLMJ7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:59:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42C7BB80E77;
        Mon, 13 Dec 2021 09:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C51C34601;
        Mon, 13 Dec 2021 09:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389584;
        bh=WXMDWIZdNPtfYwTwtejyjnPNuMZjWiv2DkxxbW2jCRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxBibb1w8FxvkduE5Sm0Ih6GR4Rs19X9znspsj/bpjTGXHOucWcrOxQaSg8ohOD/m
         k1N+vQ73sQPYa6sxsHbuKWyVoGtIE3Bryhmk290dnx8YF3hjqUZlDswFvKZ0KMZmMi
         kRjP8RKtLum3LjfBit3RNpRfZZpeLr1DlIfmJWCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Heidrich <szymon.heidrich@gmail.com>
Subject: [PATCH 5.15 137/171] USB: gadget: zero allocate endpoint 0 buffers
Date:   Mon, 13 Dec 2021 10:30:52 +0100
Message-Id: <20211213092949.651414710@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 86ebbc11bb3f60908a51f3e41a17e3f477c2eaa3 upstream.

Under some conditions, USB gadget devices can show allocated buffer
contents to a host.  Fix this up by zero-allocating them so that any
extra data will all just be zeros.

Reported-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Tested-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c   |    2 +-
 drivers/usb/gadget/legacy/dbgp.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2221,7 +2221,7 @@ int composite_dev_prepare(struct usb_com
 	if (!cdev->req)
 		return -ENOMEM;
 
-	cdev->req->buf = kmalloc(USB_COMP_EP0_BUFSIZ, GFP_KERNEL);
+	cdev->req->buf = kzalloc(USB_COMP_EP0_BUFSIZ, GFP_KERNEL);
 	if (!cdev->req->buf)
 		goto fail;
 
--- a/drivers/usb/gadget/legacy/dbgp.c
+++ b/drivers/usb/gadget/legacy/dbgp.c
@@ -137,7 +137,7 @@ static int dbgp_enable_ep_req(struct usb
 		goto fail_1;
 	}
 
-	req->buf = kmalloc(DBGP_REQ_LEN, GFP_KERNEL);
+	req->buf = kzalloc(DBGP_REQ_LEN, GFP_KERNEL);
 	if (!req->buf) {
 		err = -ENOMEM;
 		stp = 2;


