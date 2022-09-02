Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C67C5AB3EF
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237140AbiIBOpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237146AbiIBOpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:45:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E4E6B173;
        Fri,  2 Sep 2022 07:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48965B82AC6;
        Fri,  2 Sep 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94244C433C1;
        Fri,  2 Sep 2022 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121810;
        bh=QjSZCYmT1sbZDjiyqBgLgnsWSWpH1v+Ns5lCvl/ZFLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hv0cdPCsaGfQE0z8GXknqgtWRmlmomRmntPsOOyBLeVfaSRrOWUx2FE1iizfDQ/Wl
         pGl+9IuEUJOVx4JX55p2H/eLIq5wN66LpoiMM6P/C/7xGBxTFbxbM+5j21GB89UIqR
         ACGStFssEdsdEtZvWoc7WdYjgZHPWCLWYwkVxvwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 73/77] lib/vdso: Mark do_hres() and do_coarse() as __always_inline
Date:   Fri,  2 Sep 2022 14:19:22 +0200
Message-Id: <20220902121406.112426098@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andrei Vagin <avagin@gmail.com>

[ Upstream commit c966533f8c6c45f93c52599f8460e7695f0b7eaa ]

Performance numbers for Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz
(more clock_gettime() cycles - the better):

clock            | before     | after      | diff
----------------------------------------------------------
monotonic        |  153222105 |  166775025 | 8.8%
monotonic-coarse |  671557054 |  691513017 | 3.0%
monotonic-raw    |  147116067 |  161057395 | 9.5%
boottime         |  153446224 |  166962668 | 9.1%

The improvement for arm64 for monotonic and boottime is around 3.5%.

clock            | before     | after      | diff
==================================================
monotonic          17326692     17951770     3.6%
monotonic-coarse   43624027     44215292     1.3%
monotonic-raw      17541809     17554932     0.1%
boottime           17334982     17954361     3.5%

[ tglx: Avoid the goto ]

Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20191112012724.250792-3-dima@arista.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vdso/gettimeofday.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index c549e72758aa0..5667fb746a1fe 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -38,7 +38,7 @@ u64 vdso_calc_delta(u64 cycles, u64 last, u64 mask, u32 mult)
 }
 #endif
 
-static int do_hres(const struct vdso_data *vd, clockid_t clk,
+static __always_inline int do_hres(const struct vdso_data *vd, clockid_t clk,
 		   struct __kernel_timespec *ts)
 {
 	const struct vdso_timestamp *vdso_ts = &vd->basetime[clk];
@@ -68,8 +68,8 @@ static int do_hres(const struct vdso_data *vd, clockid_t clk,
 	return 0;
 }
 
-static int do_coarse(const struct vdso_data *vd, clockid_t clk,
-		      struct __kernel_timespec *ts)
+static __always_inline int do_coarse(const struct vdso_data *vd, clockid_t clk,
+				     struct __kernel_timespec *ts)
 {
 	const struct vdso_timestamp *vdso_ts = &vd->basetime[clk];
 	u32 seq;
@@ -99,13 +99,15 @@ __cvdso_clock_gettime_common(clockid_t clock, struct __kernel_timespec *ts)
 	 */
 	msk = 1U << clock;
 	if (likely(msk & VDSO_HRES))
-		return do_hres(&vd[CS_HRES_COARSE], clock, ts);
+		vd = &vd[CS_HRES_COARSE];
 	else if (msk & VDSO_COARSE)
 		return do_coarse(&vd[CS_HRES_COARSE], clock, ts);
 	else if (msk & VDSO_RAW)
-		return do_hres(&vd[CS_RAW], clock, ts);
+		vd = &vd[CS_RAW];
+	else
+		return -1;
 
-	return -1;
+	return do_hres(vd, clock, ts);
 }
 
 static __maybe_unused int
-- 
2.35.1



