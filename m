Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B47D419B72
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235889AbhI0RTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236635AbhI0RRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:17:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B7861390;
        Mon, 27 Sep 2021 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762701;
        bh=IUFd4aHh/xurA8dtSQA7kyWIwSeDXajTjrdOd6d+Coo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g68bi9FVOUPYRipR+DeezTn7NIY4T4y9XAfE1Ce93bNhHZM+1a+rE+rV6pXOWa5Kz
         LQZSqx50+0jFFf3MIxHwdxExYgGzhIWq8K46p+iZgVsj7RWe+FSb/jIiGl8Uyj37rm
         vuDuDu1jaSQiOee9+huZMGwhtzxhWadoXph/uIao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Jun <chenjun102@huawei.com>,
        Michal Hocko <mhocko@suse.com>,
        Feng Tang <feng.tang@intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 004/162] mm: fix uninitialized use in overcommit_policy_handler
Date:   Mon, 27 Sep 2021 19:00:50 +0200
Message-Id: <20210927170233.616148231@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>

commit bcbda81020c3ee77e2c098cadf3e84f99ca3de17 upstream.

We get an unexpected value of /proc/sys/vm/overcommit_memory after
running the following program:

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/util.c
+++ b/mm/util.c
@@ -768,7 +768,7 @@ int overcommit_policy_handler(struct ctl
 		size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
-	int new_policy;
+	int new_policy = -1;
 	int ret;
 
 	/*
@@ -786,7 +786,7 @@ int overcommit_policy_handler(struct ctl
 		t = *table;
 		t.data = &new_policy;
 		ret = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
-		if (ret)
+		if (ret || new_policy == -1)
 			return ret;
 
 		mm_compute_batch(new_policy);


