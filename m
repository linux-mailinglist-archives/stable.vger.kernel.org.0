Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93EE4F3189
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237938AbiDEInm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241167AbiDEIcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE37E167C3;
        Tue,  5 Apr 2022 01:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CE1609D0;
        Tue,  5 Apr 2022 08:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B53BC385A1;
        Tue,  5 Apr 2022 08:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147337;
        bh=pKN6mTEyEarvcHrqx7JWF0SAABVKkggu6a7q9LHV3hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKzAIduaMNyqRbWbKps6rxlT3OL6/XdKp//AOiutFxYH9yhw8+9oVVAESn21OKVPQ
         KKFx+BGdNy+MfCjBwDezctBdp7gy9unThttrDlOhDjMkzZ6EWiPRTlOkpY5Bz0Z98G
         5DKZE3f1ViVWSUz44cqf0qjGNLEga5mRQe7hXRgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.17 1050/1126] block: restore the old set_task_ioprio() behaviour wrt PF_EXITING
Date:   Tue,  5 Apr 2022 09:29:57 +0200
Message-Id: <20220405070438.290129747@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jiri Slaby <jslaby@suse.cz>

commit 15583a563cd5a7358e975599b7de7caacd9e9ce9 upstream.

PF_EXITING tasks were silently ignored before the below commits.
Continue doing so. Otherwise python-psutil tests fail:
  ERROR: psutil.tests.test_process.TestProcess.test_zombie_process
  ----------------------------------------------------------------------
  Traceback (most recent call last):
    File "/home/abuild/rpmbuild/BUILD/psutil-5.9.0/build/lib.linux-x86_64-3.9/psutil/_pslinux.py", line 1661, in wrapper
      return fun(self, *args, **kwargs)
    File "/home/abuild/rpmbuild/BUILD/psutil-5.9.0/build/lib.linux-x86_64-3.9/psutil/_pslinux.py", line 2133, in ionice_set
      return cext.proc_ioprio_set(self.pid, ioclass, value)
  ProcessLookupError: [Errno 3] No such process

  During handling of the above exception, another exception occurred:

  Traceback (most recent call last):
    File "/home/abuild/rpmbuild/BUILD/psutil-5.9.0/psutil/tests/test_process.py", line 1313, in test_zombie_process
      succeed_or_zombie_p_exc(fun)
    File "/home/abuild/rpmbuild/BUILD/psutil-5.9.0/psutil/tests/test_process.py", line 1288, in succeed_or_zombie_p_exc
      return fun()
    File "/home/abuild/rpmbuild/BUILD/psutil-5.9.0/build/lib.linux-x86_64-3.9/psutil/__init__.py", line 792, in ionice
      return self._proc.ionice_set(ioclass, value)
    File "/home/abuild/rpmbuild/BUILD/psutil-5.9.0/build/lib.linux-x86_64-3.9/psutil/_pslinux.py", line 1665, in wrapper
      raise NoSuchProcess(self.pid, self._name)
  psutil.NoSuchProcess: process no longer exists (pid=2057)

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 5fc11eebb4 (block: open code create_task_io_context in set_task_ioprio)
Fixes: a957b61254 (block: fix error in handling dead task for ioprio setting)
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220328085928.7899-1-jslaby@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-ioc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -280,7 +280,6 @@ int set_task_ioprio(struct task_struct *
 
 		task_lock(task);
 		if (task->flags & PF_EXITING) {
-			err = -ESRCH;
 			kmem_cache_free(iocontext_cachep, ioc);
 			goto out;
 		}
@@ -292,7 +291,7 @@ int set_task_ioprio(struct task_struct *
 	task->io_context->ioprio = ioprio;
 out:
 	task_unlock(task);
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(set_task_ioprio);
 


