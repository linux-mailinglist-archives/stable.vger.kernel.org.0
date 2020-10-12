Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776A228BA5C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbgJLOIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgJLNdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:33:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B896620678;
        Mon, 12 Oct 2020 13:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509605;
        bh=aIYYaIhEzQZRF+zi3njBCJesd8nzD6h8LV9Bb70iIHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDYjfhWK3pSHyfbLiuhRvRdbTjk6K3H5HKaSOMer/Vt2mNTvVyhK/0k331JlcYBPW
         1Ct/rmboffYJIQGZgKzCtE3ONwRqSL4ERoYB55lQ7dTKHj3+DFyPEM5f4TVMiZtjcT
         NFhEOJfP2JQK4LvJBmHZ9+mYbZ2HP/y0oNIBScrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+805f5f6ae37411f15b64@syzkaller.appspotmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        stable <stable@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 25/39] driver core: Fix probe_count imbalance in really_probe()
Date:   Mon, 12 Oct 2020 15:26:55 +0200
Message-Id: <20201012132629.340739665@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
[iwamatsu: Drop patch for deferred_probe_timeout_work_func()]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -285,7 +285,8 @@ static int really_probe(struct device *d
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
 	if (!list_empty(&dev->devres_head)) {
 		dev_crit(dev, "Resources present before probing\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto done;
 	}
 
 	dev->driver = drv;
@@ -363,7 +364,7 @@ probe_failed:
 	ret = 0;
 done:
 	atomic_dec(&probe_count);
-	wake_up(&probe_waitqueue);
+	wake_up_all(&probe_waitqueue);
 	return ret;
 }
 


