Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE5B288342
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgJIHJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:09:13 -0400
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:53478 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgJIHJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:09:13 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 09978vjU000306; Fri, 9 Oct 2020 16:08:58 +0900
X-Iguazu-Qid: 34trqomzZ2LbmvKLKe
X-Iguazu-QSIG: v=2; s=0; t=1602227337; q=34trqomzZ2LbmvKLKe; m=YIB3bRt2Idgwq6Z1XDejuXXAXoj1HgU7h00ulW8wQjk=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id 09978uia028828;
        Fri, 9 Oct 2020 16:08:56 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 09978uAp005477;
        Fri, 9 Oct 2020 16:08:56 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 09978tto027250;
        Fri, 9 Oct 2020 16:08:56 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+805f5f6ae37411f15b64@syzkaller.appspotmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        stable <stable@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4, 4.9, 4.19, 4.14 and 5.4] driver core: Fix probe_count imbalance in really_probe()
Date:   Fri,  9 Oct 2020 16:08:53 +0900
X-TSB-HOP: ON
Message-Id: <20201009070853.550096-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit b292b50b0efcc7095d8bf15505fba6909bb35dce upstream.

syzbot is reporting hung task in wait_for_device_probe() [1]. At least,
we always need to decrement probe_count if we incremented probe_count in
really_probe().

However, since I can't find "Resources present before probing" message in
the console log, both "this message simply flowed off" and "syzbot is not
hitting this path" will be possible. Therefore, while we are at it, let's
also prepare for concurrent wait_for_device_probe() calls by replacing
wake_up() with wake_up_all().

[1] https://syzkaller.appspot.com/bug?id=25c833f1983c9c1d512f4ff860dd0d7f5a2e2c0f

Reported-by: syzbot <syzbot+805f5f6ae37411f15b64@syzkaller.appspotmail.com>
Fixes: 7c35e699c88bd607 ("driver core: Print device when resources present in really_probe()")
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20200713021254.3444-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[iwamatsu: Drop patch for deferred_probe_timeout_work_func()]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/base/dd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0047bbdd43c0f0..b3c569412f4e2e 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -472,7 +472,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
 	if (!list_empty(&dev->devres_head)) {
 		dev_crit(dev, "Resources present before probing\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto done;
 	}

 re_probe:
@@ -579,7 +580,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	ret = 0;
 done:
 	atomic_dec(&probe_count);
-	wake_up(&probe_waitqueue);
+	wake_up_all(&probe_waitqueue);
 	return ret;
 }

--
2.28.0

