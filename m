Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E1C2ABADB
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388012AbgKINVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731378AbgKINVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:21:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B747B20731;
        Mon,  9 Nov 2020 13:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928068;
        bh=8jU8YRDsnJQt9GoP2tCqObzSV/epvN9YXHzwMWPz1cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIhLZA7sixmh5b2tVx6i7iUjbcCPcghaW0lQEeMNMx/9mPdQzOsTmMQnb1/EmnnqC
         J7j5hjrdf9Lb/3NO4FraUsodRofsxryGD7qelwLwu8ReuINz2uOWN1F869yFU785u+
         DAqw0mYEKm7K6EdNm79jh0D3D2T4yKwNcamIb9h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH 5.9 116/133] serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init
Date:   Mon,  9 Nov 2020 13:56:18 +0100
Message-Id: <20201109125036.269355216@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

commit 0c5fc92622ed5531ff324b20f014e9e3092f0187 upstream.

Add the missing platform_driver_unregister() before return
from serial_txx9_init in the error handling case when failed
to register serial_txx9_pci_driver with macro ENABLE_SERIAL_TXX9_PCI
defined.

Fixes: ab4382d27412 ("tty: move drivers/serial/ to drivers/tty/serial/")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201103084942.109076-1-miaoqinglang@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_txx9.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -1280,6 +1280,9 @@ static int __init serial_txx9_init(void)
 
 #ifdef ENABLE_SERIAL_TXX9_PCI
 	ret = pci_register_driver(&serial_txx9_pci_driver);
+	if (ret) {
+		platform_driver_unregister(&serial_txx9_plat_driver);
+	}
 #endif
 	if (ret == 0)
 		goto out;


