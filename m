Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D52417DE4
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 00:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345416AbhIXWpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 18:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345479AbhIXWpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC446610F7;
        Fri, 24 Sep 2021 22:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523447;
        bh=/iXEJ0jhmXSVEgOcGxdKj/PT1MNs6Ql1OWiMFfWihQk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NYEcmriNinudufntzBrS4A2F5VPtudqbFdhwYlpi10T5eVfS3WojrM3pvohf1YLio
         Ue4hsXA26jcOAlO1LDmkA5eSNIa95vrGQOfipeQYR4Lhguia3a9dauDcVP84XZaGDZ
         ON/w9FimaHNFFG3yWV9sWh1dee+cppypZatCoN8w=
Date:   Fri, 24 Sep 2021 15:44:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenjun102@huawei.com,
        feng.tang@intel.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rui.xiang@huawei.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 16/16] mm: fix uninitialized use in
 overcommit_policy_handler
Message-ID: <20210924224406.83XR7wX9V%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>
Subject: mm: fix uninitialized use in overcommit_policy_handler

We get an unexpected value of /proc/sys/vm/overcommit_memory after running
the following program:

int main()
{
    int fd = open("/proc/sys/vm/overcommit_memory", O_RDWR);
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
Fixes: 56f3547bfa4d ("mm: adjust vm_committed_as_batch according to vm overcommit policy")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
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
