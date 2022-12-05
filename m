Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4558C6426C9
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 11:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiLEKgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 05:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiLEKgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 05:36:23 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5051A06E;
        Mon,  5 Dec 2022 02:36:17 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B3E9A220B6;
        Mon,  5 Dec 2022 10:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670236575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=MWbx+7pJCIfrUHqs9WTk95Eg8UQffqIKRsn3+zrW6Sc=;
        b=b2zKel2OqJ51l5Li8Gboc/hWKjvrWvuS/afiYLCFZnCqulur6sjo3fv3O922t1cLlgct4F
        qqLq1JrM5/Tla+yOC6qTsp1fSKjt1TUIum0dgRDjFQxAy5ufbovjbtlYJyx7SA6BCbcPgN
        q2AdOXHe5/deboVZEnUYrVWLrzxdVsI=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 72B6A1348F;
        Mon,  5 Dec 2022 10:36:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id lALjGp/JjWM7CgAAGKfGzw
        (envelope-from <petr.pavlu@suse.com>); Mon, 05 Dec 2022 10:36:15 +0000
From:   Petr Pavlu <petr.pavlu@suse.com>
To:     mcgrof@kernel.org
Cc:     pmladek@suse.com, prarit@redhat.com, david@redhat.com,
        mwilck@suse.com, petr.pavlu@suse.com,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] module: Don't wait for GOING modules
Date:   Mon,  5 Dec 2022 11:35:57 +0100
Message-Id: <20221205103557.18363-1-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for modules that have finished loading")
Co-developed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Cc: stable@vger.kernel.org
---

Changes since v1 [1]:
- Don't attempt a new module initialization when a same-name module
  completely disappeared while waiting on it, which means it went
  through the GOING state implicitly already.

[1] https://lore.kernel.org/linux-modules/20221123131226.24359-1-petr.pavlu@suse.com/

 kernel/module/main.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index d02d39c7174e..7a627345d4fd 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2386,7 +2386,8 @@ static bool finished_loading(const char *name)
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
 	mod = find_module_all(name, strlen(name), true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE;
+	ret = !mod || mod->state == MODULE_STATE_LIVE
+		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -2562,20 +2563,35 @@ static int add_unformed_module(struct module *mod)
 
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
-- 
2.35.3

