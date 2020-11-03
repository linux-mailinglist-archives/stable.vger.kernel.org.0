Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71372A5283
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731813AbgKCUug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:50:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731828AbgKCUuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7AF920719;
        Tue,  3 Nov 2020 20:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436635;
        bh=5st3HmEUuVyb2esr98GZDzB8tLM/xbdUSP4xACTT7cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7jOY5UDcE8/t7KGLXq5tPwiYdXfYcoZRhKsRQGzrEW0GMVuSz7krLLqjzfdfIZtz
         rlplt3rZj3fxUaHv0hKJxxwEoPC3CSBBhH9dHPwnpMpJpuV5f88tLvJaoOA86pt+LB
         UcLt4DaLjtrU88vWertTs7QQjGu9bWoW3uPx2w/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengfei Xu <pengfei.xu@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 335/391] intel_idle: Fix max_cstate for processor models without C-state tables
Date:   Tue,  3 Nov 2020 21:36:26 +0100
Message-Id: <20201103203409.731879412@linuxfoundation.org>
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

From: Chen Yu <yu.c.chen@intel.com>

commit 4e0ba5577dba686f96c1c10ef4166380667fdec7 upstream.

Currently intel_idle driver gets the c-state information from ACPI
_CST if the processor model is not recognized by it. However the
c-state in _CST starts with index 1 which is different from the
index in intel_idle driver's internal c-state table.

While intel_idle_max_cstate_reached() was previously introduced to
deal with intel_idle driver's internal c-state table, re-using
this function directly on _CST is incorrect.

Fix this by subtracting 1 from the index when checking max_cstate
in the _CST case.

For example, append intel_idle.max_cstate=1 in boot command line,
Before the patch:
grep . /sys/devices/system/cpu/cpu0/cpuidle/state*/name
POLL
After the patch:
grep . /sys/devices/system/cpu/cpu0/cpuidle/state*/name
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1_ACPI

Fixes: 18734958e9bf ("intel_idle: Use ACPI _CST for processor models without C-state tables")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/idle/intel_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1235,7 +1235,7 @@ static void __init intel_idle_init_cstat
 		struct acpi_processor_cx *cx;
 		struct cpuidle_state *state;
 
-		if (intel_idle_max_cstate_reached(cstate))
+		if (intel_idle_max_cstate_reached(cstate - 1))
 			break;
 
 		cx = &acpi_state_table.states[cstate];


