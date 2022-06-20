Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F385511D1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbiFTHvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbiFTHvB (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD366DEEF
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 784016120B
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D883C3411B;
        Mon, 20 Jun 2022 07:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711459;
        bh=7QSiX2ovV9bqbzGR4yTTU1E6XveLxlGb8MNU8+kS9YE=;
        h=Subject:To:From:Date:From;
        b=p7Hi41FXEEA3lfc7uP9v1NIKeGUsT3tvGtJf7WAFg+jE+fFsahBcaCc37RNwwhs3v
         GOHlciQWrm7+Wvr3fjE9sUmmGaqM+ClNR3h1Uv/5d1p5lqg3/9qWfm69fwaUF2pRoy
         k2x9SR4akycjGNuNryjEhdXte/9wiMbJoVsaACic=
Subject: patch "iio: trigger: sysfs: fix use-after-free on remove" added to char-misc-linus
To:     vincent.whitchurch@axis.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:39 +0200
Message-ID: <165571143917254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


This is a note to let you know that I've just added the patch titled

    iio: trigger: sysfs: fix use-after-free on remove

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 78601726d4a59a291acc5a52da1d3a0a6831e4e8 Mon Sep 17 00:00:00 2001
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Date: Thu, 19 May 2022 11:19:25 +0200
Subject: iio: trigger: sysfs: fix use-after-free on remove

Ensure that the irq_work has completed before the trigger is freed.

 ==================================================================
 BUG: KASAN: use-after-free in irq_work_run_list
 Read of size 8 at addr 0000000064702248 by task python3/25

 Call Trace:
  irq_work_run_list
  irq_work_tick
  update_process_times
  tick_sched_handle
  tick_sched_timer
  __hrtimer_run_queues
  hrtimer_interrupt

 Allocated by task 25:
  kmem_cache_alloc_trace
  iio_sysfs_trig_add
  dev_attr_store
  sysfs_kf_write
  kernfs_fop_write_iter
  new_sync_write
  vfs_write
  ksys_write
  sys_write

 Freed by task 25:
  kfree
  iio_sysfs_trig_remove
  dev_attr_store
  sysfs_kf_write
  kernfs_fop_write_iter
  new_sync_write
  vfs_write
  ksys_write
  sys_write

 ==================================================================

Fixes: f38bc926d022 ("staging:iio:sysfs-trigger: Use irq_work to properly active trigger")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20220519091925.1053897-1-vincent.whitchurch@axis.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/trigger/iio-trig-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index 2a4b75897910..3d911c24b265 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -191,6 +191,7 @@ static int iio_sysfs_trigger_remove(int id)
 	}
 
 	iio_trigger_unregister(t->trig);
+	irq_work_sync(&t->work);
 	iio_trigger_free(t->trig);
 
 	list_del(&t->l);
-- 
2.36.1


