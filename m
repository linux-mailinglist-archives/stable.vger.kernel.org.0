Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA6660A33D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiJXLxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiJXLwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C27209B9;
        Mon, 24 Oct 2022 04:44:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED28E61274;
        Mon, 24 Oct 2022 11:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC02C433B5;
        Mon, 24 Oct 2022 11:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611823;
        bh=QXsB1UeFj8V1ql0mB2W4Auyo9lJtoymLc8ydxAXl2HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wi9JG5UIfTVM6UlQ7eL1nnTdhknBslI7S49/jUBPR7+VFTY1W48RlPG8wphXbVIPy
         j3uxREB/lYeeLt6NOqJ7tdqC+E4chjBUJiZNi+wqaSx016UmsYnNv7Ro52Bufqrbts
         TVqwy3MBrZksGEWcnpCh7BENIOTPdJ9xy/R9yXRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Qin <chao.qin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 125/159] powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue
Date:   Mon, 24 Oct 2022 13:31:19 +0200
Message-Id: <20221024112954.072601249@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



