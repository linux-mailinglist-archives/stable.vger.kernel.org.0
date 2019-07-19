Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5166DD4B
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388464AbfGSELb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388459AbfGSELa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:11:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B68218BB;
        Fri, 19 Jul 2019 04:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509489;
        bh=QoNhA/E3iRwdS19rm21kkSOAa3YfFVivd0airztDrc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suj/ALOMHKukokM9xpwiHu5br+71Wc78F/zKSUgQdGtsDMZ70fGyP0kbJBGyA3dZA
         kgtU6gk24FVZ1Nw3POPO+oQefNyqOpgZb4sO5Bl5dM4j2KGV6j3ejVTyVYnbI8Sy/2
         6hO8H83TXDfL/1l6OFLMqRllKp9/CrGY+NMyWJLw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/60] tty/serial: digicolor: Fix digicolor-usart already registered warning
Date:   Fri, 19 Jul 2019 00:10:21 -0400
Message-Id: <20190719041109.18262-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit c7ad9ba0611c53cfe194223db02e3bca015f0674 ]

When modprobe/rmmod/modprobe module, if platform_driver_register() fails,
the kernel complained,

  proc_dir_entry 'driver/digicolor-usart' already registered
  WARNING: CPU: 1 PID: 5636 at fs/proc/generic.c:360 proc_register+0x19d/0x270

Fix this by adding uart_unregister_driver() when platform_driver_register() fails.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/digicolor-usart.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index 02ad6953b167..50ec5f1ac77f 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -545,7 +545,11 @@ static int __init digicolor_uart_init(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&digicolor_uart_platform);
+	ret = platform_driver_register(&digicolor_uart_platform);
+	if (ret)
+		uart_unregister_driver(&digicolor_uart);
+
+	return ret;
 }
 module_init(digicolor_uart_init);
 
-- 
2.20.1

