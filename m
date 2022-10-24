Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FAE60A5F6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiJXMbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbiJXM3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7C0876B1;
        Mon, 24 Oct 2022 05:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB95561295;
        Mon, 24 Oct 2022 11:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1482C433C1;
        Mon, 24 Oct 2022 11:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612350;
        bh=Xdon2nvoGD4MV8vws9pMZ7TJIM8qOOsBVdwLNw/twmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWQw1KSBqFRU+stAACUmfFabr5W/N4zcx4gxlScIMcM6rAa8gIoKmFln31FjpjOsQ
         tOoGIzgB3mbnE5ORomKOUQi9BFZbfCjY8XMtbSpDed2G5jIHthA03aKV0xhPGcEOXp
         gzrLZqg913HWjJxyNKQ67BtyoofDvHuyBlwpY+3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Qin <chao.qin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 163/210] powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue
Date:   Mon, 24 Oct 2022 13:31:20 +0200
Message-Id: <20221024113002.259840081@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
index 54ddd78924dd..5c07e04db421 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1066,6 +1066,9 @@ static u64 rapl_compute_time_window_core(struct rapl_package *rp, u64 value,
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



