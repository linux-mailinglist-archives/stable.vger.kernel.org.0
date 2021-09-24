Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF2C4169F7
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 04:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243813AbhIXCYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 22:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232911AbhIXCYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 22:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B023B61019;
        Fri, 24 Sep 2021 02:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632450157;
        bh=g4G2SE4xFdKQ0vQoVyHYgIu1t9UFPMCRAl+K5MYGPTg=;
        h=Date:From:To:Subject:From;
        b=kl9t8+pAtOApa+HB+5E1FZfbXMxGap4HzgohAamB/YtLTRaPus0/1uj9MkBs8tjuX
         d25smpHJvIm2i4YWpbPUFgbcw6lRyS9ftl4f6CupjIPdQEV059NPZRcHjsLNavs0i0
         i+M/eIdCK2mpYVsJFE0ru3cJUgUBNC/INRWEe+hA=
Date:   Thu, 23 Sep 2021 19:22:37 -0700
From:   akpm@linux-foundation.org
To:     chenjun102@huawei.com, feng.tang@intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rui.xiang@huawei.com,
        stable@vger.kernel.org
Subject:  +
 mm-fix-the-uninitialized-use-in-overcommit_policy_handler.patch added to
 -mm tree
Message-ID: <20210924022237.MIV4ocWek%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix uninitialized use in overcommit_policy_handler
has been added to the -mm tree.  Its filename is
     mm-fix-the-uninitialized-use-in-overcommit_policy_handler.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-uninitialized-use-in-overcommit_policy_handler.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-uninitialized-use-in-overcommit_policy_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Jun <chenjun102@huawei.com>
Subject: mm: fix uninitialized use in overcommit_policy_handler

We get an unexpected value of /proc/sys/vm/overcommit_memory after running
the following program:

int main()
{
    int fd = open("/proc/sys/vm/overcommit_memory", O_RDWR)
    write(fd, "1", 1);
    write(fd, "2", 1);
    close(fd);
}

write(fd, "2", 1) will pass *ppos = 1 to proc_dointvec_minmax. 
proc_dointvec_minmax will return 0 without setting new_policy.

t.data = &new_policy;
ret = proc_dointvec_minmax(&t, write, buffer, lenp, ppos)
      -->do_proc_dointvec
         -->__do_proc_dointvec
              if (write) {
                if (proc_first_pos_non_zero_ignore(ppos, table))
                  goto out;

sysctl_overcommit_memory = new_policy;

so sysctl_overcommit_memory will be set to an uninitialized value.

Check whether new_policy has been changed by proc_dointvec_minmax.

Link: https://lkml.kernel.org/r/20210923020524.13289-1-chenjun102@huawei.com
Fixes: 56f3547bfa4d ("mm: adjust vm_committed_as_batch according to vm overcommit policy"
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/util.c~mm-fix-the-uninitialized-use-in-overcommit_policy_handler
+++ a/mm/util.c
@@ -787,7 +787,7 @@ int overcommit_policy_handler(struct ctl
 		size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
-	int new_policy;
+	int new_policy = -1;
 	int ret;
 
 	/*
@@ -805,7 +805,7 @@ int overcommit_policy_handler(struct ctl
 		t = *table;
 		t.data = &new_policy;
 		ret = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
-		if (ret)
+		if (ret || new_policy == -1)
 			return ret;
 
 		mm_compute_batch(new_policy);
_

Patches currently in -mm which might be from chenjun102@huawei.com are

mm-fix-the-uninitialized-use-in-overcommit_policy_handler.patch

