Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3D338A5F0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbhETKVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236440AbhETKTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:19:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5A89619C3;
        Thu, 20 May 2021 09:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504036;
        bh=8PUeSK6m8NDiKRs+ov5NRIEpA7ooQ2i5cHoY4/B8N8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nsx17ikeEfWWb0DWhKgCve0uaF70XiKWcP+wh9LiG7etgZJMX9BEoaDu/xKj8qy4v
         QD5RF5JOF5WxboHW8y3bSAQEj6BQVAIw71XENud5JJ5fnfccJSKsqlU1BMZIOIcwdK
         o0Jx2bdZjz41iRibQ8xMLDDRYGuryQJkIK0Fx5SA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3c2be7424cea3b932b0e@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 066/323] media: dvb-usb: fix memory leak in dvb_usb_adapter_init
Date:   Thu, 20 May 2021 11:19:18 +0200
Message-Id: <20210520092122.365609333@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index b3413404f91a..690c1e06fbfa 100644
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



