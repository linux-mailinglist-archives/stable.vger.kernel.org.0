Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBB6B5CF9
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfIRGXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbfIRGXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:23:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55FA221920;
        Wed, 18 Sep 2019 06:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787826;
        bh=wurMpU2luWZUkpq18BV/CBskZggapk4cqunxM/1szqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WB0W1n2HZFLRzCqk0dcs1p5GU05+XmJ0HamPo1+lYAyFFb11nnAzmaNBLaaS38nJ8
         txTmuL6jF+3OAgpUanvMysa0BF3CiL8Qe5rfVLJay8OrBiUcoFA1fHOW4VSwkgYxBk
         eRqKW7YqSCYDXJ0xz0cYxROV4k7+LeAdNOTvlwwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 48/50] rsi: fix a double free bug in rsi_91x_deinit()
Date:   Wed, 18 Sep 2019 08:19:31 +0200
Message-Id: <20190918061228.569674860@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Peng <benquike@gmail.com>

commit 8b51dc7291473093c821195c4b6af85fadedbc2f upstream.

`dev` (struct rsi_91x_usbdev *) field of adapter
(struct rsi_91x_usbdev *) is allocated  and initialized in
`rsi_init_usb_interface`. If any error is detected in information
read from the device side,  `rsi_init_usb_interface` will be
freed. However, in the higher level error handling code in
`rsi_probe`, if error is detected, `rsi_91x_deinit` is called
again, in which `dev` will be freed again, resulting double free.

This patch fixes the double free by removing the free operation on
`dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
used in `rsi_disconnect`, in that code path, the `dev` field is not
 (and thus needs to be) freed.

This bug was found in v4.19, but is also present in the latest version
of kernel. Fixes CVE-2019-15504.

Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Signed-off-by: Hui Peng <benquike@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rsi/rsi_91x_usb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -643,7 +643,6 @@ fail_rx:
 	kfree(rsi_dev->tx_buffer);
 
 fail_eps:
-	kfree(rsi_dev);
 
 	return status;
 }


