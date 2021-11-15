Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D368B45248D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350838AbhKPBje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241965AbhKOSbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3253D63219;
        Mon, 15 Nov 2021 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999160;
        bh=mKVVGh4uGNlGiSXKQcR2phO36s1abqmtM1jF4zsAxdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmEkbp21LfME8vscNij9rN3TOY/87m1OATe1BK+ahqeszlhPX4orr4i5GV0L9BRcL
         st6MYtrBrVzl02xuaSBkFqHiDKO4V7Vmb8AThwCRNnzC6KRdasIyVkv6KZ9DJS7J+d
         k7qIj0MipfDSk5PgIqhn1iKZ1cMwxM8G54TZT7Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 198/849] USB: serial: keyspan: fix memleak on probe errors
Date:   Mon, 15 Nov 2021 17:54:41 +0100
Message-Id: <20211115165426.891877679@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

commit 910c996335c37552ee30fcb837375b808bb4f33b upstream.

I got memory leak as follows when doing fault injection test:

unreferenced object 0xffff888258228440 (size 64):
  comm "kworker/7:2", pid 2005, jiffies 4294989509 (age 824.540s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8167939c>] slab_post_alloc_hook+0x9c/0x490
    [<ffffffff8167f627>] kmem_cache_alloc_trace+0x1f7/0x470
    [<ffffffffa02ac0e4>] keyspan_port_probe+0xa4/0x5d0 [keyspan]
    [<ffffffffa0294c07>] usb_serial_device_probe+0x97/0x1d0 [usbserial]
    [<ffffffff82b50ca7>] really_probe+0x167/0x460
    [<ffffffff82b51099>] __driver_probe_device+0xf9/0x180
    [<ffffffff82b51173>] driver_probe_device+0x53/0x130
    [<ffffffff82b516f5>] __device_attach_driver+0x105/0x130
    [<ffffffff82b4cfe9>] bus_for_each_drv+0x129/0x190
    [<ffffffff82b50a69>] __device_attach+0x1c9/0x270
    [<ffffffff82b518d0>] device_initial_probe+0x20/0x30
    [<ffffffff82b4f062>] bus_probe_device+0x142/0x160
    [<ffffffff82b4a4e9>] device_add+0x829/0x1300
    [<ffffffffa0295fda>] usb_serial_probe.cold+0xc9b/0x14ac [usbserial]
    [<ffffffffa02266aa>] usb_probe_interface+0x1aa/0x3c0 [usbcore]
    [<ffffffff82b50ca7>] really_probe+0x167/0x460

If keyspan_port_probe() fails to allocate memory for an out_buffer[i] or
in_buffer[i], the previously allocated memory for out_buffer or
in_buffer needs to be freed on the error handling path, otherwise a
memory leak will result.

Fixes: bad41a5bf177 ("USB: keyspan: fix port DMA-buffer allocations")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20211015085543.1203011-1-wanghai38@huawei.com
Cc: stable@vger.kernel.org      # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2890,22 +2890,22 @@ static int keyspan_port_probe(struct usb
 	for (i = 0; i < ARRAY_SIZE(p_priv->in_buffer); ++i) {
 		p_priv->in_buffer[i] = kzalloc(IN_BUFLEN, GFP_KERNEL);
 		if (!p_priv->in_buffer[i])
-			goto err_in_buffer;
+			goto err_free_in_buffer;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(p_priv->out_buffer); ++i) {
 		p_priv->out_buffer[i] = kzalloc(OUT_BUFLEN, GFP_KERNEL);
 		if (!p_priv->out_buffer[i])
-			goto err_out_buffer;
+			goto err_free_out_buffer;
 	}
 
 	p_priv->inack_buffer = kzalloc(INACK_BUFLEN, GFP_KERNEL);
 	if (!p_priv->inack_buffer)
-		goto err_inack_buffer;
+		goto err_free_out_buffer;
 
 	p_priv->outcont_buffer = kzalloc(OUTCONT_BUFLEN, GFP_KERNEL);
 	if (!p_priv->outcont_buffer)
-		goto err_outcont_buffer;
+		goto err_free_inack_buffer;
 
 	p_priv->device_details = d_details;
 
@@ -2951,15 +2951,14 @@ static int keyspan_port_probe(struct usb
 
 	return 0;
 
-err_outcont_buffer:
+err_free_inack_buffer:
 	kfree(p_priv->inack_buffer);
-err_inack_buffer:
+err_free_out_buffer:
 	for (i = 0; i < ARRAY_SIZE(p_priv->out_buffer); ++i)
 		kfree(p_priv->out_buffer[i]);
-err_out_buffer:
+err_free_in_buffer:
 	for (i = 0; i < ARRAY_SIZE(p_priv->in_buffer); ++i)
 		kfree(p_priv->in_buffer[i]);
-err_in_buffer:
 	kfree(p_priv);
 
 	return -ENOMEM;


