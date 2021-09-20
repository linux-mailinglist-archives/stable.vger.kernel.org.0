Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1413A411D27
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348075AbhITRQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347689AbhITROd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C1FC613AB;
        Mon, 20 Sep 2021 16:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157098;
        bh=V1J8g2vImMD8hB2+/OrAOmcaDISvKluNEVVVP7io990=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOD1bltageop9+ACuKK1gRniReXDj2iyHl0KQZctyCsA6wPhGT0DV7ggEk62wDKTc
         RHwGtRdZhgDviJuii0ktvs2U/2Uav3js05nXmRDp/XAJJua7ETNYjzHQeywxAdL1vD
         ln/VKBoTn84U01AezTIMe+Yyb83c43F8nDZdcjwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 053/217] media: dvb-usb: fix uninit-value in vp702x_read_mac_addr
Date:   Mon, 20 Sep 2021 18:41:14 +0200
Message-Id: <20210920163926.421631550@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 797c061ad715a9a1480eb73f44b6939fbe3209ed ]

If vp702x_usb_in_op fails, the mac address is not initialized.
And vp702x_read_mac_addr does not handle this failure, which leads to
the uninit-value in dvb_usb_adapter_dvb_init.

Fix this by handling the failure of vp702x_usb_in_op.

Fixes: 786baecfe78f ("[media] dvb-usb: move it to drivers/media/usb/dvb-usb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/vp702x.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-usb/vp702x.c
index 40de33de90a7..5c3b0a7ca27e 100644
--- a/drivers/media/usb/dvb-usb/vp702x.c
+++ b/drivers/media/usb/dvb-usb/vp702x.c
@@ -294,16 +294,22 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
 {
 	u8 i, *buf;
+	int ret;
 	struct vp702x_device_state *st = d->priv;
 
 	mutex_lock(&st->buf_mutex);
 	buf = st->buf;
-	for (i = 6; i < 12; i++)
-		vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1, &buf[i - 6], 1);
+	for (i = 6; i < 12; i++) {
+		ret = vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1,
+				       &buf[i - 6], 1);
+		if (ret < 0)
+			goto err;
+	}
 
 	memcpy(mac, buf, 6);
+err:
 	mutex_unlock(&st->buf_mutex);
-	return 0;
+	return ret;
 }
 
 static int vp702x_frontend_attach(struct dvb_usb_adapter *adap)
-- 
2.30.2



