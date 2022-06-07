Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D13541A94
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354078AbiFGVgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377850AbiFGVeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:34:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1922A1737C3;
        Tue,  7 Jun 2022 12:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CACCB82182;
        Tue,  7 Jun 2022 19:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB244C34115;
        Tue,  7 Jun 2022 19:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628667;
        bh=4FWVvpGIVHGySV3NM6oA2OJC61WladjaOASJ3N08TN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tx27bJy5uduz6WK809FYJe32YJuNbNzPOTIFNo59y+Z/cMDtrK9O8gRsBtY/Ffp5x
         s0QDxqtRKeh1ZvPqycIZjlKsWsos2gn4sPuBY0Q5kVEUG1Bt1kVHwPQ9CLSri7kn0/
         YKezIJel+ZwPF5hcLwwMCDSL4Vd6l50Qf5Vk9xJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 410/879] perf/amd/ibs: Use interrupt regs ip for stack unwinding
Date:   Tue,  7 Jun 2022 18:58:48 +0200
Message-Id: <20220607165014.763007405@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 3d47083b9ff46863e8374ad3bb5edb5e464c75f8 ]

IbsOpRip is recorded when IBS interrupt is triggered. But there is
a skid from the time IBS interrupt gets triggered to the time the
interrupt is presented to the core. Meanwhile processor would have
moved ahead and thus IbsOpRip will be inconsistent with rsp and rbp
recorded as part of the interrupt regs. This causes issues while
unwinding stack using the ORC unwinder as it needs consistent rip,
rsp and rbp. Fix this by using rip from interrupt regs instead of
IbsOpRip for stack unwinding.

Fixes: ee9f8fce99640 ("x86/unwind: Add the ORC unwinder")
Reported-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220429051441.14251-1-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 367ca899e6e8..2704ec1e42a3 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -304,6 +304,16 @@ static int perf_ibs_init(struct perf_event *event)
 	hwc->config_base = perf_ibs->msr;
 	hwc->config = config;
 
+	/*
+	 * rip recorded by IbsOpRip will not be consistent with rsp and rbp
+	 * recorded as part of interrupt regs. Thus we need to use rip from
+	 * interrupt regs while unwinding call stack. Setting _EARLY flag
+	 * makes sure we unwind call-stack before perf sample rip is set to
+	 * IbsOpRip.
+	 */
+	if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
+		event->attr.sample_type |= __PERF_SAMPLE_CALLCHAIN_EARLY;
+
 	return 0;
 }
 
@@ -687,6 +697,14 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 		data.raw = &raw;
 	}
 
+	/*
+	 * rip recorded by IbsOpRip will not be consistent with rsp and rbp
+	 * recorded as part of interrupt regs. Thus we need to use rip from
+	 * interrupt regs while unwinding call stack.
+	 */
+	if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
+		data.callchain = perf_callchain(event, iregs);
+
 	throttle = perf_event_overflow(event, &data, &regs);
 out:
 	if (throttle) {
-- 
2.35.1



