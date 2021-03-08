Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264F3330DA9
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCHMbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:31:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhCHMbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE053651CC;
        Mon,  8 Mar 2021 12:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206673;
        bh=ba0p3qJvEOYyMzlVdurrizJvB1qFnqiYanvqoT1heso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncJOouQ8C9FtLqUFYWpuMBKavbjxyI0+6KQikkmj0cFK2IvujXskNkK2nuK+moAyI
         5GdUlCtDD1Lu6zv48mcMAsyujcQ1ZfJw/VOYmQufZjQkO+2RUrHEiKm6UX0PNtdPJO
         7j6lKHTiP3nIQJ9P4hL/sroiQLFxaN9XiBgtxF68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Borneo <borneo.antonio@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH 5.4 15/22] usbip: tools: fix build error for multiple definition
Date:   Mon,  8 Mar 2021 13:30:32 +0100
Message-Id: <20210308122715.131460346@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -23,7 +23,7 @@
 #include "list.h"
 #include "sysfs_utils.h"
 
-struct udev *udev_context;
+extern struct udev *udev_context;
 
 static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 {


