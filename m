Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625C65F8EC8
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 23:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiJIVIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 17:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiJIVI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 17:08:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E73038447;
        Sun,  9 Oct 2022 14:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B7EB80DD0;
        Sun,  9 Oct 2022 20:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9F7C43470;
        Sun,  9 Oct 2022 20:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348914;
        bh=QXsB1UeFj8V1ql0mB2W4Auyo9lJtoymLc8ydxAXl2HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zi0AiacTZKNK1VSazt/I3tjqHkc/tjYQYWE+vow/tk+YyIaeqoQ7icdbxGEbFFhTo
         9TqNXhGz7CM+fyQziFI8l9rlMFWLs6tJR6uExdTOpTW54l1VVnKST1TmSC2Y4MiGRm
         7bm/k6YAmvkU+t4swGtdvo72yghnoGc9dL2/UMiSdIyCODe7wDttMDtmxis3fWHPwZ
         ryGraDG0vC4ivokzMS83N6LZCdQ1Ti0b+ouuZO4kOtu4LC+uM+aSIliOQ/pehpipd7
         pymII1PaaNJrGlOXsKTQX2O7+llnsUTEY5dE4oClhvQc4ayWKoFCMr3J9isihC1n6x
         Cs0popsf853Mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Qin <chao.qin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/4] powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue
Date:   Sun,  9 Oct 2022 16:55:07 -0400
Message-Id: <20221009205508.1204042-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205508.1204042-1-sashal@kernel.org>
References: <20221009205508.1204042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Qin <chao.qin@intel.com>

[ Upstream commit 2d93540014387d1c73b9ccc4d7895320df66d01b ]

When value < time_unit, the parameter of ilog2() will be zero and
the return value is -1. u64(-1) is too large for shift exponent
and then will trigger shift-out-of-bounds:

shift exponent 18446744073709551615 is too large for 32-bit type 'int'
Call Trace:
 rapl_compute_time_window_core
 rapl_write_data_raw
 set_time_window
 store_constraint_time_window_us

Signed-off-by: Chao Qin <chao.qin@intel.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index 8809c1a20bed..5f31606e1982 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1080,6 +1080,9 @@ static u64 rapl_compute_time_window_core(struct rapl_package *rp, u64 value,
 		y = value & 0x1f;
 		value = (1 << y) * (4 + f) * rp->time_unit / 4;
 	} else {
+		if (value < rp->time_unit)
+			return 0;
+
 		do_div(value, rp->time_unit);
 		y = ilog2(value);
 		f = div64_u64(4 * (value - (1 << y)), 1 << y);
-- 
2.35.1

