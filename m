Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254753A62D3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhFNLFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234685AbhFNLCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB32F61878;
        Mon, 14 Jun 2021 10:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667431;
        bh=J5V1QVOgXXFiFt0IqM+CYK36Ta3RwIHNPWq3G/S5GvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwL+H3UpeTGVHRcFAuFbjhjiLmwADwz678Rd/V8xNd1lIZOHmWi9AQ+RACARLgsKV
         FrZJSAfoQ9MRjGmY+bbxzYaZAteFUDq2qSfLQX5vgrukwE4E5iaj3w3KrP+BqYEUeI
         Pw9tLSk3pgoOTujin7kQwrvH5Mu1QHbc0/hYfM78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brooke Basile <brookebasile@gmail.com>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH 5.10 068/131] usb: f_ncm: only first packet of aggregate needs to start timer
Date:   Mon, 14 Jun 2021 12:27:09 +0200
Message-Id: <20210614102655.341281623@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

commit 1958ff5ad2d4908b44a72bcf564dfe67c981e7fe upstream.

The reasoning for this change is that if we already had
a packet pending, then we also already had a pending timer,
and as such there is no need to reschedule it.

This also prevents packets getting delayed 60 ms worst case
under a tiny packet every 290us transmit load, by keeping the
timeout always relative to the first queued up packet.
(300us delay * 16KB max aggregation / 80 byte packet =~ 60 ms)

As such the first packet is now at most delayed by 300us.

Under low transmit load, this will simply result in us sending
a shorter aggregate, as originally intended.

This patch has the benefit of greatly reducing (by ~10 factor
with 1500 byte frames aggregated into 16 kiB) the number of
(potentially pretty costly) updates to the hrtimer.

Cc: Brooke Basile <brookebasile@gmail.com>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20210608085438.813960-1-zenczykowski@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1101,11 +1101,11 @@ static struct sk_buff *ncm_wrap_ntb(stru
 			ncm->ndp_dgram_count = 1;
 
 			/* Note: we skip opts->next_ndp_index */
-		}
 
-		/* Delay the timer. */
-		hrtimer_start(&ncm->task_timer, TX_TIMEOUT_NSECS,
-			      HRTIMER_MODE_REL_SOFT);
+			/* Start the timer. */
+			hrtimer_start(&ncm->task_timer, TX_TIMEOUT_NSECS,
+				      HRTIMER_MODE_REL_SOFT);
+		}
 
 		/* Add the datagram position entries */
 		ntb_ndp = skb_put_zero(ncm->skb_tx_ndp, dgram_idx_len);


