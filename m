Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09E450F428
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbiDZIff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344907AbiDZIdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:33:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5507A3D4B2;
        Tue, 26 Apr 2022 01:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10C57B81CF9;
        Tue, 26 Apr 2022 08:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3B2C385A4;
        Tue, 26 Apr 2022 08:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961530;
        bh=M1EoUdOlEfwEvT3mFKB1QFhizqGdGGZuqIkH2iI4Muc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyDGzPV/XzFpglXnXyrckCSnaU1ZHTdY+YTEpM6tpeUNFYoOAr7cDCAY3pvvL9NXu
         fsKtUwGMZxseQzybC14yf7tLP5NwmIblWurOpsCK9EaNESuGHmi0FGYZ9tSqMkXZN3
         IB0w7rEO2W7gOM48tfwMLsm2qCVWcHlVA6UNgJ+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Paolo Abeni <pabeni@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 42/43] ax25: Fix UAF bugs in ax25 timers
Date:   Tue, 26 Apr 2022 10:21:24 +0200
Message-Id: <20220426081735.761411609@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 82e31755e55fbcea6a9dfaae5fe4860ade17cbc0 upstream.

There are race conditions that may lead to UAF bugs in
ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we call
ax25_release() to deallocate ax25_dev.

One of the UAF bugs caused by ax25_release() is shown below:

      (Thread 1)                    |      (Thread 2)
ax25_dev_device_up() //(1)          |
...                                 | ax25_kill_by_device()
ax25_bind()          //(2)          |
ax25_connect()                      | ...
 ax25_std_establish_data_link()     |
  ax25_start_t1timer()              | ax25_dev_device_down() //(3)
   mod_timer(&ax25->t1timer,..)     |
                                    | ax25_release()
   (wait a time)                    |  ...
                                    |  ax25_dev_put(ax25_dev) //(4)FREE
   ax25_t1timer_expiry()            |
    ax25->ax25_dev->values[..] //USE|  ...
     ...                            |

We increase the refcount of ax25_dev in position (1) and (2), and
decrease the refcount of ax25_dev in position (3) and (4).
The ax25_dev will be freed in position (4) and be used in
ax25_t1timer_expiry().

The fail log is shown below:
==============================================================

[  106.116942] BUG: KASAN: use-after-free in ax25_t1timer_expiry+0x1c/0x60
[  106.116942] Read of size 8 at addr ffff88800bda9028 by task swapper/0/0
[  106.116942] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-06123-g0905eec574
[  106.116942] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-14
[  106.116942] Call Trace:
...
[  106.116942]  ax25_t1timer_expiry+0x1c/0x60
[  106.116942]  call_timer_fn+0x122/0x3d0
[  106.116942]  __run_timers.part.0+0x3f6/0x520
[  106.116942]  run_timer_softirq+0x4f/0xb0
[  106.116942]  __do_softirq+0x1c2/0x651
...

This patch adds del_timer_sync() in ax25_release(), which could ensure
that all timers stop before we deallocate ax25_dev.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[OP: backport to 4.14: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1056,6 +1056,11 @@ static int ax25_release(struct socket *s
 		ax25_destroy_socket(ax25);
 	}
 	if (ax25_dev) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
 		dev_put(ax25_dev->dev);
 		ax25_dev_put(ax25_dev);
 	}


