Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A3A3BB062
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhGDXIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhGDXIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2BEC61958;
        Sun,  4 Jul 2021 23:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439929;
        bh=lJ3hh8R41P8DiijbBEOO6KYz41OVlnc6F8l5msauMoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxUxEWfHaNARcDRTpbbju8O7cUDJRpg8+zzWq3KLLhDoMwQcrTd7CLJgV+7HIu4io
         aUKQWIVC7FX5qZPFgDxwy3+CxqSXtDj7/cnSYNe+4AKJb3oX/f2rrPpYG4MdEQpuQB
         vE8X9cF29iyQaTPa30AHC4v7PHKTkpEOYKQIeeAULqRSZjZCUZc9PKRdcFOaXtB8vu
         jlrus60jcdpv0B9KD79Llmbb/ZYh/iLPfXzcVKqh7JhBJeyiyvHWRPJxGcsdA5T5wy
         lQ2dbvwibXqNxl/Yi+bu5GltZSSdcOWSNgrLt7LhtalHnlXsNPCOSM4v49Ck+mlhQt
         f3QDkQo2RbjZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+e1de8986786b3722050e@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 50/85] media: dvd_usb: memory leak in cinergyt2_fe_attach
Date:   Sun,  4 Jul 2021 19:03:45 -0400
Message-Id: <20210704230420.1488358-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

