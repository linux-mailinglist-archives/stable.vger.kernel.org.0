Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74CE2A54EB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbgKCVPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:15:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732276AbgKCVPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:15:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76018205ED;
        Tue,  3 Nov 2020 21:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604438130;
        bh=awURhvlnj6+VV9teji5iY18RHMzQ1U3QDyMFsbvi7d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LESX9vVOm8UlU1GMfKHgFdzj1YdPevikjr5YtqlHWzfgpKVgBcCuTnHKa2c/TPeHr
         vyTvttxb+t1+3TuCnFh3qUyHcaMEaIQ4/zEuTLrIZoVLcb72SLfh9R3vqj0TMf8Wjz
         VMHX9NvudsciACmblRb4u0/lMX37JBcOLbQBdlrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yi, Ammy" <ammy.yi@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.9 191/391] perf/x86/intel: Fix Ice Lake event constraint table
Date:   Tue,  3 Nov 2020 21:34:02 +0100
Message-Id: <20201103203359.777866227@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 010cb00265f150bf82b23c02ad1fb87ce5c781e1 upstream.

An error occues when sampling non-PEBS INST_RETIRED.PREC_DIST(0x01c0)
event.

  perf record -e cpu/event=0xc0,umask=0x01/ -- sleep 1
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument)
  for event (cpu/event=0xc0,umask=0x01/).
  /bin/dmesg | grep -i perf may provide additional information.

The idxmsk64 of the event is set to 0. The event never be successfully
scheduled.

The event should be limit to the fixed counter 0.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Yi, Ammy <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200928134726.13090-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -243,7 +243,7 @@ static struct extra_reg intel_skl_extra_
 
 static struct event_constraint intel_icl_event_constraints[] = {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x1c0, 0),	/* INST_RETIRED.PREC_DIST */
+	FIXED_EVENT_CONSTRAINT(0x01c0, 0),	/* INST_RETIRED.PREC_DIST */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
 	FIXED_EVENT_CONSTRAINT(0x0400, 3),	/* SLOTS */


