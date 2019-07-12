Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB4E66DC8
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbfGLMdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbfGLMd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:33:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E09EE208E4;
        Fri, 12 Jul 2019 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934807;
        bh=BVaPzCcCRxog7PRN36yt9WFA3YWErUvntYn/2BoLlTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3ct9BjszYQUmjrUSl8Z6yqH6Fpa5YEXRvWIqDQF3GH2scNkvA3gfXTfhoxdBfFOe
         9LJE5BOUU7Kt0dx5iUnUa76qntvLvngceu7nL39w6zzlsvJblyiBsrT4UDnULilQ5V
         iFUsIeNlpwQLD1j8rjGu+neOQhodgKYaag8/A4ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 5.2 36/61] staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()
Date:   Fri, 12 Jul 2019 14:19:49 +0200
Message-Id: <20190712121622.540802831@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

commit 6419f818ababebc1116fb2d0e220bd4fe835d0e3 upstream.

For the error path in wilc_wlan_initialize(), the resources are not
cleanup in the correct order. Reverted the previous changes and use the
correct order to free during error condition.

Fixes: b46d68825c2d ("staging: wilc1000: remove COMPLEMENT_BOOT")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wilc1000/wilc_netdev.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/wilc1000/wilc_netdev.c
+++ b/drivers/staging/wilc1000/wilc_netdev.c
@@ -530,17 +530,17 @@ static int wilc_wlan_initialize(struct n
 			goto fail_locks;
 		}
 
-		if (wl->gpio_irq && init_irq(dev)) {
-			ret = -EIO;
-			goto fail_locks;
-		}
-
 		ret = wlan_initialize_threads(dev);
 		if (ret < 0) {
 			ret = -EIO;
 			goto fail_wilc_wlan;
 		}
 
+		if (wl->gpio_irq && init_irq(dev)) {
+			ret = -EIO;
+			goto fail_threads;
+		}
+
 		if (!wl->dev_irq_num &&
 		    wl->hif_func->enable_interrupt &&
 		    wl->hif_func->enable_interrupt(wl)) {
@@ -596,7 +596,7 @@ fail_irq_enable:
 fail_irq_init:
 		if (wl->dev_irq_num)
 			deinit_irq(dev);
-
+fail_threads:
 		wlan_deinitialize_threads(dev);
 fail_wilc_wlan:
 		wilc_wlan_cleanup(dev);


