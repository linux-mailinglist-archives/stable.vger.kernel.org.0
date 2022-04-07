Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D387C4F6FD1
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbiDGBPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiDGBOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:14:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B99188A2D;
        Wed,  6 Apr 2022 18:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA6E961DAF;
        Thu,  7 Apr 2022 01:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F38C385A1;
        Thu,  7 Apr 2022 01:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293892;
        bh=DhR6AeTKiLjq/3nWP2sq4FthZdkWvOrag8B25MAR0RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgXCFHMXRunaPbzi0jgEo4S1unF3c0YJA7lQe/9A2gkJt8j+Q8sEL32S3rr/u2GBl
         REjkC39yxbLEVSnx8oNZwZ3ICKqrhRh6+mKrsEYnOKjg6w9XkxCNkjVJ9zzqKZmRhz
         OgeaxOoHpwmK9DPly0z2hZbajtV+S0+60CIMdAQE46ShB4r1LYtgHRAJK+1KTHlYQs
         qUqW2rIGQEZ59sL7BPOlY10xHHLr9NqFfOIccPlm3++cxYy8NJHCa7upws7/wJ0jkD
         SsaDmx8WnZvBYj9h3EZZ2ih1Mf486Lj2Ncx5EL367ItZgV4EisFhA4gKTYk/CfHnH/
         hVTJXt6RJ5nKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Guenter Roeck <groeck@google.com>,
        Benson Leung <bleung@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        chrome-platform@lists.linux.dev
Subject: [PATCH AUTOSEL 5.17 28/31] platform/chrome: cros_ec_debugfs: detach log reader wq from devm
Date:   Wed,  6 Apr 2022 21:10:26 -0400
Message-Id: <20220407011029.113321-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011029.113321-1-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 0e8eb5e8acbad19ac2e1856b2fb2320184299b33 ]

Debugfs console_log uses devm memory (e.g. debug_info in
cros_ec_console_log_poll()).  However, lifecycles of device and debugfs
are independent.  An use-after-free issue is observed if userland
program operates the debugfs after the memory has been freed.

The call trace:
 do_raw_spin_lock
 _raw_spin_lock_irqsave
 remove_wait_queue
 ep_unregister_pollwait
 ep_remove
 do_epoll_ctl

A Python example to reproduce the issue:
... import select
... p = select.epoll()
... f = open('/sys/kernel/debug/cros_scp/console_log')
... p.register(f, select.POLLIN)
... p.poll(1)
[(4, 1)]                    # 4=fd, 1=select.POLLIN

[ shutdown cros_scp at the point ]

... p.poll(1)
[(4, 16)]                   # 4=fd, 16=select.POLLHUP
... p.unregister(f)

An use-after-free issue raises here.  It called epoll_ctl with
EPOLL_CTL_DEL which in turn to use the workqueue in the devm (i.e.
log_wq).

Detaches log reader's workqueue from devm to make sure it is persistent
even if the device has been removed.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Reviewed-by: Guenter Roeck <groeck@google.com>
Link: https://lore.kernel.org/r/20220209051130.386175-1-tzungbi@google.com
Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_debugfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_debugfs.c b/drivers/platform/chrome/cros_ec_debugfs.c
index 272c89837d74..0dbceee87a4b 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -25,6 +25,9 @@
 
 #define CIRC_ADD(idx, size, value)	(((idx) + (value)) & ((size) - 1))
 
+/* waitqueue for log readers */
+static DECLARE_WAIT_QUEUE_HEAD(cros_ec_debugfs_log_wq);
+
 /**
  * struct cros_ec_debugfs - EC debugging information.
  *
@@ -33,7 +36,6 @@
  * @log_buffer: circular buffer for console log information
  * @read_msg: preallocated EC command and buffer to read console log
  * @log_mutex: mutex to protect circular buffer
- * @log_wq: waitqueue for log readers
  * @log_poll_work: recurring task to poll EC for new console log data
  * @panicinfo_blob: panicinfo debugfs blob
  */
@@ -44,7 +46,6 @@ struct cros_ec_debugfs {
 	struct circ_buf log_buffer;
 	struct cros_ec_command *read_msg;
 	struct mutex log_mutex;
-	wait_queue_head_t log_wq;
 	struct delayed_work log_poll_work;
 	/* EC panicinfo */
 	struct debugfs_blob_wrapper panicinfo_blob;
@@ -107,7 +108,7 @@ static void cros_ec_console_log_work(struct work_struct *__work)
 			buf_space--;
 		}
 
-		wake_up(&debug_info->log_wq);
+		wake_up(&cros_ec_debugfs_log_wq);
 	}
 
 	mutex_unlock(&debug_info->log_mutex);
@@ -141,7 +142,7 @@ static ssize_t cros_ec_console_log_read(struct file *file, char __user *buf,
 
 		mutex_unlock(&debug_info->log_mutex);
 
-		ret = wait_event_interruptible(debug_info->log_wq,
+		ret = wait_event_interruptible(cros_ec_debugfs_log_wq,
 					CIRC_CNT(cb->head, cb->tail, LOG_SIZE));
 		if (ret < 0)
 			return ret;
@@ -173,7 +174,7 @@ static __poll_t cros_ec_console_log_poll(struct file *file,
 	struct cros_ec_debugfs *debug_info = file->private_data;
 	__poll_t mask = 0;
 
-	poll_wait(file, &debug_info->log_wq, wait);
+	poll_wait(file, &cros_ec_debugfs_log_wq, wait);
 
 	mutex_lock(&debug_info->log_mutex);
 	if (CIRC_CNT(debug_info->log_buffer.head,
@@ -377,7 +378,6 @@ static int cros_ec_create_console_log(struct cros_ec_debugfs *debug_info)
 	debug_info->log_buffer.tail = 0;
 
 	mutex_init(&debug_info->log_mutex);
-	init_waitqueue_head(&debug_info->log_wq);
 
 	debugfs_create_file("console_log", S_IFREG | 0444, debug_info->dir,
 			    debug_info, &cros_ec_console_log_fops);
-- 
2.35.1

