Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C34999C9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378457AbiAXVha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447467AbiAXVKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F61C09D306;
        Mon, 24 Jan 2022 12:08:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 681F1B81215;
        Mon, 24 Jan 2022 20:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93393C340E5;
        Mon, 24 Jan 2022 20:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054929;
        bh=Or7GSkXzoVtS/Y66OyTISEOtYo4mULGloYLLh4FWCl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGeR3Ytfz+DXWF+cJgNZSLxAudWBL6nTH5kp3yro5EwCS/eWbefeMP84Fb3/E1ObJ
         ADe3UW+v2W7slA1uvP7/IUSM2ViS5cdft8gfxaQJ31Unjx8f4DiDu+xgtmGWFUYXNx
         q29S21r3YAw+ld1GyrHPdx32IE/6r6YJk7nVLEd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Bracey <kevin@bracey.fi>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 550/563] net_sched: restore "mpu xxx" handling
Date:   Mon, 24 Jan 2022 19:45:15 +0100
Message-Id: <20220124184043.458620209@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Bracey <kevin@bracey.fi>

commit fb80445c438c78b40b547d12b8d56596ce4ccfeb upstream.

commit 56b765b79e9a ("htb: improved accuracy at high rates") broke
"overhead X", "linklayer atm" and "mpu X" attributes.

"overhead X" and "linklayer atm" have already been fixed. This restores
the "mpu X" handling, as might be used by DOCSIS or Ethernet shaping:

    tc class add ... htb rate X overhead 4 mpu 64

The code being fixed is used by htb, tbf and act_police. Cake has its
own mpu handling. qdisc_calculate_pkt_len still uses the size table
containing values adjusted for mpu by user space.

iproute2 tc has always passed mpu into the kernel via a tc_ratespec
structure, but the kernel never directly acted on it, merely stored it
so that it could be read back by `tc class show`.

Rather, tc would generate length-to-time tables that included the mpu
(and linklayer) in their construction, and the kernel used those tables.

Since v3.7, the tables were no longer used. Along with "mpu", this also
broke "overhead" and "linklayer" which were fixed in 01cb71d2d47b
("net_sched: restore "overhead xxx" handling", v3.10) and 8a8e3d84b171
("net_sched: restore "linklayer atm" handling", v3.11).

"overhead" was fixed by simply restoring use of tc_ratespec::overhead -
this had originally been used by the kernel but was initially omitted
from the new non-table-based calculations.

"linklayer" had been handled in the table like "mpu", but the mode was
not originally passed in tc_ratespec. The new implementation was made to
handle it by getting new versions of tc to pass the mode in an extended
tc_ratespec, and for older versions of tc the table contents were analysed
at load time to deduce linklayer.

As "mpu" has always been given to the kernel in tc_ratespec,
accompanying the mpu-based table, we can restore system functionality
with no userspace change by making the kernel act on the tc_ratespec
value.

Fixes: 56b765b79e9a ("htb: improved accuracy at high rates")
Signed-off-by: Kevin Bracey <kevin@bracey.fi>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Vimalkumar <j.vimal@gmail.com>
Link: https://lore.kernel.org/r/20220112170210.1014351-1-kevin@bracey.fi
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |    5 +++++
 net/sched/sch_generic.c   |    1 +
 2 files changed, 6 insertions(+)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1261,6 +1261,7 @@ struct psched_ratecfg {
 	u64	rate_bytes_ps; /* bytes per second */
 	u32	mult;
 	u16	overhead;
+	u16	mpu;
 	u8	linklayer;
 	u8	shift;
 };
@@ -1270,6 +1271,9 @@ static inline u64 psched_l2t_ns(const st
 {
 	len += r->overhead;
 
+	if (len < r->mpu)
+		len = r->mpu;
+
 	if (unlikely(r->linklayer == TC_LINKLAYER_ATM))
 		return ((u64)(DIV_ROUND_UP(len,48)*53) * r->mult) >> r->shift;
 
@@ -1292,6 +1296,7 @@ static inline void psched_ratecfg_getrat
 	res->rate = min_t(u64, r->rate_bytes_ps, ~0U);
 
 	res->overhead = r->overhead;
+	res->mpu = r->mpu;
 	res->linklayer = (r->linklayer & TC_LINKLAYER_MASK);
 }
 
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1386,6 +1386,7 @@ void psched_ratecfg_precompute(struct ps
 {
 	memset(r, 0, sizeof(*r));
 	r->overhead = conf->overhead;
+	r->mpu = conf->mpu;
 	r->rate_bytes_ps = max_t(u64, conf->rate, rate64);
 	r->linklayer = (conf->linklayer & TC_LINKLAYER_MASK);
 	r->mult = 1;


