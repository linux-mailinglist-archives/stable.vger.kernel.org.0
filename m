Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA82D371D97
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhECRBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 13:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232514AbhECQ5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53AB8601FC;
        Mon,  3 May 2021 16:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060226;
        bh=E/eIhmQ2iYDShdcXVmEy/i6ztpfOYBecc292FLsv814=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4hUJ7sSI7tAExaxTB9BNTwsNB7TLfc16cAS0a34gQ7ZkhcUKVB4bFG5y40WmwHqr
         fRdsG7luPBd1GsqiwcCYEWk2CgqEUs0zs1VsuFiH3mp6a2E6101E25CrQw9cw7XFK+
         Ikt52mkdThyKhfuuLDDSWKKKH9gjavSERDKVsrGuRw55PFVIxVeOlFROVX3f0shtOq
         lkw9pfnWRzIlXatiuxdeZ2801rtQixNVfMuV5NIQKPOeaxkvcnyXacZP0GgdaLo9P5
         5ck2UdL78byRynr0vM1XGia8C+pJ6rxlQLDTZurCryFVtz2ebahrltYobzGdl2WY1v
         QRbX0v7mTwa9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3c2be7424cea3b932b0e@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/16] media: dvb-usb: fix memory leak in dvb_usb_adapter_init
Date:   Mon,  3 May 2021 12:43:24 -0400
Message-Id: <20210503164329.2854739-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 97a89ef7e4c1..151212168c9f 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -82,11 +82,17 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
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
@@ -106,6 +112,12 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
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

