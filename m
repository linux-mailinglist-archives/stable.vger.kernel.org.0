Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEAA472400
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhLMJdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:33:25 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58064 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbhLMJdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:33:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B68F1CE0E6B;
        Mon, 13 Dec 2021 09:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F77C00446;
        Mon, 13 Dec 2021 09:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639387991;
        bh=3HWsN2RFtBrUxlWtXazhc9PegL69XzYtaKlCzUGCkd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbbhch3zhDEE/KiFVxOLgwO5vYAHAbsFF1nMhhnntZDmJ5H7LaQOmyCGyosmusgWl
         Zn1lqAMY/k6JHTMbMoRyV07+1elB00f+PycHss4NHaBr1T1zA5r6hOSVBo7Af9fbge
         MSStdPxcrbwenC+0837ftlSS6omOzdw3soyP6Hn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Heidrich <szymon.heidrich@gmail.com>
Subject: [PATCH 4.4 29/37] USB: gadget: zero allocate endpoint 0 buffers
Date:   Mon, 13 Dec 2021 10:30:07 +0100
Message-Id: <20211213092926.328618176@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
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
@@ -2018,7 +2018,7 @@ int composite_dev_prepare(struct usb_com
 	if (!cdev->req)
 		return -ENOMEM;
 
-	cdev->req->buf = kmalloc(USB_COMP_EP0_BUFSIZ, GFP_KERNEL);
+	cdev->req->buf = kzalloc(USB_COMP_EP0_BUFSIZ, GFP_KERNEL);
 	if (!cdev->req->buf)
 		goto fail;
 
--- a/drivers/usb/gadget/legacy/dbgp.c
+++ b/drivers/usb/gadget/legacy/dbgp.c
@@ -136,7 +136,7 @@ static int dbgp_enable_ep_req(struct usb
 		goto fail_1;
 	}
 
-	req->buf = kmalloc(DBGP_REQ_LEN, GFP_KERNEL);
+	req->buf = kzalloc(DBGP_REQ_LEN, GFP_KERNEL);
 	if (!req->buf) {
 		err = -ENOMEM;
 		stp = 2;


