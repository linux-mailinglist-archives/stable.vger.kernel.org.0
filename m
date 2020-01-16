Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE6713FD34
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733288AbgAPXXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387787AbgAPXXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 235BB206D9;
        Thu, 16 Jan 2020 23:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216993;
        bh=4fSvwcd259BM5fC+hglvaxeQVV7bqNO09yYzxt3xtds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8Ex1/kBbc+iplFqEy50ov+in9MkR8do4UZdbamcATcq4KhbHUFZZx6nklQEZAkJl
         KP33J0o1ePp3jnGGgsT7Con8eCiwQFPlvbRlYZsvcP4klhKWqYYzv9SWjHD8fsK5Om
         XfUFFniGnyWp9uXeuiuRiDlHY0gcSVvJTZe6ceq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 088/203] platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0
Date:   Fri, 17 Jan 2020 00:16:45 +0100
Message-Id: <20200116231753.351602596@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

commit 176a7fca81c5090a7240664e3002c106d296bf31 upstream.

Some of ASUS laptops like UX431FL keyboard backlight cannot be set to
brightness 0. According to ASUS' information, the brightness should be
0x80 ~ 0x83. This patch fixes it by following the logic.

Fixes: e9809c0b9670 ("asus-wmi: add keyboard backlight support")
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Reviewed-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/asus-wmi.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -512,13 +512,7 @@ static void kbd_led_update(struct asus_w
 {
 	int ctrl_param = 0;
 
-	/*
-	 * bits 0-2: level
-	 * bit 7: light on/off
-	 */
-	if (asus->kbd_led_wk > 0)
-		ctrl_param = 0x80 | (asus->kbd_led_wk & 0x7F);
-
+	ctrl_param = 0x80 | (asus->kbd_led_wk & 0x7F);
 	asus_wmi_set_devstate(ASUS_WMI_DEVID_KBD_BACKLIGHT, ctrl_param, NULL);
 }
 


