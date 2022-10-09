Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D5E5F8EB2
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 23:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiJIVDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 17:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiJIVCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 17:02:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF15238451;
        Sun,  9 Oct 2022 13:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C05860CBB;
        Sun,  9 Oct 2022 20:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18EFC433D7;
        Sun,  9 Oct 2022 20:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348869;
        bh=ftzICmIaYa6X+2Y3LTRSb2ARZqMPbOVnX0qX51ONXuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXI3zTNg525dUrpEPT16gG19sLOUA5dgBeS/C7tg/bCM82cfYEFeeTKCP1Mxnr4B1
         sY+dduGjMRVsIG9YlLBhj2WFvyFI4IGBu3TIAHSA11hNn4LiEd8BlySmTp56EoJNCb
         Dkne29u2sr6xNG/WkEy502u9yuKEdIFLcusMPtTh+lG/QfAi4mu2slT8l6r7eBwDDX
         NNeXZftBeDR1k62/3qg2Q3u0GVhCKBkTYPonYNrCM5trUjsSkU6AtUqwOXWgNym6PU
         o3r+9+U+WgX9BOclSwCyZaN1hMWP/YCw7O1YKWkZ1p9qS5Falnyy6CPCw31tH7xLJp
         fzBSRspEg87mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Qin <chao.qin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/6] powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue
Date:   Sun,  9 Oct 2022 16:54:19 -0400
Message-Id: <20221009205423.1203538-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205423.1203538-1-sashal@kernel.org>
References: <20221009205423.1203538-1-sashal@kernel.org>
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
 drivers/powercap/intel_rapl_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 925b0004a0ed..d5a505f32260 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -885,6 +885,9 @@ static u64 rapl_compute_time_window_core(struct rapl_package *rp, u64 value,
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

