Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A52A419AA7
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhI0RKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236507AbhI0RJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C5666120C;
        Mon, 27 Sep 2021 17:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762433;
        bh=7p7BTxAY4LdQdfc64WqD+BC4T1XXgJp16WkGugIKKsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqLdaZHqes32XCgRIbhQPwS2btJs6jznJiYlKSXd8104A2kCqFj9AYWgrutrRF91W
         lX2JWJ8VCvvioNt1YHA09Lj8hTv6gNlG5E+4c0qUDwmvVM+H8JL+HzrSc4d4MXG/kz
         tsfVgioXKOROOF6PAbkSmJuGqVqK62BBn+fj1wY8=
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
Subject: [PATCH 5.10 003/103] mm: fix uninitialized use in overcommit_policy_handler
Date:   Mon, 27 Sep 2021 19:01:35 +0200
Message-Id: <20210927170225.817580781@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
@@ -756,7 +756,7 @@ int overcommit_policy_handler(struct ctl
 		size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
-	int new_policy;
+	int new_policy = -1;
 	int ret;
 
 	/*
@@ -774,7 +774,7 @@ int overcommit_policy_handler(struct ctl
 		t = *table;
 		t.data = &new_policy;
 		ret = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
-		if (ret)
+		if (ret || new_policy == -1)
 			return ret;
 
 		mm_compute_batch(new_policy);


