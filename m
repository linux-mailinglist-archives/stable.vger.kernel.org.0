Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072F1603F35
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiJSJav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiJSJ1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7B5E6F76;
        Wed, 19 Oct 2022 02:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14F7361738;
        Wed, 19 Oct 2022 09:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F17C433C1;
        Wed, 19 Oct 2022 09:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170062;
        bh=9DW2B3GfccMQLd9+7/WwNZWZFVrCRAP6iFxZJ8fPyXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfPLgsHHNLWQT+iZFvGYO7f8/ZMzPz7MVPNm+msJ9T9hbM4wNi0eAbdXcp0bRGyfV
         UYHQ3MYpTed35ikixLHmIqFaCrPZUQNsSpydISW8Th+X4EqI+PAzuFyJkBIa0qA8EC
         VnycnET23AvjgkbmMDrEmXPb+4XpMwdSnxOOjw2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 511/862] iio: Use per-device lockdep class for mlock
Date:   Wed, 19 Oct 2022 10:29:58 +0200
Message-Id: <20221019083312.561138991@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 2bc9cd66eb25d0fefbb081421d6586495e25840e ]

If an IIO driver uses callbacks from another IIO driver and calls
iio_channel_start_all_cb() from one of its buffer setup ops, then
lockdep complains due to the lock nesting, as in the below example with
lmp91000.

Since the locks are being taken on different IIO devices, there is no
actual deadlock.  Fix the warning by telling lockdep to use a different
class for each iio_device.

 ============================================
 WARNING: possible recursive locking detected
 --------------------------------------------
 python3/23 is trying to acquire lock:
 (&indio_dev->mlock){+.+.}-{3:3}, at: iio_update_buffers

 but task is already holding lock:
 (&indio_dev->mlock){+.+.}-{3:3}, at: enable_store

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&indio_dev->mlock);
   lock(&indio_dev->mlock);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 5 locks held by python3/23:
  #0: (sb_writers#5){.+.+}-{0:0}, at: ksys_write
  #1: (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter
  #2: (kn->active#14){.+.+}-{0:0}, at: kernfs_fop_write_iter
  #3: (&indio_dev->mlock){+.+.}-{3:3}, at: enable_store
  #4: (&iio_dev_opaque->info_exist_lock){+.+.}-{3:3}, at: iio_update_buffers

 Call Trace:
  __mutex_lock
  iio_update_buffers
  iio_channel_start_all_cb
  lmp91000_buffer_postenable
  __iio_update_buffers
  enable_store

Fixes: 67e17300dc1d76 ("iio: potentiostat: add LMP91000 support")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220829091840.2791846-1-vincent.whitchurch@axis.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-core.c | 5 +++++
 include/linux/iio/iio-opaque.h  | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 0f4dbda3b9d3..921d8e8643a2 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1621,6 +1621,8 @@ static void iio_dev_release(struct device *device)
 
 	iio_device_detach_buffers(indio_dev);
 
+	lockdep_unregister_key(&iio_dev_opaque->mlock_key);
+
 	ida_free(&iio_ida, iio_dev_opaque->id);
 	kfree(iio_dev_opaque);
 }
@@ -1680,6 +1682,9 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 	INIT_LIST_HEAD(&iio_dev_opaque->buffer_list);
 	INIT_LIST_HEAD(&iio_dev_opaque->ioctl_handlers);
 
+	lockdep_register_key(&iio_dev_opaque->mlock_key);
+	lockdep_set_class(&indio_dev->mlock, &iio_dev_opaque->mlock_key);
+
 	return indio_dev;
 }
 EXPORT_SYMBOL(iio_device_alloc);
diff --git a/include/linux/iio/iio-opaque.h b/include/linux/iio/iio-opaque.h
index 6b3586b3f952..d1f8b30a7c8b 100644
--- a/include/linux/iio/iio-opaque.h
+++ b/include/linux/iio/iio-opaque.h
@@ -11,6 +11,7 @@
  *				checked by device drivers but should be considered
  *				read-only as this is a core internal bit
  * @driver_module:		used to make it harder to undercut users
+ * @mlock_key:			lockdep class for iio_dev lock
  * @info_exist_lock:		lock to prevent use during removal
  * @trig_readonly:		mark the current trigger immutable
  * @event_interface:		event chrdevs associated with interrupt lines
@@ -42,6 +43,7 @@ struct iio_dev_opaque {
 	int				currentmode;
 	int				id;
 	struct module			*driver_module;
+	struct lock_class_key		mlock_key;
 	struct mutex			info_exist_lock;
 	bool				trig_readonly;
 	struct iio_event_interface	*event_interface;
-- 
2.35.1



