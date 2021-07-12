Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192D83C4450
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhGLGSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232908AbhGLGSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:18:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A65161042;
        Mon, 12 Jul 2021 06:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070529;
        bh=ydy7+xysfvZ1qXCbIt/gjvZUlYRccPprm0xqIYsuhis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1xqtiOealRlqXCafuNelmrGKV03TUXYMk9ROdCxJ1ufEjKLlJbWZj5dU0ITHb6et
         pKbSC2pIu/YTjYkDxzw1EZ3EyqL1zRDTvQOv3hYocjqwqMDXC3ofYc1ID5LqkZeoTq
         +V8FOKfd2RMWAOz5LJlZ+Y0sObTPOfnDYx6EI7kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7336195c02c1bd2f64e1@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 009/348] media: dvb-usb: fix wrong definition
Date:   Mon, 12 Jul 2021 08:06:33 +0200
Message-Id: <20210712060701.344347339@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit c680ed46e418e9c785d76cf44eb33bfd1e8cf3f6 upstream.

syzbot reported WARNING in vmalloc. The problem
was in zero size passed to vmalloc.

The root case was in wrong cxusb_bluebird_lgz201_properties
definition. adapter array has only 1 entry, but num_adapters was
2.

Call Trace:
 __vmalloc_node mm/vmalloc.c:2963 [inline]
 vmalloc+0x67/0x80 mm/vmalloc.c:2996
 dvb_dmx_init+0xe4/0xb90 drivers/media/dvb-core/dvb_demux.c:1251
 dvb_usb_adapter_dvb_init+0x564/0x860 drivers/media/usb/dvb-usb/dvb-usb-dvb.c:184
 dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:86 [inline]
 dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:184 [inline]
 dvb_usb_device_init.cold+0xc94/0x146e drivers/media/usb/dvb-usb/dvb-usb-init.c:308
 cxusb_probe+0x159/0x5e0 drivers/media/usb/dvb-usb/cxusb.c:1634

Fixes: 4d43e13f723e ("V4L/DVB (4643): Multi-input patch for DVB-USB device")
Cc: stable@vger.kernel.org
Reported-by: syzbot+7336195c02c1bd2f64e1@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/cxusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1950,7 +1950,7 @@ static struct dvb_usb_device_properties
 
 	.size_of_priv     = sizeof(struct cxusb_state),
 
-	.num_adapters = 2,
+	.num_adapters = 1,
 	.adapter = {
 		{
 		.num_frontends = 1,


