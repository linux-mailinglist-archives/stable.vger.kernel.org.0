Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0880F2018B2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404256AbgFSQv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387822AbgFSOiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:38:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCE94208B8;
        Fri, 19 Jun 2020 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577483;
        bh=kq7xnAF9snUBez46/Ih5rjBI7O4wxsDS2jImrawFsYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSbJE0MPP+gKFpl+sCud9gehkG+YFXuQFLIckb+OSzxgt+UGvkdWT2+QEKU8FfCke
         ylYgqCnhrpFc+1034p37mPLl7YEAQbr11yzumk0RB96/gaXvVyiwL1ya6uDzvBhTcC
         FCfdXoO3YjJnQFibb05SzrU1KobIRVIHzCCdQME4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com
Subject: [PATCH 4.4 039/101] ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
Date:   Fri, 19 Jun 2020 16:32:28 +0200
Message-Id: <20200619141616.165285038@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit e4ff08a4d727146bb6717a39a8d399d834654345 upstream.

Write out of slab bounds. We should check epid.

The case reported by syzbot:
https://lore.kernel.org/linux-usb/0000000000006ac55b05a1c05d72@google.com
BUG: KASAN: use-after-free in htc_process_conn_rsp
drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
BUG: KASAN: use-after-free in ath9k_htc_rx_msg+0xa25/0xaf0
drivers/net/wireless/ath/ath9k/htc_hst.c:443
Write of size 2 at addr ffff8881cea291f0 by task swapper/1/0

Call Trace:
 htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131
[inline]
ath9k_htc_rx_msg+0xa25/0xaf0
drivers/net/wireless/ath/ath9k/htc_hst.c:443
ath9k_hif_usb_reg_in_cb+0x1ba/0x630
drivers/net/wireless/ath/ath9k/hif_usb.c:718
__usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786

Reported-and-tested-by: syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200404041838.10426-4-hqjagain@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -114,6 +114,9 @@ static void htc_process_conn_rsp(struct
 
 	if (svc_rspmsg->status == HTC_SERVICE_SUCCESS) {
 		epid = svc_rspmsg->endpoint_id;
+		if (epid < 0 || epid >= ENDPOINT_MAX)
+			return;
+
 		service_id = be16_to_cpu(svc_rspmsg->service_id);
 		max_msglen = be16_to_cpu(svc_rspmsg->max_msg_len);
 		endpoint = &target->endpoint[epid];


