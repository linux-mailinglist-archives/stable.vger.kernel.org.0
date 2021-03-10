Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084CF333E6B
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhCJN0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhCJNZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9417B65030;
        Wed, 10 Mar 2021 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382720;
        bh=RTubKmSeI2vbzOr6c61McxKmecNOPSUfeMLlOURJP5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1swo4yJFtVGxdKzksycB24b2P9qUmcsk4X61du/PAoaMweSYP+1b1WF+A1RlK7/+0
         G0YyGFYcBEJZW0hgZ2DvaiHGY8r+gg0LQi5QiqjenOyTrnX55Es9PDTzo/AiE55XgZ
         HXb8jPPS784wbSU6aFN5Psn6rKJ7Ew3gO9EENAXg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Borneo <borneo.antonio@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH 4.9 03/11] usbip: tools: fix build error for multiple definition
Date:   Wed, 10 Mar 2021 14:25:02 +0100
Message-Id: <20210310132320.498616113@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
References: <20210310132320.393957501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Antonio Borneo <borneo.antonio@gmail.com>

commit d5efc2e6b98fe661dbd8dd0d5d5bfb961728e57a upstream.

With GCC 10, building usbip triggers error for multiple definition
of 'udev_context', in:
- libsrc/vhci_driver.c:18 and
- libsrc/usbip_host_common.c:27.

Declare as extern the definition in libsrc/usbip_host_common.c.

Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20200618000844.1048309-1-borneo.antonio@gmail.com
Cc: Petr Štetiar <ynezz@true.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/usb/usbip/libsrc/usbip_host_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/usb/usbip/libsrc/usbip_host_common.c
+++ b/tools/usb/usbip/libsrc/usbip_host_common.c
@@ -35,7 +35,7 @@
 #include "list.h"
 #include "sysfs_utils.h"
 
-struct udev *udev_context;
+extern struct udev *udev_context;
 
 static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 {


