Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F59132E7D7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCEMXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:23:05 -0500
Received: from smtp-out.xnet.cz ([178.217.244.18]:28888 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhCEMXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:23:00 -0500
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id C33C13FF0;
        Fri,  5 Mar 2021 13:22:56 +0100 (CET)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id e3a969a0;
        Fri, 5 Mar 2021 13:22:36 +0100 (CET)
Date:   Fri, 5 Mar 2021 13:22:36 +0100
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     stable@vger.kernel.org
Cc:     Rui Salvaterra <rsalvaterra@gmail.com>,
        openwrt-devel@lists.openwrt.org, rosenp@gmail.com
Subject: Backport of 'usbip: tools: fix build error for multiple definition'
 [Was: Re: [PATCH] kernel: backport GCC 10 usbip build fix for 5.4]
Message-ID: <20210305122236.GG92607@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <20210305120931.692973-1-rsalvaterra@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120931.692973-1-rsalvaterra@gmail.com>
X-PGP-Key: https://gist.githubusercontent.com/ynezz/477f6d7a1623a591b0806699f9fc8a27/raw/a0878b8ed17e56f36ebf9e06a6b888a2cd66281b/pgp-key.pub
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable,

can we please get following patch from v5.9-rc1~142^2~213 backported into the
stable kernels?

 From d5efc2e6b98fe661dbd8dd0d5d5bfb961728e57a Mon Sep 17 00:00:00 2001
 From: Antonio Borneo <borneo.antonio@gmail.com>
 Date: Thu, 18 Jun 2020 02:08:44 +0200
 Subject: usbip: tools: fix build error for multiple definition

Thanks!

Cheers,

Petr

> From the original commit message:
> 
> "With GCC 10, building usbip triggers error for multiple definition
> of 'udev_context', in:
> - libsrc/vhci_driver.c:18 and
> - libsrc/usbip_host_common.c:27.
> 
> Declare as extern the definition in libsrc/usbip_host_common.c."
> 
> Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>
> ---
>  ...-build-error-for-multiple-definition.patch | 33 +++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 target/linux/generic/backport-5.4/831-v5.9-usbip-tools-fix-build-error-for-multiple-definition.patch
> 
> diff --git a/target/linux/generic/backport-5.4/831-v5.9-usbip-tools-fix-build-error-for-multiple-definition.patch b/target/linux/generic/backport-5.4/831-v5.9-usbip-tools-fix-build-error-for-multiple-definition.patch
> new file mode 100644
> index 0000000000..03f27fb528
> --- /dev/null
> +++ b/target/linux/generic/backport-5.4/831-v5.9-usbip-tools-fix-build-error-for-multiple-definition.patch
> @@ -0,0 +1,33 @@
> +From d5efc2e6b98fe661dbd8dd0d5d5bfb961728e57a Mon Sep 17 00:00:00 2001
> +From: Antonio Borneo <borneo.antonio@gmail.com>
> +Date: Thu, 18 Jun 2020 02:08:44 +0200
> +Subject: usbip: tools: fix build error for multiple definition
> +
> +With GCC 10, building usbip triggers error for multiple definition
> +of 'udev_context', in:
> +- libsrc/vhci_driver.c:18 and
> +- libsrc/usbip_host_common.c:27.
> +
> +Declare as extern the definition in libsrc/usbip_host_common.c.
> +
> +Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
> +Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> +Link: https://lore.kernel.org/r/20200618000844.1048309-1-borneo.antonio@gmail.com
> +Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> +---
> + tools/usb/usbip/libsrc/usbip_host_common.c | 2 +-
> + 1 file changed, 1 insertion(+), 1 deletion(-)
> +
> +(limited to 'tools/usb/usbip')
> +
> +--- a/tools/usb/usbip/libsrc/usbip_host_common.c
> ++++ b/tools/usb/usbip/libsrc/usbip_host_common.c
> +@@ -23,7 +23,7 @@
> + #include "list.h"
> + #include "sysfs_utils.h"
> + 
> +-struct udev *udev_context;
> ++extern struct udev *udev_context;
> + 
> + static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
> + {
> -- 
> 2.30.1
