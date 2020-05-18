Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10F81D8317
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732447AbgERSCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732459AbgERSCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5553B20872;
        Mon, 18 May 2020 18:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824921;
        bh=iI6/4pieNmhea6dG1LXDMXm/LdTJkwUeGnsdS5TIGu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1qfnGqCAzbTfCmte00XSjgYxyTOQQ8/f+gQpk7x8abj/NDRUN1amWOZ8yzBRAR0R
         Pp7OHDadt2BI3Yz9ReRs1PsIDdcqgTgYB31gM3k24XZqTKDjeMcdwHD96rx/fYNnr0
         O1OLvBB0tAsWyY9duZR3VNsJnhKekaGgSvVZk+7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 057/194] selftests/ftrace: Check the first record for kprobe_args_type.tc
Date:   Mon, 18 May 2020 19:35:47 +0200
Message-Id: <20200518173536.471309562@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Yang <yangx.jy@cn.fujitsu.com>

[ Upstream commit f0c0d0cf590f71b2213b29a7ded2cde3d0a1a0ba ]

It is possible to get multiple records from trace during test and then more
than 4 arguments are assigned to ARGS.  This situation results in the failure
of kprobe_args_type.tc.  For example:
-----------------------------------------------------------
grep testprobe trace
   ftracetest-5902  [001] d... 111195.682227: testprobe: (_do_fork+0x0/0x460) arg1=334823024 arg2=334823024 arg3=0x13f4fe70 arg4=7
     pmlogger-5949  [000] d... 111195.709898: testprobe: (_do_fork+0x0/0x460) arg1=345308784 arg2=345308784 arg3=0x1494fe70 arg4=7
 grep testprobe trace
 sed -e 's/.* arg1=\(.*\) arg2=\(.*\) arg3=\(.*\) arg4=\(.*\)/\1 \2 \3 \4/'
ARGS='334823024 334823024 0x13f4fe70 7
345308784 345308784 0x1494fe70 7'
-----------------------------------------------------------

We don't care which process calls do_fork so just check the first record to
fix the issue.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/kprobe/kprobe_args_type.tc  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_type.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_type.tc
index 1bcb67dcae267..81490ecaaa927 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_type.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_type.tc
@@ -38,7 +38,7 @@ for width in 64 32 16 8; do
   echo 0 > events/kprobes/testprobe/enable
 
   : "Confirm the arguments is recorded in given types correctly"
-  ARGS=`grep "testprobe" trace | sed -e 's/.* arg1=\(.*\) arg2=\(.*\) arg3=\(.*\) arg4=\(.*\)/\1 \2 \3 \4/'`
+  ARGS=`grep "testprobe" trace | head -n 1 | sed -e 's/.* arg1=\(.*\) arg2=\(.*\) arg3=\(.*\) arg4=\(.*\)/\1 \2 \3 \4/'`
   check_types $ARGS $width
 
   : "Clear event for next loop"
-- 
2.20.1



