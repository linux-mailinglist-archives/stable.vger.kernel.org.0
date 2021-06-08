Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DF83A02A0
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhFHTHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237733AbhFHTFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDB20613E1;
        Tue,  8 Jun 2021 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177972;
        bh=OC74NW4mCL0JZqkcszsChFoNRgnSHwYR6dc81Uur1ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q967Qa7otXmnh0jKoLP+FCX5HZLKnv7DwVbmziuKH6qrUo6ZfE1iwD/hl00BlVL3F
         XuLKSQ04MaHp4ujX4Ycn1r0AtWE9XzAo5VBDonBWM+mF6P5e2FNAle3P9OvHwyzRq3
         jZL8W9Yr5eEv4zauWTNh/uOKrEJYV0Kg661zj32A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jianlin Lv <jianlin.lv@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Zhang Jinhao <zhangjinhao2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 029/161] perf probe: Fix NULL pointer dereference in convert_variable_location()
Date:   Tue,  8 Jun 2021 20:25:59 +0200
Message-Id: <20210608175946.431306540@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit 3cb17cce1e76ccc5499915a4d7e095a1ad6bf7ff ]

If we just check whether the variable can be converted, 'tvar' should be
a null pointer. However, the null pointer check is missing in the
'Constant value' execution path.

The following cases can trigger this problem:

	$ cat test.c
	#include <stdio.h>

	void main(void)
	{
	        int a;
	        const int b = 1;

	        asm volatile("mov %1, %0" : "=r"(a): "i"(b));
	        printf("a: %d\n", a);
	}

	$ gcc test.c -o test -O -g
	$ sudo ./perf probe -x ./test -L "main"
	<main@/home/lhf/test.c:0>
	      0  void main(void)
	         {
	      2          int a;
	                 const int b = 1;

	                 asm volatile("mov %1, %0" : "=r"(a): "i"(b));
	      6          printf("a: %d\n", a);
	         }

	$ sudo ./perf probe -x ./test -V "main:6"
	Segmentation fault

The check on 'tvar' is added. If 'tavr' is a null pointer, we return 0
to indicate that the variable can be converted. Now, we can successfully
show the variables that can be accessed.

	$ sudo ./perf probe -x ./test -V "main:6"
	Available variables at main:6
	        @<main+13>
	                char*   __fmt
	                int     a
	                int     b

However, the variable 'b' cannot be tracked.

	$ sudo ./perf probe -x ./test -D "main:6 b"
	Failed to find the location of the 'b' variable at this address.
	 Perhaps it has been optimized out.
	 Use -V with the --range option to show 'b' location range.
	  Error: Failed to add events.

This is because __die_find_variable_cb() did not successfully match
variable 'b', which has the DW_AT_const_value attribute instead of
DW_AT_location. We added support for DW_AT_const_value in
__die_find_variable_cb(). With this modification, we can successfully
track the variable 'b'.

	$ sudo ./perf probe -x ./test -D "main:6 b"
	p:probe_test/main_L6 /home/lhf/test:0x1156 b=\1:s32

Fixes: 66f69b219716 ("perf probe: Support DW_AT_const_value constant value")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jianlin Lv <jianlin.lv@arm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Cc: Zhang Jinhao <zhangjinhao2@huawei.com>
http://lore.kernel.org/lkml/20210601092750.169601-1-lihuafei1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c    | 8 ++++++--
 tools/perf/util/probe-finder.c | 3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 7b2d471a6419..4343356f3cf9 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -975,9 +975,13 @@ static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
 	if ((tag == DW_TAG_formal_parameter ||
 	     tag == DW_TAG_variable) &&
 	    die_compare_name(die_mem, fvp->name) &&
-	/* Does the DIE have location information or external instance? */
+	/*
+	 * Does the DIE have location information or const value
+	 * or external instance?
+	 */
 	    (dwarf_attr(die_mem, DW_AT_external, &attr) ||
-	     dwarf_attr(die_mem, DW_AT_location, &attr)))
+	     dwarf_attr(die_mem, DW_AT_location, &attr) ||
+	     dwarf_attr(die_mem, DW_AT_const_value, &attr)))
 		return DIE_FIND_CB_END;
 	if (dwarf_haspc(die_mem, fvp->addr))
 		return DIE_FIND_CB_CONTINUE;
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1b118c9c86a6..bba61b95a37a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -190,6 +190,9 @@ static int convert_variable_location(Dwarf_Die *vr_die, Dwarf_Addr addr,
 	    immediate_value_is_supported()) {
 		Dwarf_Sword snum;
 
+		if (!tvar)
+			return 0;
+
 		dwarf_formsdata(&attr, &snum);
 		ret = asprintf(&tvar->value, "\\%ld", (long)snum);
 
-- 
2.30.2



