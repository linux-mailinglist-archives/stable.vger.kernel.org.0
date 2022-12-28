Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5EA6584C2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiL1RB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiL1RA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:00:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D098D1B9CC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 669B7613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD8BC433D2;
        Wed, 28 Dec 2022 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246559;
        bh=k58RRflD6JGFt7EF93aoHdhUah760czXjm3Zmz65dMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bb6Pa6D06+fHpW8axTjIwMcMUhjFH5ZmUxk5H5hOHWwCC6hOsu2gEz2AHPvO+/NWj
         KkHU0WOb9JJ02yw+tUkSToDsyz/hVAhYl7oVozyM2GIfZzrkipbRhPEv6QV9plwquy
         P4cKcwFFtw69bcMJGTDlQ2bblWZ0armx558R9cDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Wang <wvw@google.com>,
        Midas Chien <midaschieh@google.com>,
        Connor OBrien <connoro@google.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, kernel-team@android.com,
        John Stultz <jstultz@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1081/1146] pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion
Date:   Wed, 28 Dec 2022 15:43:40 +0100
Message-Id: <20221228144359.574112911@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Stultz <jstultz@google.com>

[ Upstream commit 76d62f24db07f22ccf9bc18ca793c27d4ebef721 ]

Wei Wang reported seeing priority inversion caused latencies
caused by contention on pmsg_lock, and suggested it be switched
to a rt_mutex.

I was initially hesitant this would help, as the tasks in that
trace all seemed to be SCHED_NORMAL, so the benefit would be
limited to only nice boosting.

However, another similar issue was raised where the priority
inversion was seen did involve a blocked RT task so it is clear
this would be helpful in that case.

Cc: Wei Wang <wvw@google.com>
Cc: Midas Chien<midaschieh@google.com>
Cc: Connor O'Brien <connoro@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: kernel-team@android.com
Fixes: 9d5438f462ab ("pstore: Add pmsg - user-space accessible pstore object")
Reported-by: Wei Wang <wvw@google.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221214231834.3711880-1-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/pmsg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/pmsg.c b/fs/pstore/pmsg.c
index d8542ec2f38c..18cf94b597e0 100644
--- a/fs/pstore/pmsg.c
+++ b/fs/pstore/pmsg.c
@@ -7,9 +7,10 @@
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/rtmutex.h>
 #include "internal.h"
 
-static DEFINE_MUTEX(pmsg_lock);
+static DEFINE_RT_MUTEX(pmsg_lock);
 
 static ssize_t write_pmsg(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
@@ -28,9 +29,9 @@ static ssize_t write_pmsg(struct file *file, const char __user *buf,
 	if (!access_ok(buf, count))
 		return -EFAULT;
 
-	mutex_lock(&pmsg_lock);
+	rt_mutex_lock(&pmsg_lock);
 	ret = psinfo->write_user(&record, buf);
-	mutex_unlock(&pmsg_lock);
+	rt_mutex_unlock(&pmsg_lock);
 	return ret ? ret : count;
 }
 
-- 
2.35.1



