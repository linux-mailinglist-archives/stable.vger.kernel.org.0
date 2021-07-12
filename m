Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E21C3C4C62
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbhGLHDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242499AbhGLHDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D98F610FA;
        Mon, 12 Jul 2021 07:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073217;
        bh=lJ3hh8R41P8DiijbBEOO6KYz41OVlnc6F8l5msauMoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG+8Gw+J/00/7kjwC97V4ulYKoO4Al9+7SP2KtuRRsn6+AyvpZpYTfbA9RLqbtDf5
         0V7/kwIgzRkpn3S0UtH31XJboGYEvaKolo8c7WFpEs3X7jx1NQGYWm61Qtcu187ggl
         nf/3+wjwKiAX5aXGdJEcMz2vcw6e2xVFtNGBXDDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e1de8986786b3722050e@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 164/700] media: dvd_usb: memory leak in cinergyt2_fe_attach
Date:   Mon, 12 Jul 2021 08:04:07 +0200
Message-Id: <20210712060948.865446933@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 969a7ec71dff..4116ba5c45fc 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -78,6 +78,8 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 
 	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
 	if (ret < 0) {
+		if (adap->fe_adap[0].fe)
+			adap->fe_adap[0].fe->ops.release(adap->fe_adap[0].fe);
 		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep state info\n");
 	}
 	mutex_unlock(&d->data_mutex);
-- 
2.30.2



