Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15444289AE
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390025AbfEWTlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389628AbfEWTUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C4C921841;
        Thu, 23 May 2019 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639221;
        bh=DR2Hg/fRrmYxcQi0/v7BdYlawFDvUxGS549mG4XxQ/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cg5faHpgrfjYzW6vuh38XdoYD7KQ3R2goFYt5/qoMWG5NrcML2jlavwzSBcvE9aCq
         W5M2dyr2mKZeXYwHIVnKOGuzsuf9VSEQdCxCmhQciCA8FdtajRpMya3n2gCD3+l34q
         FijIJpPlTno1H0LQG3kX7lGDfbeFK8qYu/Hji30o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.0 024/139] parisc: Skip registering LED when running in QEMU
Date:   Thu, 23 May 2019 21:05:12 +0200
Message-Id: <20190523181723.869543947@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit b438749044356dd1329c45e9b5a9377b6ea13eb2 upstream.

No need to spend CPU cycles when we run on QEMU.

Signed-off-by: Helge Deller <deller@gmx.de>
CC: stable@vger.kernel.org # v4.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/parisc/led.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -568,6 +568,9 @@ int __init register_led_driver(int model
 		break;
 
 	case DISPLAY_MODEL_LASI:
+		/* Skip to register LED in QEMU */
+		if (running_on_qemu)
+			return 1;
 		LED_DATA_REG = data_reg;
 		led_func_ptr = led_LASI_driver;
 		printk(KERN_INFO "LED display at %lx registered\n", LED_DATA_REG);


