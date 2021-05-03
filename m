Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD87371CFE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhECQ5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235025AbhECQzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C2A761426;
        Mon,  3 May 2021 16:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060162;
        bh=8PUeSK6m8NDiKRs+ov5NRIEpA7ooQ2i5cHoY4/B8N8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIb8DxlQw/d9gFeuqRC0OzdGqYSnjf78uqAmHpDwV39omsshgf1i/MlHxQTDvCUtB
         BUASt1S/cfH/cUVOCmZY0MhkPnbkIae28TcxBoth++9WdO5pcFg8hTUb4oAf95Wqqp
         d9ZQ6WyhvxdhYS0m1P9j6AxR2hIW4CDT5TVci21ApqEpiGdCg+2F10JuhEBRsIjcRB
         hCTbrn3S7fnA2WC1DYhbZc3jAtAsj7bIvXBFcjRiTyiMQLmC8Ft1/ZPO/Kc6ROs9qT
         eTGCLBL/dfB6TD2FKbYU2SexMPMRGqTJbSAPuP3tQDQc9VBXLVEcYAiduYL32U133O
         RdwoHkU5PyjPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3c2be7424cea3b932b0e@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 25/31] media: dvb-usb: fix memory leak in dvb_usb_adapter_init
Date:   Mon,  3 May 2021 12:41:58 -0400
Message-Id: <20210503164204.2854178-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
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

