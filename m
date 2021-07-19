Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7293CDCB3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhGSOxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238702AbhGSOt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0788B60FE7;
        Mon, 19 Jul 2021 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708635;
        bh=CwCNt3yYNT3YccVLM099YhA2gJ/GSS2zbts+Qyv2fxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tr0IYHsjgXad9CyFjpsMBPxEPIZ+C1/NsS8Fa/LhRGwZx41bg5RwPk2OyYVv4yaQe
         b+WjOdaPt9Jg483z8buC39+NzTzBX1ZWGDOG5ZWUcl8N03/qvdcra2Uvmo5fEvM6bh
         Jzo1smvbsOUemYlM4Eiyqh78OcxYT8xxdiUNGW0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e1de8986786b3722050e@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/421] media: dvd_usb: memory leak in cinergyt2_fe_attach
Date:   Mon, 19 Jul 2021 16:47:58 +0200
Message-Id: <20210719144948.500021692@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 9ad1efee086e0e913914fa2b2173efb830bad68c ]

When the driver fails to talk with the hardware with dvb_usb_generic_rw,
it will return an error to dvb_usb_adapter_frontend_init. However, the
driver forgets to free the resource (e.g., struct cinergyt2_fe_state),
which leads to a memory leak.

Fix this by freeing struct cinergyt2_fe_state when dvb_usb_generic_rw
fails in cinergyt2_frontend_attach.

backtrace:
  [<0000000056e17b1a>] kmalloc include/linux/slab.h:552 [inline]
  [<0000000056e17b1a>] kzalloc include/linux/slab.h:682 [inline]
  [<0000000056e17b1a>] cinergyt2_fe_attach+0x21/0x80 drivers/media/usb/dvb-usb/cinergyT2-fe.c:271
  [<00000000ae0b1711>] cinergyt2_frontend_attach+0x21/0x70 drivers/media/usb/dvb-usb/cinergyT2-core.c:74
  [<00000000d0254861>] dvb_usb_adapter_frontend_init+0x11b/0x1b0 drivers/media/usb/dvb-usb/dvb-usb-dvb.c:290
  [<0000000002e08ac6>] dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:84 [inline]
  [<0000000002e08ac6>] dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:173 [inline]
  [<0000000002e08ac6>] dvb_usb_device_init.cold+0x4d0/0x6ae drivers/media/usb/dvb-usb/dvb-usb-init.c:287

Reported-by: syzbot+e1de8986786b3722050e@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/cinergyT2-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 6131aa7914a9..fb59dda7547a 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -88,6 +88,8 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 
 	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
 	if (ret < 0) {
+		if (adap->fe_adap[0].fe)
+			adap->fe_adap[0].fe->ops.release(adap->fe_adap[0].fe);
 		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep state info\n");
 	}
 	mutex_unlock(&d->data_mutex);
-- 
2.30.2



