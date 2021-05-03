Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE655371C42
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhECQvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234542AbhECQu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC6C761864;
        Mon,  3 May 2021 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060048;
        bh=JpI3UmnjT4A4j4147ZoJCE3abD9eyglGEh5/6oKPLtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbDC02wBMw4ng8aHrHxvltjvrKVRnJPJVjcWD9djuZxxfbXBAR1Xv8U0pUF0BoZiM
         Up7oiySbaH2Jdp3dTzta1FP7T6HgvfxsKqit0lXIZ9hyh58iiSE/8jE/oc8NpVFmA0
         +v105amQuv2YgqsuYHoEHfyM+ES/Hy/ULRgfNXYXQ9xq4B4otdFbQXFXiPf+V81Qwj
         +JdsovhPbh25lH+Z24sTUMOpi/qF9UuYGFnteX30XsxO+2kRgqe73umcGor5PLSGt6
         tsuXLMjF/T6hjSCnUF+fbKKBcMLNBGINWQX92wXZz/Wj35/t5o23X+8tNe677gZpSA
         qb8U/LL4E+vRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3c2be7424cea3b932b0e@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 44/57] media: dvb-usb: fix memory leak in dvb_usb_adapter_init
Date:   Mon,  3 May 2021 12:39:28 -0400
Message-Id: <20210503163941.2853291-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index 16a0b4a359ea..7c32c7b96520 100644
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

