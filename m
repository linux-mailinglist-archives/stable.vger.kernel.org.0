Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C5F6AF345
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjCGTC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjCGTCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:02:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F9CBC79B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:48:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3957A61532
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1DDC433EF;
        Tue,  7 Mar 2023 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214916;
        bh=rAbAtauK0hmbO+K/zGADhjS5szni4drmaDh+sO7qiO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTs7I4y4WE2yO1/YhJBsMOFgTWrm7n7GOw4q06Y26E0itlM/QlRXS+9mN9agsxKk/
         uLwLsC8TYkTgoSJpNVXyH3m7tBGYHYitk5vNGq/NnwdtcFZhHwF/VxiQ02gf4H1KSB
         b3F88gYeUtF7r6ZIGPd+UPuvuJx99HRccUDD5e2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arjan <8vvbbqzo567a@nospam.xutrox.com>,
        Kevin Brace <kevinbrace@gmx.com>,
        silviazhao <silviazhao-oc@zhaoxin.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/567] x86/perf/zhaoxin: Add stepping check for ZXC
Date:   Tue,  7 Mar 2023 17:56:37 +0100
Message-Id: <20230307165908.538735707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: silviazhao <silviazhao-oc@zhaoxin.com>

[ Upstream commit fd636b6a9bc6034f2e5bb869658898a2b472c037 ]

Some of Nano series processors will lead GP when accessing
PMC fixed counter. Meanwhile, their hardware support for PMC
has not announced externally. So exclude Nano CPUs from ZXC
by checking stepping information. This is an unambiguous way
to differentiate between ZXC and Nano CPUs.

Following are Nano and ZXC FMS information:
Nano FMS: Family=6, Model=F, Stepping=[0-A][C-D]
ZXC FMS:  Family=6, Model=F, Stepping=E-F OR
          Family=6, Model=0x19, Stepping=0-3

Fixes: 3a4ac121c2ca ("x86/perf: Add hardware performance events support for Zhaoxin CPU.")

Reported-by: Arjan <8vvbbqzo567a@nospam.xutrox.com>
Reported-by: Kevin Brace <kevinbrace@gmx.com>
Signed-off-by: silviazhao <silviazhao-oc@zhaoxin.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=212389
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/zhaoxin/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index 949d845c922b4..3e9acdaeed1ec 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -541,7 +541,13 @@ __init int zhaoxin_pmu_init(void)
 
 	switch (boot_cpu_data.x86) {
 	case 0x06:
-		if (boot_cpu_data.x86_model == 0x0f || boot_cpu_data.x86_model == 0x19) {
+		/*
+		 * Support Zhaoxin CPU from ZXC series, exclude Nano series through FMS.
+		 * Nano FMS: Family=6, Model=F, Stepping=[0-A][C-D]
+		 * ZXC FMS: Family=6, Model=F, Stepping=E-F OR Family=6, Model=0x19, Stepping=0-3
+		 */
+		if ((boot_cpu_data.x86_model == 0x0f && boot_cpu_data.x86_stepping >= 0x0e) ||
+			boot_cpu_data.x86_model == 0x19) {
 
 			x86_pmu.max_period = x86_pmu.cntval_mask >> 1;
 
-- 
2.39.2



