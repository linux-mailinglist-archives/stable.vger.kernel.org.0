Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17AE561C8D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiF3N76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236660AbiF3N7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:59:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23F742EC2;
        Thu, 30 Jun 2022 06:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A072961FD8;
        Thu, 30 Jun 2022 13:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6A5C34115;
        Thu, 30 Jun 2022 13:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597103;
        bh=3ngv5y1KHBc9HKxzKMSOQnbjIIRFR7CxefAVlV0JhG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcAclkdGjdtGKWqbhw9mgeh1qm+pLhFyQQO/0/oevZa/dCeP1eTgWCeNR+fp/Rfmm
         ulIKPN4XxhMp251ap9V+1U3IfN4Z1vvNLnP07JKBZ4G+ipe3uAY2UxO5SqvipTh2mb
         Vyc7UnnlYIXpZxHub9XthQfErdTXfvUkeEuw5PiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 28/49] iio: trigger: sysfs: fix use-after-free on remove
Date:   Thu, 30 Jun 2022 15:46:41 +0200
Message-Id: <20220630133234.724968463@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit 78601726d4a59a291acc5a52da1d3a0a6831e4e8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/trigger/iio-trig-sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -198,6 +198,7 @@ static int iio_sysfs_trigger_remove(int
 	}
 
 	iio_trigger_unregister(t->trig);
+	irq_work_sync(&t->work);
 	iio_trigger_free(t->trig);
 
 	list_del(&t->l);


