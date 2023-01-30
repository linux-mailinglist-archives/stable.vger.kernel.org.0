Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CAD681086
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbjA3OEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237053AbjA3OEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501A1193F2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF0BA61034
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C98C4339C;
        Mon, 30 Jan 2023 14:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087442;
        bh=fsHdR4q761UZUlls4AdE45R2H00rW/PABzSWAmzu5LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdHzR3Y5pIoObUh3Y8ANrMkHpZ+QxUVYe1F6eb/Gz/wRyQXHrBxvNgfbTRKJx4cAB
         I5vsU9HmEmxNJB24Plf3FZE6Y0r+tTV3Y6mnW29UUcc9daHk4imWfmYRzihX8azsho
         Di4vVIZEzyWWTdgDdI+wxKt9wloDpqco35foXaM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Petr Pavlu <petr.pavlu@suse.com>,
        Petr Mladek <pmladek@suse.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.1 210/313] module: Dont wait for GOING modules
Date:   Mon, 30 Jan 2023 14:50:45 +0100
Message-Id: <20230130134346.478661234@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Petr Pavlu <petr.pavlu@suse.com>

commit 0254127ab977e70798707a7a2b757c9f3c971210 upstream.

During a system boot, it can happen that the kernel receives a burst of
requests to insert the same module but loading it eventually fails
during its init call. For instance, udev can make a request to insert
a frequency module for each individual CPU when another frequency module
is already loaded which causes the init function of the new module to
return an error.

Since commit 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for
modules that have finished loading"), the kernel waits for modules in
MODULE_STATE_GOING state to finish unloading before making another
attempt to load the same module.

This creates unnecessary work in the described scenario and delays the
boot. In the worst case, it can prevent udev from loading drivers for
other devices and might cause timeouts of services waiting on them and
subsequently a failed boot.

This patch attempts a different solution for the problem 6e6de3dee51a
was trying to solve. Rather than waiting for the unloading to complete,
it returns a different error code (-EBUSY) for modules in the GOING
state. This should avoid the error situation that was described in
6e6de3dee51a (user space attempting to load a dependent module because
the -EEXIST error code would suggest to user space that the first module
had been loaded successfully), while avoiding the delay situation too.

This has been tested on linux-next since December 2022 and passes
all kmod selftests except test 0009 with module compression enabled
but it has been confirmed that this issue has existed and has gone
unnoticed since prior to this commit and can also be reproduced without
module compression with a simple usleep(5000000) on tools/modprobe.c [0].
These failures are caused by hitting the kernel mod_concurrent_max and can
happen either due to a self inflicted kernel module auto-loead DoS somehow
or on a system with large CPU count and each CPU count incorrectly triggering
many module auto-loads. Both of those issues need to be fixed in-kernel.

[0] https://lore.kernel.org/all/Y9A4fiobL6IHp%2F%2FP@bombadil.infradead.org/

Fixes: 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for modules that have finished loading")
Co-developed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Petr Mladek <pmladek@suse.com>
[mcgrof: enhance commit log with testing and kmod test result interpretation ]
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/main.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2386,7 +2386,8 @@ static bool finished_loading(const char
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
 	mod = find_module_all(name, strlen(name), true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE;
+	ret = !mod || mod->state == MODULE_STATE_LIVE
+		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -2562,20 +2563,35 @@ static int add_unformed_module(struct mo
 
 	mod->state = MODULE_STATE_UNFORMED;
 
-again:
 	mutex_lock(&module_mutex);
 	old = find_module_all(mod->name, strlen(mod->name), true);
 	if (old != NULL) {
-		if (old->state != MODULE_STATE_LIVE) {
+		if (old->state == MODULE_STATE_COMING
+		    || old->state == MODULE_STATE_UNFORMED) {
 			/* Wait in case it fails to load. */
 			mutex_unlock(&module_mutex);
 			err = wait_event_interruptible(module_wq,
 					       finished_loading(mod->name));
 			if (err)
 				goto out_unlocked;
-			goto again;
+
+			/* The module might have gone in the meantime. */
+			mutex_lock(&module_mutex);
+			old = find_module_all(mod->name, strlen(mod->name),
+					      true);
 		}
-		err = -EEXIST;
+
+		/*
+		 * We are here only when the same module was being loaded. Do
+		 * not try to load it again right now. It prevents long delays
+		 * caused by serialized module load failures. It might happen
+		 * when more devices of the same type trigger load of
+		 * a particular module.
+		 */
+		if (old && old->state == MODULE_STATE_LIVE)
+			err = -EEXIST;
+		else
+			err = -EBUSY;
 		goto out;
 	}
 	mod_update_bounds(mod);


