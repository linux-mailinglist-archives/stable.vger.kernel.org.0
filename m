Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5085347AD67
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbhLTOvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41038 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbhLTOuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD44261183;
        Mon, 20 Dec 2021 14:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DC2C36AE7;
        Mon, 20 Dec 2021 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011803;
        bh=LFILw5vlI4Wqi0vs4IwrEcJek2WmBuSsaQzjVKp0JwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkARm5Q8/uBQAfEH5Pl0V66JBDdBSdOd0s6Gin0l97ocExBBU51JB82ghmNCP420f
         jdjdmYW8O37N/I/rjgabAEG2tpgwIF6EVKDyt/i9gKlrRZawBWY4XYD7WsSwbZuL4l
         GAIVYtgX7e63wEaCwRldFacp/eL3aO6d5KyuI3TU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 78/99] iocost: Fix divide-by-zero on donation from low hweight cgroup
Date:   Mon, 20 Dec 2021 15:34:51 +0100
Message-Id: <20211220143032.025514966@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit edaa26334c117a584add6053f48d63a988d25a6e upstream.

The donation calculation logic assumes that the donor has non-zero
after-donation hweight, so the lowest active hweight a donating cgroup can
have is 2 so that it can donate 1 while keeping the other 1 for itself.
Earlier, we only donated from cgroups with sizable surpluses so this
condition was always true. However, with the precise donation algorithm
implemented, f1de2439ec43 ("blk-iocost: revamp donation amount
determination") made the donation amount calculation exact enabling even low
hweight cgroups to donate.

This means that in rare occasions, a cgroup with active hweight of 1 can
enter donation calculation triggering the following warning and then a
divide-by-zero oops.

 WARNING: CPU: 4 PID: 0 at block/blk-iocost.c:1928 transfer_surpluses.cold+0x0/0x53 [884/94867]
 ...
 RIP: 0010:transfer_surpluses.cold+0x0/0x53
 Code: 92 ff 48 c7 c7 28 d1 ab b5 65 48 8b 34 25 00 ae 01 00 48 81 c6 90 06 00 00 e8 8b 3f fe ff 48 c7 c0 ea ff ff ff e9 95 ff 92 ff <0f> 0b 48 c7 c7 30 da ab b5 e8 71 3f fe ff 4c 89 e8 4d 85 ed 74 0
4
 ...
 Call Trace:
  <IRQ>
  ioc_timer_fn+0x1043/0x1390
  call_timer_fn+0xa1/0x2c0
  __run_timers.part.0+0x1ec/0x2e0
  run_timer_softirq+0x35/0x70
 ...
 iocg: invalid donation weights in /a/b: active=1 donating=1 after=0

Fix it by excluding cgroups w/ active hweight < 2 from donating. Excluding
these extreme low hweight donations shouldn't affect work conservation in
any meaningful way.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: f1de2439ec43 ("blk-iocost: revamp donation amount determination")
Cc: stable@vger.kernel.org # v5.10+
Link: https://lore.kernel.org/r/Ybfh86iSvpWKxhVM@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-iocost.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2246,7 +2246,14 @@ static void ioc_timer_fn(struct timer_li
 			hwm = current_hweight_max(iocg);
 			new_hwi = hweight_after_donation(iocg, old_hwi, hwm,
 							 usage, &now);
-			if (new_hwi < hwm) {
+			/*
+			 * Donation calculation assumes hweight_after_donation
+			 * to be positive, a condition that a donor w/ hwa < 2
+			 * can't meet. Don't bother with donation if hwa is
+			 * below 2. It's not gonna make a meaningful difference
+			 * anyway.
+			 */
+			if (new_hwi < hwm && hwa >= 2) {
 				iocg->hweight_donating = hwa;
 				iocg->hweight_after_donation = new_hwi;
 				list_add(&iocg->surplus_list, &surpluses);


