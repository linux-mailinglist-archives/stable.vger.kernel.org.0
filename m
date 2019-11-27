Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4998810B84A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfK0Ul4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbfK0Ulx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:41:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C00A221775;
        Wed, 27 Nov 2019 20:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887313;
        bh=G+bUnZIIGo0TF/ZYi61/DRntB0hbkjdnF5/2+ThSJ3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWqtUSiaujTVjKd1y1iyel02RwGPB098IoS4sQ43p50P2MVI5DJMMDx5IniTW++I/
         f8hojvgnOcmXGoB9c+obBIapCLiv7dS5DCLcD8ViYJH5EZx0/J00JeEBuE2FP17IYm
         JRhT8BDc5smWQx4JOGeQCkC3iWhNwldAKXj8T9eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Shuah Khan (Samsung OSG)" <shuah@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 060/151] selftests/ftrace: Fix to test kprobe $comm arg only if available
Date:   Wed, 27 Nov 2019 21:30:43 +0100
Message-Id: <20191127203032.997599346@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 2452c96e617a0ff6fb2692e55217a3fa57a7322c ]

Test $comm in kprobe-event argument syntax testcase
only if it is supported on the kernel because
$comm has been introduced 4.8 kernel.
So on older stable kernel, it should be skipped.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/kprobe/kprobe_args_syntax.tc       | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_syntax.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_syntax.tc
index 231bcd2c4eb59..1e7ac6f3362ff 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_syntax.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_syntax.tc
@@ -71,8 +71,11 @@ test_badarg "\$stackp" "\$stack0+10" "\$stack1-10"
 echo "r ${PROBEFUNC} \$retval" > kprobe_events
 ! echo "p ${PROBEFUNC} \$retval" > kprobe_events
 
+# $comm was introduced in 4.8, older kernels reject it.
+if grep -A1 "fetcharg:" README | grep -q '\$comm' ; then
 : "Comm access"
 test_goodarg "\$comm"
+fi
 
 : "Indirect memory access"
 test_goodarg "+0(${GOODREG})" "-0(${GOODREG})" "+10(\$stack)" \
-- 
2.20.1



