Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCE643A275
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhJYTtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236468AbhJYToo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:44:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 692FE60C4B;
        Mon, 25 Oct 2021 19:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190707;
        bh=TBZMlVIOZR9UVFUNlLA43/VYaNzJPp0tk0nGcSn9+qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ch3pjBVHaO7lAtZHucPcKZEUo7R7lT5WHhSzVPDizCYuxUkfDthFFK6elm7yTSmSh
         9dTkX7/XWQFywoQtcwiumITswX4hLWixp1dQw8TfZ/gU9qr5hCDptqPnNDhhWfFFaW
         2baNqdURDmfSgJ9dx2Cn02TrWmFjwk0IJYFsvdEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 051/169] ptp: Fix possible memory leak in ptp_clock_register()
Date:   Mon, 25 Oct 2021 21:13:52 +0200
Message-Id: <20211025191024.165411968@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4225fea1cb28370086e17e82c0f69bec2779dca0 ]

I got memory leak as follows when doing fault injection test:

unreferenced object 0xffff88800906c618 (size 8):
  comm "i2c-idt82p33931", pid 4421, jiffies 4294948083 (age 13.188s)
  hex dump (first 8 bytes):
    70 74 70 30 00 00 00 00                          ptp0....
  backtrace:
    [<00000000312ed458>] __kmalloc_track_caller+0x19f/0x3a0
    [<0000000079f6e2ff>] kvasprintf+0xb5/0x150
    [<0000000026aae54f>] kvasprintf_const+0x60/0x190
    [<00000000f323a5f7>] kobject_set_name_vargs+0x56/0x150
    [<000000004e35abdd>] dev_set_name+0xc0/0x100
    [<00000000f20cfe25>] ptp_clock_register+0x9f4/0xd30 [ptp]
    [<000000008bb9f0de>] idt82p33_probe.cold+0x8b6/0x1561 [ptp_idt82p33]

When posix_clock_register() returns an error, the name allocated
in dev_set_name() will be leaked, the put_device() should be used
to give up the device reference, then the name will be freed in
kobject_cleanup() and other memory will be freed in ptp_clock_release().

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and cdev")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 4dfc52e06704..7fd02aabd79a 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -283,15 +283,22 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	/* Create a posix clock and link it to the device. */
 	err = posix_clock_register(&ptp->clock, &ptp->dev);
 	if (err) {
+	        if (ptp->pps_source)
+	                pps_unregister_source(ptp->pps_source);
+
+		kfree(ptp->vclock_index);
+
+		if (ptp->kworker)
+	                kthread_destroy_worker(ptp->kworker);
+
+		put_device(&ptp->dev);
+
 		pr_err("failed to create posix clock\n");
-		goto no_clock;
+		return ERR_PTR(err);
 	}
 
 	return ptp;
 
-no_clock:
-	if (ptp->pps_source)
-		pps_unregister_source(ptp->pps_source);
 no_pps:
 	ptp_cleanup_pin_groups(ptp);
 no_pin_groups:
-- 
2.33.0



