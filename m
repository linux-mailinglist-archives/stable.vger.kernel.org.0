Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307D2137E4C
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgAKKIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgAKKIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:08:17 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17DC22064C;
        Sat, 11 Jan 2020 10:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737297;
        bh=0lK4VOY8PtGifnpe8N3UmYimhiU69nzdp5TXS/Zy5TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wcl9Um8ehtRBK2M9iU54+oyuQcbp5dEJQZZI0tLBTA2S/VchlXCgVnC3mxW9jBaNI
         yGQbhA3RT0S5LkEmzs3ssvFbR8UbHasIBk79N9DxM+Wp0PBfP7D61s9cpGPUAozJmA
         KbUCaXdtxkNfJROfUBEv1ptdba4ejfrhjnPV7gL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.14 02/62] USB: dummy-hcd: increase max number of devices to 32
Date:   Sat, 11 Jan 2020 10:49:44 +0100
Message-Id: <20200111094838.434987692@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

commit 8442b02bf3c6770e0d7e7ea17be36c30e95987b6 upstream.

When fuzzing the USB subsystem with syzkaller, we currently use 8 testing
processes within one VM. To isolate testing processes from one another it
is desirable to assign a dedicated USB bus to each of those, which means
we need at least 8 Dummy UDC/HCD devices.

This patch increases the maximum number of Dummy UDC/HCD devices to 32
(more than 8 in case we need more of them in the future).

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Link: https://lore.kernel.org/r/665578f904484069bb6100fb20283b22a046ad9b.1571667489.git.andreyknvl@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/dummy_hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -2734,7 +2734,7 @@ static struct platform_driver dummy_hcd_
 };
 
 /*-------------------------------------------------------------------------*/
-#define MAX_NUM_UDC	2
+#define MAX_NUM_UDC	32
 static struct platform_device *the_udc_pdev[MAX_NUM_UDC];
 static struct platform_device *the_hcd_pdev[MAX_NUM_UDC];
 


