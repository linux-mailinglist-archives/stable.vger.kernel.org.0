Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF40A51A6F5
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354483AbiEDRAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354605AbiEDQ6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:58:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2F32314C;
        Wed,  4 May 2022 09:50:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E02A617BD;
        Wed,  4 May 2022 16:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B74C385A4;
        Wed,  4 May 2022 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683046;
        bh=humWjBXg5Qfpu/Xg7rjSgbiOYu3/AmTCV30mt2Nvlxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NcIegnK9TrAg7GTU+RKDTQ5uk1aG4DzrHyAEJxQrcAfs5kjl9zUwej3cYwX6iDzX
         JxFfYmmtfV7nfW/ZCLpW610x9J4BhYsYmxQoRoycav69haRtwIBnFnxyQkr5MiZqjo
         dGxyOljmE8AzZj549JOEdjE5KfnHcwH+AnCS1I98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Rik van Riel <riel@surriel.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 037/129] iocost: dont reset the inuse weight of under-weighted debtors
Date:   Wed,  4 May 2022 18:43:49 +0200
Message-Id: <20220504153024.146447116@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 8c936f9ea11ec4e35e288810a7503b5c841a355f upstream.

When an iocg is in debt, its inuse weight is owned by debt handling and
should stay at 1. This invariant was broken when determining the amount of
surpluses at the beginning of donation calculation - when an iocg's
hierarchical weight is too low, the iocg is excluded from donation
calculation and its inuse is reset to its active regardless of its
indebtedness, triggering warnings like the following:

 WARNING: CPU: 5 PID: 0 at block/blk-iocost.c:1416 iocg_kick_waitq+0x392/0x3a0
 ...
 RIP: 0010:iocg_kick_waitq+0x392/0x3a0
 Code: 00 00 be ff ff ff ff 48 89 4d a8 e8 98 b2 70 00 48 8b 4d a8 85 c0 0f 85 4a fe ff ff 0f 0b e9 43 fe ff ff 0f 0b e9 4d fe ff ff <0f> 0b e9 50 fe ff ff e8 a2 ae 70 00 66 90 0f 1f 44 00 00 55 48 89
 RSP: 0018:ffffc90000200d08 EFLAGS: 00010016
 ...
  <IRQ>
  ioc_timer_fn+0x2e0/0x1470
  call_timer_fn+0xa1/0x2c0
 ...

As this happens only when an iocg's hierarchical weight is negligible, its
impact likely is limited to triggering the warnings. Fix it by skipping
resetting inuse of under-weighted debtors.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Rik van Riel <riel@surriel.com>
Fixes: c421a3eb2e27 ("blk-iocost: revamp debt handling")
Cc: stable@vger.kernel.org # v5.10+
Link: https://lore.kernel.org/r/YmjODd4aif9BzFuO@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-iocost.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2257,7 +2257,17 @@ static void ioc_timer_fn(struct timer_li
 				iocg->hweight_donating = hwa;
 				iocg->hweight_after_donation = new_hwi;
 				list_add(&iocg->surplus_list, &surpluses);
-			} else {
+			} else if (!iocg->abs_vdebt) {
+				/*
+				 * @iocg doesn't have enough to donate. Reset
+				 * its inuse to active.
+				 *
+				 * Don't reset debtors as their inuse's are
+				 * owned by debt handling. This shouldn't affect
+				 * donation calculuation in any meaningful way
+				 * as @iocg doesn't have a meaningful amount of
+				 * share anyway.
+				 */
 				TRACE_IOCG_PATH(inuse_shortage, iocg, &now,
 						iocg->inuse, iocg->active,
 						iocg->hweight_inuse, new_hwi);


