Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7FC2AB998
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbgKINKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:10:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732110AbgKINKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:10:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 033DF20789;
        Mon,  9 Nov 2020 13:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927435;
        bh=fbahKZc44o8VUHM3UKAC7qeKy2dI9PslnMJ+rRNFXN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugV2EX69XPJbaqNojw91MhskOw1hbMbnfpPAB4lgOX4rvzFmoCVnH1qx8S0cWlu49
         cpIW6yy4G5+OcepkzxaL3s5vUJWMEsuoZTtQFnf5kmRNsOffbdamI+cacijAefiJ0R
         SQSk4bfzmrdFz+nqWEtLrlntGrqZJGTY/PxFiW08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH 4.19 58/71] serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init
Date:   Mon,  9 Nov 2020 13:55:52 +0100
Message-Id: <20201109125022.634027212@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
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
@@ -1284,6 +1284,9 @@ static int __init serial_txx9_init(void)
 
 #ifdef ENABLE_SERIAL_TXX9_PCI
 	ret = pci_register_driver(&serial_txx9_pci_driver);
+	if (ret) {
+		platform_driver_unregister(&serial_txx9_plat_driver);
+	}
 #endif
 	if (ret == 0)
 		goto out;


