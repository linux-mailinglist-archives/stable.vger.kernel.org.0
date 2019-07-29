Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC21079886
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388745AbfG2Thl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388731AbfG2Thl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:37:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08952171F;
        Mon, 29 Jul 2019 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429060;
        bh=sw7NaxbdxmEM6aRee2IGjhr908nG873HqFG3gLRoZso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeX3dHfVoIMM5hOFuqr2H+9+Pj7L76ANiC2hY/Er3gksYvrEcBemoSGYxc2tzzpPJ
         w6u/Ydq/u21Fix4ciP0XfhqKZ5KXPFIT5Y5yEIA+2HoA3lzXka/b7LoNoOF+L2POUR
         aVdNXkbbFkWLybNfoQw9tVsQV0ykpZmCDZuK6b6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 233/293] tty/serial: digicolor: Fix digicolor-usart already registered warning
Date:   Mon, 29 Jul 2019 21:22:04 +0200
Message-Id: <20190729190842.338566469@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



