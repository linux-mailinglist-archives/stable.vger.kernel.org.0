Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDF544C722
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhKJSsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233043AbhKJSrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:47:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F039461186;
        Wed, 10 Nov 2021 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569901;
        bh=aHc5jknybsG3Wm81xKHeZa7RkwTtI7oiN6Z7CZwMrxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipMV0+0kDD7bk4UdtxW1bEyZBB+pHcTTzAj5JG+qdwvTMNkbbjVAarqh2TLel4PDs
         C8Xs/g+G1Q1oOi3EmnfmxazlxLqWbNIa8vaTDGOflJ1U2HA8hE/APpARzjkoWqFgsB
         TECuJ16GqGYmO0SqC8TbuXRx1Ls5RAPaHrZ3m41s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 20/22] staging: r8712u: fix control-message timeout
Date:   Wed, 10 Nov 2021 19:43:27 +0100
Message-Id: <20211110182002.234440132@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
References: <20211110182001.579561273@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ce4940525f36ffdcf4fa623bcedab9c2a6db893a upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
Cc: stable@vger.kernel.org      # 2.6.37
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211025120910.6339-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/usb_ops_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -504,7 +504,7 @@ int r8712_usbctrl_vendorreq(struct intf_
 		memcpy(pIo_buf, pdata, len);
 	}
 	status = usb_control_msg(udev, pipe, request, reqtype, value, index,
-				 pIo_buf, len, HZ / 2);
+				 pIo_buf, len, 500);
 	if (status > 0) {  /* Success this control transfer. */
 		if (requesttype == 0x01) {
 			/* For Control read transfer, we have to copy the read


