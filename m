Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E729540E8BA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356126AbhIPRpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355672AbhIPRl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F111763264;
        Thu, 16 Sep 2021 16:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811236;
        bh=wvv6VEjVnDkbYBwoKIDwcJZaj2kf3bkYzQSmU93wabg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=so6SOQWK6XpjyiwSML3PmTbW98NIJNTEk7kpsuXZwELafsIT1YccMTag/Dx+9KHVo
         AdNjGqHoVMR6wflzoFC6n/iWUY8E/ytejr0ZuR5nGnKJ2oRjHbGAoqsPo/5x1Fcx72
         fAO3v/xQbIQEDC0ttJ9zhwPwR32scRLwdRru/zHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Qiang.Zhang" <qiang.zhang@windriver.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.14 432/432] tracing/osnoise: Fix missed cpus_read_unlock() in start_per_cpu_kthreads()
Date:   Thu, 16 Sep 2021 18:03:01 +0200
Message-Id: <20210916155825.490889167@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiang.Zhang <qiang.zhang@windriver.com>

commit 4b6b08f2e45edda4c067ac40833e3c1f84383c0b upstream.

When start_kthread() return error, the cpus_read_unlock() need
to be called.

Link: https://lkml.kernel.org/r/20210831022919.27630-1-qiang.zhang@windriver.com

Cc: <stable@vger.kernel.org>
Fixes: c8895e271f79 ("trace/osnoise: Support hotplug operations")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Qiang.Zhang <qiang.zhang@windriver.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1548,7 +1548,7 @@ static int start_kthread(unsigned int cp
 static int start_per_cpu_kthreads(struct trace_array *tr)
 {
 	struct cpumask *current_mask = &save_cpumask;
-	int retval;
+	int retval = 0;
 	int cpu;
 
 	get_online_cpus();
@@ -1568,13 +1568,13 @@ static int start_per_cpu_kthreads(struct
 		retval = start_kthread(cpu);
 		if (retval) {
 			stop_per_cpu_kthreads();
-			return retval;
+			break;
 		}
 	}
 
 	put_online_cpus();
 
-	return 0;
+	return retval;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU


