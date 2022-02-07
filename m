Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91EE4ABD7B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245245AbiBGLom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385075AbiBGLbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C94C03544C;
        Mon,  7 Feb 2022 03:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A1E260AB0;
        Mon,  7 Feb 2022 11:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2330C004E1;
        Mon,  7 Feb 2022 11:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233350;
        bh=dlSCWan0FfA5znaLczSL60Lqi/QBNHiAtI0rESPoMpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEUz8gV7yqHCtFKUzno+n+JILWViIKEHt95jTv2kOlKHVm+TDnk8HuObPGi7k1APK
         O43Hp0Fa3Tp5s81cy+/BV3U2oVfCnEQ02TcohMk5g0Qjk1NjrQ+Y56ZTyyv1ctpTn7
         QsKt80dKRQk81qJ4UPll8qd5o9p5yLwMBuFOfKvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Huey <me@kylehuey.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 5.15 096/110] x86/perf: Default set FREEZE_ON_SMI for all
Date:   Mon,  7 Feb 2022 12:07:09 +0100
Message-Id: <20220207103805.641038111@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a01994f5e5c79d3a35e5e8cf4252c7f2147323c3 upstream.

Kyle reported that rr[0] has started to malfunction on Comet Lake and
later CPUs due to EFI starting to make use of CPL3 [1] and the PMU
event filtering not distinguishing between regular CPL3 and SMM CPL3.

Since this is a privilege violation, default disable SMM visibility
where possible.

Administrators wanting to observe SMM cycles can easily change this
using the sysfs attribute while regular users don't have access to
this file.

[0] https://rr-project.org/

[1] See the Intel white paper "Trustworthy SMM on the Intel vPro Platform"
at https://bugzilla.kernel.org/attachment.cgi?id=300300, particularly the
end of page 5.

Reported-by: Kyle Huey <me@kylehuey.com>
Suggested-by: Andrew Cooper <Andrew.Cooper3@citrix.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Link: https://lkml.kernel.org/r/YfKChjX61OW4CkYm@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4654,6 +4654,19 @@ static __initconst const struct x86_pmu
 	.lbr_read		= intel_pmu_lbr_read_64,
 	.lbr_save		= intel_pmu_lbr_save,
 	.lbr_restore		= intel_pmu_lbr_restore,
+
+	/*
+	 * SMM has access to all 4 rings and while traditionally SMM code only
+	 * ran in CPL0, 2021-era firmware is starting to make use of CPL3 in SMM.
+	 *
+	 * Since the EVENTSEL.{USR,OS} CPL filtering makes no distinction
+	 * between SMM or not, this results in what should be pure userspace
+	 * counters including SMM data.
+	 *
+	 * This is a clear privilege issue, therefore globally disable
+	 * counting SMM by default.
+	 */
+	.attr_freeze_on_smi	= 1,
 };
 
 static __init void intel_clovertown_quirk(void)


