Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02572F94E6
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 20:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbhAQT27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 14:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbhAQT2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 14:28:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7CFF224B8;
        Sun, 17 Jan 2021 19:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610911670;
        bh=MbfQkfa0mwBjjhG0MoKCcndWdsbLQPosDFQs5xL22W4=;
        h=Date:From:To:Subject:From;
        b=hWYjhUHjeesteMF3Ot3VUOQq14nfZkqDLCCNBPTu9e7/Uh1SK6+gRrQP2DpQIAq3z
         msrAKocKbnsLi/eY9yBJD7BL5P1+/4OjRB0J7V4+h7I8rHmT4CCbElRvWLd7RTV9eP
         t3o2Vo4YDcJHhG7by3uUFlDl6ewjG9L75Sfe5T14=
Date:   Sun, 17 Jan 2021 11:27:48 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, keescook@chromium.org, mcgrof@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        stable@vger.kernel.org, vbabka@suse.cz, yzaikin@google.com
Subject:  [to-be-updated]
 proc_sysctl-fix-oops-caused-by-incorrect-command-parameters.patch removed
 from -mm tree
Message-ID: <20210117192748.FB8AEfggd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: proc_sysctl: fix oops caused by incorrect command parameters.
has been removed from the -mm tree.  Its filename was
     proc_sysctl-fix-oops-caused-by-incorrect-command-parameters.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: proc_sysctl: fix oops caused by incorrect command parameters.

The process_sysctl_arg() does not check whether val is empty before
invoking strlen(val).  If the command line parameter () is incorrectly
configured and val is empty, oops is triggered.

For example, "hung_task_panic=1" is incorrectly written as "hung_task_panic".

log:
	Kernel command line: .... hung_task_panic
	....
	[000000000000000n] user address but active_mm is swapper
	Internal error: Oops: 96000005 [#1] SMP
	Modules linked in:
	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.1 #1
	Hardware name: linux,dummy-virt (DT)
	pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=--)
	pc : __pi_strlen+0x10/0x98
	lr : process_sysctl_arg+0x1e4/0x2ac
	sp : ffffffc01104bd40
	x29: ffffffc01104bd40 x28: 0000000000000000
	x27: ffffff80c0a4691e x26: ffffffc0102a7c8c
	x25: 0000000000000000 x24: ffffffc01104be80
	x23: ffffff80c22f0b00 x22: ffffff80c02e28c0
	x21: ffffffc0109f9000 x20: 0000000000000000
	x19: ffffffc0107c08de x18: 0000000000000003
	x17: ffffffc01105d000 x16: 0000000000000054
	x15: ffffffffffffffff x14: 3030253078413830
	x13: 000000000000ffff x12: 0000000000000000
	x11: 0101010101010101 x10: 0000000000000005
	x9 : 0000000000000003 x8 : ffffff80c0980c08
	x7 : 0000000000000000 x6 : 0000000000000002
	x5 : ffffff80c0235000 x4 : ffffff810f7c7ee0
	x3 : 000000000000043a x2 : 00bdcc4ebacf1a54
	x1 : 0000000000000000 x0 : 0000000000000000
	Call trace:
	 __pi_strlen+0x10/0x98
	 parse_args+0x278/0x344
	 do_sysctl_args+0x8c/0xfc
	 kernel_init+0x5c/0xf4
	 ret_from_fork+0x10/0x30
	Code: b200c3eb 927cec01 f2400c07 54000301 (a8c10c22)

Link: https://lkml.kernel.org/r/20210108023339.55917-1-nixiaoming@huawei.com
Fixes: 3db978d480e2843 ("kernel/sysctl: support setting sysctl parameters from kernel command line")
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/proc/proc_sysctl.c~proc_sysctl-fix-oops-caused-by-incorrect-command-parameters
+++ a/fs/proc/proc_sysctl.c
@@ -1757,6 +1757,11 @@ static int process_sysctl_arg(char *para
 	loff_t pos = 0;
 	ssize_t wret;
 
+	if (!val) {
+		pr_err("Missing param value! Expected '%s=...value...'\n", param);
+		return 0;
+	}
+
 	if (strncmp(param, "sysctl", sizeof("sysctl") - 1) == 0) {
 		param += sizeof("sysctl") - 1;
 
_

Patches currently in -mm which might be from nixiaoming@huawei.com are


