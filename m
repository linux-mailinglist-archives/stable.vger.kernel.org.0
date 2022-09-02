Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCA45AB0CA
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbiIBM7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238521AbiIBM66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:58:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994CE100B;
        Fri,  2 Sep 2022 05:40:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 275BDB82A8B;
        Fri,  2 Sep 2022 12:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCAAC433D6;
        Fri,  2 Sep 2022 12:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122379;
        bh=bZOdvd7tVKQAveBefOzuydtnXtRslrZSGWeFKUZsUMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmp8wl9nHotw2Q17jcQvcocvl00L7elzppSlCY7wYZ/nDhGEnCR5RPfS+eZvkGcAI
         UPWi0YuI4ptSBw80Ye2+OCtW+nyq/S2JV57Yquc3xG6Y0VIGZzSnJmQYUlWK7hBic4
         pNyUgeyjKbR0jHD+tTZMoWcqUJELu0aEwHQMyFUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/37] lib/vdso: Mark do_hres_timens() and do_coarse_timens() __always_inline()
Date:   Fri,  2 Sep 2022 14:19:50 +0200
Message-Id: <20220902121400.049401850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 58efe9f696cf908f40d6672aeca81cb2ad2bc762 ]

In the same spirit as commit c966533f8c6c ("lib/vdso: Mark do_hres()
and do_coarse() as __always_inline"), mark do_hres_timens() and
do_coarse_timens() __always_inline.

The measurement below in on a non timens process, ie on the fastest path.

On powerpc32, without the patch:

clock-gettime-monotonic-raw:    vdso: 1155 nsec/call
clock-gettime-monotonic-coarse:    vdso: 813 nsec/call
clock-gettime-monotonic:    vdso: 1076 nsec/call

With the patch:

clock-gettime-monotonic-raw:    vdso: 1100 nsec/call
clock-gettime-monotonic-coarse:    vdso: 667 nsec/call
clock-gettime-monotonic:    vdso: 1025 nsec/call

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/90dcf45ebadfd5a07f24241551c62f619d1cb930.1617209142.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vdso/gettimeofday.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index 2919f16981404..c6f6dee087460 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -46,8 +46,8 @@ static inline bool vdso_cycles_ok(u64 cycles)
 #endif
 
 #ifdef CONFIG_TIME_NS
-static int do_hres_timens(const struct vdso_data *vdns, clockid_t clk,
-			  struct __kernel_timespec *ts)
+static __always_inline int do_hres_timens(const struct vdso_data *vdns, clockid_t clk,
+					  struct __kernel_timespec *ts)
 {
 	const struct vdso_data *vd = __arch_get_timens_vdso_data();
 	const struct timens_offset *offs = &vdns->offset[clk];
@@ -97,8 +97,8 @@ static __always_inline const struct vdso_data *__arch_get_timens_vdso_data(void)
 	return NULL;
 }
 
-static int do_hres_timens(const struct vdso_data *vdns, clockid_t clk,
-			  struct __kernel_timespec *ts)
+static __always_inline int do_hres_timens(const struct vdso_data *vdns, clockid_t clk,
+					  struct __kernel_timespec *ts)
 {
 	return -EINVAL;
 }
@@ -159,8 +159,8 @@ static __always_inline int do_hres(const struct vdso_data *vd, clockid_t clk,
 }
 
 #ifdef CONFIG_TIME_NS
-static int do_coarse_timens(const struct vdso_data *vdns, clockid_t clk,
-			    struct __kernel_timespec *ts)
+static __always_inline int do_coarse_timens(const struct vdso_data *vdns, clockid_t clk,
+					    struct __kernel_timespec *ts)
 {
 	const struct vdso_data *vd = __arch_get_timens_vdso_data();
 	const struct vdso_timestamp *vdso_ts = &vd->basetime[clk];
@@ -188,8 +188,8 @@ static int do_coarse_timens(const struct vdso_data *vdns, clockid_t clk,
 	return 0;
 }
 #else
-static int do_coarse_timens(const struct vdso_data *vdns, clockid_t clk,
-			    struct __kernel_timespec *ts)
+static __always_inline int do_coarse_timens(const struct vdso_data *vdns, clockid_t clk,
+					    struct __kernel_timespec *ts)
 {
 	return -1;
 }
-- 
2.35.1



