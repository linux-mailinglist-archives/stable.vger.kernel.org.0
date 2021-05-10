Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A04378683
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhEJLIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233266AbhEJK6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3E076196A;
        Mon, 10 May 2021 10:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643952;
        bh=MUVpAbIDpHgX4tBtKUQo8bni9gOy8VJ4MiQLiHFiun0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFMKVGKszi7RsuGHXJ/BznVieat/82+mT6zE4yVWJHHL13mWpVCxlxFSjuQU91ElL
         pOn5MkcX3HfxYGvLZiQ31vCwBuHuHQdLcd/EGNz1e9zI+sjx104aIJIJhmLe1MILzB
         pKq16BkehN50IwJB3J/XKpYqRTfvyNgGvOIqN7os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3c2be7424cea3b932b0e@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 210/342] media: dvb-usb: fix memory leak in dvb_usb_adapter_init
Date:   Mon, 10 May 2021 12:20:00 +0200
Message-Id: <20210510102017.026476287@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit b7cd0da982e3043f2eec7235ac5530cb18d6af1d ]

syzbot reported memory leak in dvb-usb. The problem was
in invalid error handling in dvb_usb_adapter_init().

for (n = 0; n < d->props.num_adapters; n++) {
....
	if ((ret = dvb_usb_adapter_stream_init(adap)) ||
		(ret = dvb_usb_adapter_dvb_init(adap, adapter_nrs)) ||
		(ret = dvb_usb_adapter_frontend_init(adap))) {
		return ret;
	}
...
	d->num_adapters_initialized++;
...
}

In case of error in dvb_usb_adapter_dvb_init() or
dvb_usb_adapter_dvb_init() d->num_adapters_initialized won't be
incremented, but dvb_usb_adapter_exit() relies on it:

	for (n = 0; n < d->num_adapters_initialized; n++)

So, allocated objects won't be freed.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reported-by: syzbot+3c2be7424cea3b932b0e@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dvb-usb-init.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index c1a7634e27b4..adc8b287326b 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -79,11 +79,17 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 			}
 		}
 
-		if ((ret = dvb_usb_adapter_stream_init(adap)) ||
-			(ret = dvb_usb_adapter_dvb_init(adap, adapter_nrs)) ||
-			(ret = dvb_usb_adapter_frontend_init(adap))) {
+		ret = dvb_usb_adapter_stream_init(adap);
+		if (ret)
 			return ret;
-		}
+
+		ret = dvb_usb_adapter_dvb_init(adap, adapter_nrs);
+		if (ret)
+			goto dvb_init_err;
+
+		ret = dvb_usb_adapter_frontend_init(adap);
+		if (ret)
+			goto frontend_init_err;
 
 		/* use exclusive FE lock if there is multiple shared FEs */
 		if (adap->fe_adap[1].fe)
@@ -103,6 +109,12 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 	}
 
 	return 0;
+
+frontend_init_err:
+	dvb_usb_adapter_dvb_exit(adap);
+dvb_init_err:
+	dvb_usb_adapter_stream_exit(adap);
+	return ret;
 }
 
 static int dvb_usb_adapter_exit(struct dvb_usb_device *d)
-- 
2.30.2



