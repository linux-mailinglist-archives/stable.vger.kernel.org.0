Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C2656F9DA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiGKJJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiGKJJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:09:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465FD22BF8;
        Mon, 11 Jul 2022 02:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4635F611A5;
        Mon, 11 Jul 2022 09:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558A8C34115;
        Mon, 11 Jul 2022 09:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530487;
        bh=87vGQEQfDaYwPc75I7+wx1o+VbDJU1V1K/ZgNF3NO80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6Z+1T0C8JI+y3FktPhMVdg6nYFGuilJn+3hua4Ez+u8CxEvK5+qU6xGDm5sgImto
         pMI6yknRuqbWx/TvdiOw6mUNznnNaZS6UWwIdsGXQglV12s9mQ0cnKttKIJN45kdfx
         bdoIcOJm0rj0HB19ci2lzartX+i3hwFzY3yqL2u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 06/17] net: rose: fix UAF bug caused by rose_t0timer_expiry
Date:   Mon, 11 Jul 2022 11:06:31 +0200
Message-Id: <20220711090536.447480515@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
References: <20220711090536.245939953@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit 148ca04518070910739dfc4eeda765057856403d upstream.

There are UAF bugs caused by rose_t0timer_expiry(). The
root cause is that del_timer() could not stop the timer
handler that is running and there is no synchronization.
One of the race conditions is shown below:

    (thread 1)             |        (thread 2)
                           | rose_device_event
                           |   rose_rt_device_down
                           |     rose_remove_neigh
rose_t0timer_expiry        |       rose_stop_t0timer(rose_neigh)
  ...                      |         del_timer(&neigh->t0timer)
                           |         kfree(rose_neigh) //[1]FREE
  neigh->dce_mode //[2]USE |

The rose_neigh is deallocated in position [1] and use in
position [2].

The crash trace triggered by POC is like below:

BUG: KASAN: use-after-free in expire_timers+0x144/0x320
Write of size 8 at addr ffff888009b19658 by task swapper/0/0
...
Call Trace:
 <IRQ>
 dump_stack_lvl+0xbf/0xee
 print_address_description+0x7b/0x440
 print_report+0x101/0x230
 ? expire_timers+0x144/0x320
 kasan_report+0xed/0x120
 ? expire_timers+0x144/0x320
 expire_timers+0x144/0x320
 __run_timers+0x3ff/0x4d0
 run_timer_softirq+0x41/0x80
 __do_softirq+0x233/0x544
 ...

This patch changes rose_stop_ftimer() and rose_stop_t0timer()
in rose_remove_neigh() to del_timer_sync() in order that the
timer handler could be finished before the resources such as
rose_neigh and so on are deallocated. As a result, the UAF
bugs could be mitigated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220705125610.77971-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_route.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -230,8 +230,8 @@ static void rose_remove_neigh(struct ros
 {
 	struct rose_neigh *s;
 
-	rose_stop_ftimer(rose_neigh);
-	rose_stop_t0timer(rose_neigh);
+	del_timer_sync(&rose_neigh->ftimer);
+	del_timer_sync(&rose_neigh->t0timer);
 
 	skb_queue_purge(&rose_neigh->queue);
 


