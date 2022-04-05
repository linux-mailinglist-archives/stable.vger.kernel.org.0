Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E8D4F2C44
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240734AbiDEJfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343504AbiDEI44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:56:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE70C1CFF2;
        Tue,  5 Apr 2022 01:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 735ED6117A;
        Tue,  5 Apr 2022 08:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854B8C385A0;
        Tue,  5 Apr 2022 08:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148770;
        bh=N+zWu7AI5IWaUS3GUluxulWeUVNUFJ71l/5vn5pCO2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kV/hm8tJiGkaHbKELaJfUwwlbmW+h/ffuyu2ib1gXXwRImoo6CV0gSpBjZjxukfVQ
         IjFEu7C5HCyGjOu0Qh1OOftCh9q4ZPhu2iAYNEdkaszt4YfA7Cm9Pnq5XKE9Usnlpk
         YsmbvEe7lVrJZ1YvIjrhskO8bD7MQ0pUX/3tIR+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0468/1017] ptp: unregister virtual clocks when unregistering physical clock.
Date:   Tue,  5 Apr 2022 09:23:01 +0200
Message-Id: <20220405070408.190498306@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit bfcbb76b0f595ea9ede9f7a218086fef85242f10 ]

When unregistering a physical clock which has some virtual clocks,
unregister the virtual clocks with it.

This fixes the following oops, which can be triggered by unloading
a driver providing a PTP clock when it has enabled virtual clocks:

BUG: unable to handle page fault for address: ffffffffc04fc4d8
Oops: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:ptp_vclock_read+0x31/0xb0
Call Trace:
 timecounter_read+0xf/0x50
 ptp_vclock_refresh+0x2c/0x50
 ? ptp_clock_release+0x40/0x40
 ptp_aux_kworker+0x17/0x30
 kthread_worker_fn+0x9b/0x240
 ? kthread_should_park+0x30/0x30
 kthread+0xe2/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 0e4bc8b9329d..b6f2cfd15dd2 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -317,11 +317,18 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 }
 EXPORT_SYMBOL(ptp_clock_register);
 
+static int unregister_vclock(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+
+	ptp_vclock_unregister(info_to_vclock(ptp->info));
+	return 0;
+}
+
 int ptp_clock_unregister(struct ptp_clock *ptp)
 {
 	if (ptp_vclock_in_use(ptp)) {
-		pr_err("ptp: virtual clock in use\n");
-		return -EBUSY;
+		device_for_each_child(&ptp->dev, NULL, unregister_vclock);
 	}
 
 	ptp->defunct = 1;
-- 
2.34.1



